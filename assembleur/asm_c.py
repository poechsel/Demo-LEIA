from functools import reduce


class _Erreur:
    def __init__(self, sender, obj, error_type):
        self.file_path = sender.path
        self.file_line = sender.file_line
        self.instr_type = type(sender).__name__.lower().replace("custom", ".")
        self.obj = obj
        self.error_type = error_type
    def __repr__(self):
        return "[Erreur] in file {} on line {} instruction {}: {}, {}".format(self.file_path, self.file_line, self.instr_type, self.obj, self.error_type)
    def __str__(self):
        return self.__repr__()

class _Instruction:
    def __init__(self, s, file_path, file_line, real_line, args_nb = 3, jump_line = 1):
        self.words = s
        self.path = file_path
        self.file_line = file_line
        self.line = real_line
        self.jump_line = jump_line
        self.args_nb = args_nb
    def to_num(self, word):
        if word[:2] == '0x':
            try:
                return int(word, 16)
            except:
                return [_Erreur(self, "Number", "hexadecimal misdefined")]
        elif word[:2] == '0b':
            try:
                return int(word, 2)
            except:
                return [_Erreur(self, "Number", "binary misdefined")]
        elif len(word) >= 3 and ((word[0] == '\'' and word[2] == '\'') or (word[0] == '"' and word[2] == '"')):
            try:    
                return ord(word[1])
            except:
                return [_Erreur(self, "Number", "character misdefined")]
        try:
            return int(word)
        except:
            return [_Erreur(self, "Number", "number misdefined")]

    def check_convert_num(self, number, bits, m, M, type_incoming = "Number"):
        if number < m or number > M:
            return [_Erreur(self, type_incoming, "Not in bound: [{}, {}]".format(m, M))]
        if number < 0:
            return (1<<bits) + number
        return number

    def read_register(self, word, is_destination = False):
        if word[0] != "r":
            return [_Erreur(self, "Register", "this isn't a register")]
        number = self.to_num(word[1:])
        if not isinstance(number, list):
            return self.check_convert_num(number, None, 0, 7 if is_destination else 15, "Register")
    def read_destination(self, word):
        if len(word) < 2 or (word[0] != '[' and word[-1] != ']'):
            return [_Erreur(self, "Destination", "this isn't a correct destination")]
        temp = self.read_register(word[1:-1])
        return temp

    def getValue(self, word, number = None, register = None, destination = None):
        out = []
        out_message = "("
        c = True
        if not number is None:
            out_message += "Number, "
            temp = self.to_num(word)
            if not isinstance(temp, list):
                temp = self.check_convert_num(temp, number[0], number[1], number[2])
                if isinstance(temp, list):
                    out = temp
                    c = False
                else:
                    return ("n", temp)
            else:
                out += temp
        if c and not register is None:
            out_message += "Register, "
            temp = self.read_register(word, register[0])
            if isinstance(temp, list):
                out += temp
            else:
                return ("r", temp)
        if c and not destination is None:
            out_message += "Destination, "
            temp = self.read_destination(word)
            if isinstance(temp, list):
                out += temp
            else:
                return ("d", temp)
        return out + [_Erreur(self, "Type", "This argument should be a {})".format(out_message))]
    def _toOpcode(self, current, env):
        if any((isinstance(c, _Erreur) for c in current)):
            for c in current:
                if isinstance(c, _Erreur):
                    print(c)
            return None
        else:
            return reduce(lambda a, b: a | b, [a<<i for a, i in current])
    def getOpcodes(self, env):
        if len(self.words) <= self.args_nb:
            print(_Erreur(self, "Nombres d'arguments", "not enough"))
            return []
        alls = self.parse(env)
        ops = [self._toOpcode(a, env) for a in alls]
        return [op for op in ops if not op is None]
    def addThing(self, thing, nb):
        if isinstance(thing, list):
            return thing
        if isinstance(thing, tuple):
            thing = thing[1]
        return [(thing, nb)]
    def parse(self, env):
        return []

class CustomInclude(_Instruction):
    def __init__(self, *args):
        super(CustomInclude, self).__init__(*args)
        self.args_nb = 1
class CustomString(_Instruction):
    def __init__(self, *args):
        super(CustomString, self).__init__(*args)
        self.word = " ".join(self.words[1:])
        self.jump_line = len(self.word) - 2 + 1
    def getOpcodes(self, env):
        if not (self.word[0] == "\"" and self.word[-1] == "\""):
            print(_Erreur(self, "String", "Format incorrect"))
            return []
        return [ord(c) for c in self.word[1:-1]] + [0]


class CustomWord(_Instruction):
    def __init__(self, *args):
        super(CustomWord, self).__init__(*args)
        self.args_nb = 1
    def parse(self, env):
        return [self.addThing(self.to_num(self.words[1]), 0)]
    def to_c(self, env):
        return "memory[{}] = {};".format(self.line, self.words[1])

class CustomAlign16(_Instruction):
    def __init__(self, *args):
        super(CustomAlign16, self).__init__(*args)
        self.args_nb = 0
        self.jump_line = 0
        while ((self.line + self.jump_line) % 16) != 0:
            self.jump_line += 1
    def parse(self, env):
        c = []
        for _ in range(self.jump_line):
            c += Copy(["copy", "r0", "r0"], "", "", "").parse(env)
        return c
    def to_c(self, env):
        print("ok")
        env.is_align = True
        return ""

class CustomSet(_Instruction):
    def __init__(self, *args):
        super(CustomSet, self).__init__(*args)
        self.args_nb = 2
        self.jump_line = 2
    def parse(self, env):
        reg = self.read_register(self.words[1])
        if self.words[2] in env.labels:
            lbl = env.labels[self.words[2]]
            return [self.addThing(0b1100, 12) + self.addThing(reg, 8) + self.addThing(lbl & 0x00FF, 0), self.addThing(0b1101, 12) + self.addThing(reg, 8) + self.addThing((lbl & 0xFF00) >> 8, 0)]
        else:
            return [[_Erreur(self, "Label", "not defined")]]
    def to_c(self, ens):
        return "{} = {};".format(self.words[1], env.labels[self.words[2]])

class Push(_Instruction):
    def __init__(self, *args):
        super(CustomSet, self).__init__(*args)
        self.args_nb = 1
        self.jump_line = 1
    def parse(self, env):
        return [self.addThing(0b11101, 11) + self.addThing(self.read_register(self.words[1], False), 0)]

class Pop(_Instruction):
    def __init__(self, *args):
        super(CustomSet, self).__init__(*args)
        self.args_nb = 1
        self.jump_line = 1
    def parse(self, env):
        return [self.addThing(0b111001, 10) + self.addThing(self.read_register(self.words[1], False), 0)]

class Letl(_Instruction):
    def __init__(self, *args):
        super(Letl, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.getValue(self.words[2], (8, -127, 255))
        return [self.addThing(0b1100, 12) + self.addThing(r, 8) + self.addThing(v, 0)]

    def to_c(self, env):
        first_part = "0x0000"
        if self.to_num(self.words[2]) & 0x10000000:
            first_part = "0xFF00"
        snd_part =self.getValue(self.words[2], (8, -127, 255))[1]
        return "{} = {}|{};".format(self.words[1], first_part, snd_part)



class Leth(_Instruction):
    def __init__(self, *args):
        super(Leth, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.getValue(self.words[2], (8, -127, 255))
        return [self.addThing(0b1101, 12) + self.addThing(r, 8) + self.addThing(v, 0)]
    def to_c(self, env):
        return "{} = ({}<<8) | ({} & 0xFF);".format(self.words[1], self.getValue(self.words[2], (8, -127, 255))[1], self.words[1])

"""deprecated"""
class Rmeml(_Instruction):
    def __init__(self, *args):
        super(Rmeml, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.read_destination(self.words[2])
        return [self.addThing(0b1111, 12) + self.addThing(r, 8) + self.addThing(2, 4) + self.addThing(v, 0)]
    def to_c(self, env):
        return "{} = memory[{}];".format(self.words[1], self.words[2])
class Rmem(_Instruction):
    def __init__(self, *args):
        super(Rmem, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.read_destination(self.words[2])
        return [self.addThing(0b1111, 12) + self.addThing(r, 8) + self.addThing(0, 4) + self.addThing(v, 0)]
    def to_c(self, env):
        return "{} = memory[{}];".format(self.words[1], self.words[2][1:-1])
class Copy(_Instruction):
    def __init__(self, *args):
        super(Copy, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.read_register(self.words[2])
        return [self.addThing(0b1111, 12) + self.addThing(r, 8) + self.addThing(1, 4) + self.addThing(v, 0)]
    def to_c(self, env):
        return "{} = {};".format(self.words[1], self.words[2])

class Refresh(_Instruction):
    def __init__(self, *args):
        super(Refresh, self).__init__(*args)
        self.args_nb = 0
    def parse(self, env):
        return [self.addThing(0b1110, 12) + self.addThing(0, 0)]
    def to_c(self, env):
        return "refresh = true; while(refresh) {}"

class Wmem(_Instruction):
    def __init__(self, *args):
        super(Wmem, self).__init__(*args)
        self.args_nb = 2
    def parse(self, env):
        r = self.read_register(self.words[1], False)
        v = self.read_destination(self.words[2])
        return [self.addThing(0b0000, 12) + self.addThing(0, 8) + self.addThing(r, 4) + self.addThing(v, 0)]
    def to_c(self, env):
        return "memory[{}] = {};".format(self.words[2][1:-1], self.words[1])

class _AluInstr(_Instruction):
    def __init__(self, *args, opcode, m = 0, M = 15):
        super(_AluInstr, self).__init__(*args)
        self.args_nb = 3
        self.opcode = opcode
        self.m = m
        self.M = M
    def parse(self, env):
        op = self.opcode
        t = 0
        r_dest = self.read_register(self.words[1], True)
        r_f = self.read_register(self.words[2])
        r_l = self.getValue(self.words[3], (4, self.m, self.M), (False,))
        if isinstance(r_l, tuple):
            t = (r_l[0] == "n")
            r_l = r_l[1]
        return [self.addThing(self.opcode, 12) + self.addThing(t, 11) + self.addThing(r_dest, 8) + self.addThing(r_f, 4) + self.addThing(r_l, 0)]
        

class Jump(_Instruction):
    def __init__(self, *args):
        super(Jump, self).__init__(*args)
        self.args_nb = 1
    def parse(self, env):
        temp = self.to_num(self.words[1])
        if isinstance(temp, list):
            if not self.words[1] in env.labels:
                return [[_Erreur(self, "Label", "not defined")]]
            temp = env.labels[self.words[1]] - self.line           
        temp = self.check_convert_num(temp, 12, -2048, 2047, type_incoming = "Jump")
        if isinstance(temp, list):
            return [[_Erreur(self, "destination", "out of reach")]]
        return [self.addThing(0b1011, 12) + self.addThing(temp, 0)]
    def to_c(self, env):
        if self.words[1] == "0":
            return "goto ____ENDPROGRAM;"
        return "goto {};".format(self.words[1])

class Return(_Instruction):
    def __init__(self, *args):
        super(Return, self).__init__(*args)
        self.args_nb = 0
    def parse(self, env):
        return [self.addThing(0b1011, 12) + self.addThing(1, 0)]
    def to_c(self, env):
        print("->",env.return_lbls)
        print("before", env.labels_to_put)
        if not env.return_lbls in env.labels_to_put:
            env.labels_to_put += [env.return_lbls]

        print("after", env.labels_to_put)
        return "goto {};".format(env.return_lbls)
class Call(_Instruction):
    def __init__(self, *args):
        super(Call, self).__init__(*args)	
        self.args_nb = 1
    def parse(self, env):
        temp = self.to_num(self.words[1])
        if isinstance(temp, list):
            try:
                temp = env.labels[self.words[1]]
            except:
                return [[_Erreur(self, "Label", "not defined")]]
        return [self.addThing(0b1010, 12) + self.addThing(temp >> 4, 0)]
    def to_c(self, env):
        lbl = "____callfct{}".format(self.words[1])
        if not lbl in env.labels_put:
            env.labels_put += [lbl]
        env.labels_to_put = [e for e in env.labels_to_put if e != lbl]
        return "goto {};\n{}:;".format(self.words[1], "____callfct{}".format(self.words[1]))


class Snif(_Instruction):
    def __init__(self, *args):
        super(Snif, self).__init__(*args)
        self.args_nb = 3
    def parse(self, env):
        comp = ["eq", "neq", "sgt", "slt", "gt", "ge", "lt", "le"]
        try:
            comp = comp.index(self.words[2])
        except:
            comp = [_Erreur(self, "Comparaison", "this operator doesn't exist")]
        t = 0
        r_dest = self.read_register(self.words[1], True)
        r_l = self.getValue(self.words[3], (4, -8, 7), (False,))
        if isinstance(r_l, tuple):
            t = r_l[0] == "n"
            r_l = r_l
        return [self.addThing(0b0011, 12) + self.addThing(t, 11) + self.addThing(comp, 8) + self.addThing(r_dest, 4) + self.addThing(r_l, 0)]
    def to_c(self, env):
        if self.words[2] == "eq":
            return "if (!({} == {}))".format(self.words[1], self.words[3])
        elif self.words[2] == "neq":
            return "if (!({} != {}))".format(self.words[1], self.words[3])
        elif self.words[2] == "sgt":
            return "if (!((int16_t){} > (int16_t){}))".format(self.words[1], self.words[3])
        elif self.words[2] == "slt":
            return "if (!((int16_t){} < (int16_t){}))".format(self.words[1], self.words[3])
        elif self.words[2] == "gt":
            return "if (!({} > {}))".format(self.words[1], self.words[3])
        elif self.words[2] == "ge":
            return "if (!({} >= {}))".format(self.words[1], self.words[3])
        elif self.words[2] == "lt":
            return "if (!({} < {}))".format(self.words[1], self.words[3])
        elif self.words[2] == "le":
            return "if (!({} <= {}))".format(self.words[1], self.words[3])

class Add(_AluInstr):
    def __init__(self, *args):
        super(Add, self).__init__(*args, opcode = 0b0001)
    def to_c(self, env):
        return "{} = {} + {};".format(self.words[1], self.words[2], self.words[3])
class Sub(_AluInstr):
    def __init__(self, *args):
        super(Sub, self).__init__(*args, opcode = 0b0010)
    def to_c(self, env):
        return "{} = {} - {};".format(self.words[1], self.words[2], self.words[3])
class And(_AluInstr):
    def __init__(self, *args):
        super(And, self).__init__(*args, opcode = 0b0100, m = -8, M = 7)
    def to_c(self, env):
        return "{} = {} & {};".format(self.words[1], self.words[2], self.words[3])
class Or(_AluInstr):
    def __init__(self, *args):
        super(Or, self).__init__(*args, opcode = 0b0101, m = -8, M = 7)
    def to_c(self, env):
        return "{} = {} | {};".format(self.words[1], self.words[2], self.words[3])
class Xor(_AluInstr):
    def __init__(self, *args):
        super(Xor, self).__init__(*args, opcode = 0b0110, m = -8, M = 7)
    def to_c(self, env):
        return "{} = {} ^ {};".format(self.words[1], self.words[2], self.words[3])
class Lsl(_AluInstr):
    def __init__(self, *args):
        super(Lsl, self).__init__(*args, opcode = 0b0111)
    def to_c(self, env):
        return "{} = (uint16_t){} << {};".format(self.words[1], self.words[2], self.words[3])
class Lsr(_AluInstr):
    def __init__(self, *args):
        super(Lsr, self).__init__(*args, opcode = 0b1000)
    def to_c(self, env):
        return "{} = (uint16_t){} >> {};".format(self.words[1], self.words[2], self.words[3])
class Asr(_AluInstr):
    def __init__(self, *args):
        super(Asr, self).__init__(*args, opcode = 0b1001)
    def to_c(self, env):
        return "{} = (int16_t){} >> {};".format(self.words[1], self.words[2], self.words[3])

import sys, inspect


class _Environment:
    def __init__(self):
        self.line = 0
        self.labels = {}
        self.instr = []
        self.instr_set = {}
        self.is_align = []
        self.return_lbls = None
        self.labels_to_put = []
        self.labels_put = []
        for name, obj in inspect.getmembers(sys.modules[__name__]):
            if inspect.isclass(obj) and "_" != name[0]:
                self.instr_set[name.lower().replace("custom", ".")] = obj
    

def load_file(file_path):
    print(file_path)
    with open(file_path) as file:
        return [(l, line.strip().lower().replace(";", " ;").split()) for l, line in enumerate(file) if line.strip() != '']
 



def c_code(path, f, env):
    c_code = []
    for l in open("assembleur/precode.cpp"):
        c_code += [l]
    
    def getCurLbls(path, f, env):
        instr = []
        for l, line in f:
            if line[0][-1] == ":":
                if line[0] in env.labels:
                    print("[Erreur], ce label est déja défini (ligne {}) in file {}".format(l, path))
                else:
                    env.labels[line[0][:-1]] = env.line
                    if env.is_align:
                        env.is_align = False
                        env.return_lbls = "____callfct{}".format(line[0][:-1])
                    instr += [line[0][:-1] + ":;"]
            elif line[0] in env.instr_set:
                instr += [env.instr_set[line[0]](line, path, l,  env.line)]
                env.line += instr[-1].jump_line
            elif line[0] == "#include":
                instr += getCurLbls(line[1], load_file(line[1]), env)
        return instr

    def getCurCode(instr):
        code = []        
        for i in instr:
            if isinstance(i, CustomWord):
                code.insert(0, i.to_c(env))
            elif isinstance(i, _Instruction):
                code += [i.to_c(env)]
            else:
                if env.is_align:
                    env.is_align = False
                    env.return_lbls = "____callfct{}".format(i[:-2])
                    print("before", env.labels_to_put)
                    #env.labels_to_put = [e for e in env.labels_to_put if e != env.return_lbls]
                    print("before", env.labels_to_put)
                    print(i)
                code += [i]

        print(env.labels_put)
        for e in env.labels_to_put:
            if not e in env.labels_put:
                code += [e + ":;"]
        return code
        """
        for l, line in f:
            if line[0][-1] == ":":
                if line[0] in env.labels:
                    print("[Erreur], ce label est déja défini (ligne {}) in file {}".format(l, path))
                else:
                    env.labels[line[0][:-1]] = env.line
                    code += [line[0][:-1] + ":;"]
            elif line[0] in env.instr_set:
                env.instr += [env.instr_set[line[0]](line, path, l,  env.line)]
                env.line += env.instr[-1].jump_line
                code += [env.instr[-1].to_c(env)]
            elif line[0] == "#include":
                code += getCurCode(line[1], load_file(line[1]), env)
        return code
        """
    c_code += getCurCode(getCurLbls(path, f, env))
    for l in open("assembleur/postcode.cpp"):
        c_code += [l]
    out_c = open("out.cpp", "w")
    for c in c_code:
        out_c.write(c + "\n")
    #print(c_code)

def first_pass(path, f, env):
    c_code = []
    for l, line in f:
        if line[0][-1] == ":":
            if line[0] in env.labels:
                print("[Erreur], ce label est déja défini (ligne {}) in file {}".format(l, path))
            else:
                env.labels[line[0][:-1]] = env.line
        elif line[0] in env.instr_set:
            env.instr += [env.instr_set[line[0]](line, path, l,  env.line)]
            env.line += env.instr[-1].jump_line
        elif line[0] == "#include":
            first_pass(line[1], load_file(line[1]), env)

        else:
            pass
def second_pass(env):
    out = []
    for l in env.instr:
        #print(l, l.getOpcodes(env))
        temp = l.getOpcodes(env)
        for o in temp:
            pass
        out += temp
    return out


path = sys.argv[1]
f = load_file(path)
env = _Environment()
c_code(path, f, env)
first_pass(path, f, env)
code = second_pass(env)

out_path = path.split(".")[0] + ".asm"
out = open(out_path, "w")
for c in code:
    out.write(str(hex(c))[2:].zfill(4) + "\n")
 
