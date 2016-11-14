#include "simulateur.h"

void evaluate(const uword opcode, Machine &machine, Param &param) {
	switch (opcode>>12) {
		case 0b0000: //wmem
			machine.memory[machine.registers[toUWord(opcode)]] = machine.registers[(opcode>>4)&0xF];
			machine.pc++;
			break;
		case 0b0001: //add
			if (opcode & (1<<11)) {
				machine.registers[getDestination(opcode)] = machine.registers[(opcode>>4)&0xF] + toUWord(opcode);
			} else {
				machine.registers[getDestination(opcode)] = machine.registers[(opcode>>4)&0xF] + machine.registers[toUWord(opcode)];
			}
			machine.pc++;
			break;
		case 0b0010: //sub
			if (opcode & (1<<11)) {
				machine.registers[getDestination(opcode)] = machine.registers[(opcode>>4)&0xF] - toUWord(opcode);
			} else {
				machine.registers[getDestination(opcode)] = machine.registers[(opcode>>4)&0xF] - machine.registers[toUWord(opcode)];
			}
			machine.pc++;
			break;
		case 0b0011:{ //snif
			word a = machine.registers[(opcode>>4) & 0xF];
			word b = (opcode & (1<<11))? toWord(opcode) : machine.registers[toUWord(opcode)];

			switch (getDestination(opcode)) {
				case 0b000:
					machine.pc += (a == b);
					break;
				case 0b001:
					machine.pc +=  (a != b);
					break;
				case 0b010:
					machine.pc += (a > b);
					break;
				case 0b011:
					machine.pc += (a < b);
					break;
				case 0b100:
					machine.pc += ((uword)a >  (uword)b);
					break;
				case 0b101:
					machine.pc += ((uword)a >= (uword)b);
					break;
				case 0b110:
					machine.pc += ((uword)a < (uword)b);
					break;
				case 0b111:
					machine.pc += ((uword)a <= (uword)b);
					break;
			}
			machine.pc++;
			break;}
		case 0b0100:{ //and
			word a = machine.registers[(opcode>>4) & 0xF];
			word b = (opcode & (1<<11)) ? toWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a & b;
			machine.pc++;
			break;}
		case 0b0101:{ //or
			word a = machine.registers[(opcode>>4) & 0xF];
			word b = (opcode & (1<<11)) ? toWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a | b;
			machine.pc++;
			break;}
		case 0b0110:{ //xor
			word a = machine.registers[(opcode>>4) & 0xF];
			word b = (opcode & (1<<11)) ? toWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a ^ b;
			machine.pc++;
			break;}
		case 0b0111: { //lsl
			uword a = machine.registers[(opcode>>4) & 0xF];
			uword b = (opcode & (1<<11))? toUWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a << b;
			machine.pc++;
			break;}
		case 0b1000: { //lsr
			uword a = machine.registers[(opcode>>4) & 0xF];
			uword b = (opcode & (1<<11))? toUWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a >> b;
			machine.pc++;
			break;}
		case 0b1001:{ //asr
			word a = machine.registers[(opcode>>4) & 0xF];
			uword b = (opcode & (1<<11))? toUWord(opcode) : machine.registers[toUWord(opcode)];
			machine.registers[getDestination(opcode)] = a >> b;
			machine.pc++;
			break;}
		case 0b1010: //call
			if (param.skip_call)
					machine.in_call++;
			machine.registers[15] = machine.pc+1;
			machine.pc = ((uword) (opcode & 0xFFF)) * 16;
			break;
		case 0b1011: //jump
			if (opcode == 0b1011000000000001) {
				machine.pc = machine.registers[15];
				if (param.skip_call)
					machine.in_call--;
				
			} else { 
				word t = (opcode & 0xFFF);
				if (t & 0b100000000000) 
					t |= 0xF000;
				machine.pc += t;
			}
			break;
		case 0b1100:{ //letl
			uword d = getExtDestination(opcode);
			machine.registers[d] = (opcode & 0xFF);
			if ((machine.registers[d] >> 7) & 1)
				machine.registers[d] |= 0xFF00;
			machine.pc++;
			break;}
		case 0b1101:{ //leth
			machine.registers[getExtDestination(opcode)] = (machine.registers[getExtDestination(opcode)] & 0x00FF) | ((opcode & 0xFF) << 8);
			machine.pc++;
			break;}
		case 0b1110:
			switch ((opcode >> 10) & 0b11) {
				default: {
					refresh = true;
					while (refresh) {};
					machine.pc++;
					}
			}
			break;
		case 0b1111: //rmem
			machine.pc++;
			if (opcode & 0b10000)
				machine.registers[getExtDestination(opcode)] = machine.registers[toUWord(opcode)];
			else {
				machine.registers[getExtDestination(opcode)] = machine.memory[(uword) machine.registers[toUWord(opcode)]];
			}
			break;
	}
}


void simulate(Machine &machine, Param &param) {
	machine.pc = 0;
	uword previous_pc = -1;
	while (machine.pc != previous_pc) {
		previous_pc = machine.pc;
		evaluate(machine.memory[machine.pc], machine, param);
		if (param.debug_output)
			debug(machine);
		if (param.step_by_step)
			getchar();
	}
}

void fullDebug(Machine &machine, Param &param) {
	machine.pc = 0;
	uword previous_pc = -1;
	bool correct_command = true;
	while (!correct_command || machine.pc != previous_pc) {
		previous_pc = machine.pc;
		correct_command = true;
		for (uword i = machine.pc; i < machine.pc + 10; ++i) {
			if (i >= 0)
				std::cout<<i<<"("<<i<<")"<<":\t"<<dissassemble(machine.memory[i])<<"\n";
			else
				std::cout<<i<<"("<<i<<")"<<":\t\n";
		}
		std::string action;
		std::cin>>action;
		DebugCommand command = parseCommand(action);
		if (command.command == "p") {
			debugRegister(machine, command.number);
			correct_command = false;
		} else {
			for (unsigned int i = 0; i < command.number; ++i) {
				if (command.command == "d") {
					debug(machine);
					correct_command = false;
				}
				else if (command.command == "n") {
					param.skip_call = true;
					while (machine.pc >= 0 && param.skip_call) {
						evaluate(machine.memory[machine.pc], machine, param);
						if (!machine.in_call)
							param.skip_call = false;
					}
				} else if (command.command == "s") {
					evaluate(machine.memory[machine.pc], machine, param);
				} else {
					correct_command = false;
					std::cout<<"Unknown command\n";
				}
			}
		}
		if (command.number != 1 && machine.pc == previous_pc)
			correct_command = false;
	}
}

