#ifndef H_STRUCTS
#define H_STRUCTS

#include <string>
#include <vector>

//constants about the environnement
const int WIDTH = 160;
const int HEIGHT = 128;
const int MEM_SCREEN_BEGIN = 0xb000;

//small definitions of type
typedef uint16_t uword;
typedef int16_t word;

//a variable to control the screen
extern volatile bool refresh;

//what represents our virtual machine
struct Machine {
	uword pc;
	uword registers[16];
	uword memory[0x10000];
	std::vector<uword> program;
	int in_call;
};

//the parameters associated with a simulation
struct Param {
	bool step_by_step;
	bool debug_output;
	bool fast_mode;
	bool full_debug;
	bool skip_call;
};

//a debug command
struct DebugCommand {
	unsigned int number;
	std::string command;
};

 
inline word toWord(const uword word) {
	return (word & 0b1000) ? (word & 0xF) | 0xFFF0 : (word & 0xF);
}
inline uword toUWord(const uword word) {
	return 0x0000 | (word & 0xF);
}
inline uword getDestination(const uword word) {
	return (word >> 8) & 0b111;
}
inline uword getExtDestination(const uword word) {
	return (word >> 8) & 0b1111;
}





#endif 
