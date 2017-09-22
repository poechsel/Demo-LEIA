#include <iostream>
#include <fstream>
#include <vector>
#include <cstdio>
#include <SDL2/SDL.h>
#include <stdint.h>
#include <thread>
#include <signal.h>

#include "debug.h"
#include "screen.h"
#include "simulateur.h"




/* make sure we only read characters belonging to a hexadecimal chain */
std::string stripNonHex(const std::string source) {
	std::string output;
	for (auto c : source) {
		if (('0' <= c && c <= '9')
			|| ('a' <= c && c <= 'f')
			|| ('A' <= c && c <= 'F'))
		output.push_back(c);
	}
	return output;
}

/* convert an hex char to an int */
uword convHex(char c) {
	if ('0' <= c && c <= '9')
		return c - '0';
	if ('a' <= c && c <= 'f')
		return 10 + c - 'a';
	if ('A' <= c && c <= 'F')
		return 10 + c - 'A';
	return 0;
}


/* takes a source and convert it to an array of opcodes */
std::vector<uword> toOpCodes(std::string source) {
	if (source.size() % 4 != 0) {
		printf ("Oups, code incorrect\n");
		return std::vector<uword>();
	}
	std::vector<uword> out;
	for (unsigned int i = 0; i < source.size(); i += 4) {
		uword temp = 0;
		temp |= (convHex(source[i]) << 12);
		temp |= (convHex(source[i+1]) << 8);
		temp |= (convHex(source[i+2]) << 4);
		temp |= (convHex(source[i+3]));
		out.push_back(temp);
	}
	return out;
}


/* read from binary file
 * deprecated but keep, we never know
 * */
bool readFromBin(std::string file_path, Machine &machine) {
	std::ifstream file(file_path, std::ios::binary | std::ios::ate);
	file.seekg(0, std::ios::end);
	auto file_size = file.tellg();
	if ((file_size & 1) == 1) {
		printf("[Erreur], le fichier n'est pas correct\n");
		return false;
	} else {
		file.seekg(0, std::ios::beg);
		unsigned short code[file_size>>1];
	    char current;
		int i = 0;
		while (file.get(current)) {
			code[i] = ((unsigned char) current) << 8;
			file.get(current);
			code[i] |=(unsigned char) current;
			machine.program.push_back(code[i]);
			i++;
		}
		return true;
	}
}

/* load the program from a path */
bool readFromStr(std::string file_path, Machine &machine) {
	std::ifstream file(file_path);
	std::string code_str = std::string((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
	machine.program = toOpCodes(stripNonHex(code_str));
	return true;
}

/* transfer the code to the memory */
void loadCodeToMemory(Machine &machine) {
	for (unsigned int i = 0; i < machine.program.size(); ++i) {
		machine.memory[/*PROGRAM_BEGIN -*/ i] = machine.program[i];
	}
}


bool force_quit = false;
extern volatile bool refresh;
/* function to handle any forced exit */
void handleForceExit(int sig) {
	force_quit = true;
	exit(sig);
}


int main(int argc, char* argv[]) {
	if (argc != 3) {
		printf("Missing parameters\n");
		return 0;
	}
	Param param;
	/* parse the params */
	if (std::string(argv[1]) == "s") {
		param.step_by_step = true;
		param.debug_output = true;
		param.fast_mode = false;
		param.full_debug = false;
		param.skip_call = false;
	} else if (std::string(argv[1]) == "r") {
		param.step_by_step = false;
		param.debug_output = true;
		param.fast_mode = false;
		param.full_debug = false;
		param.skip_call = false;
	} else if (std::string(argv[1]) == "fulldebug") {
		param.step_by_step = false;
		param.debug_output = false;
		param.fast_mode = false;
		param.full_debug = true;
		param.skip_call = false;
	}
	else {
		param.step_by_step = false;
		param.debug_output = false;
		param.fast_mode = true;
		param.full_debug = false;
		param.skip_call = false;
	}

	/* add interruptions for Ctrl+Z or Ctrl+C */
	signal(SIGINT, handleForceExit);
	signal(SIGTSTP, handleForceExit);

	Machine machine;
	machine.in_call = false;
	/* launch the screen with the option to manually refresh the screen deactivated*/
	std::thread screen(simulate_screen, std::ref(machine), std::ref(force_quit), std::ref(refresh), true);
	/* if we can read the program */
	if (readFromStr(argv[2], machine)) {
		loadCodeToMemory(machine);
		Uint32 time_exec = SDL_GetTicks();
		if (!param.full_debug) {
				simulate(machine, param);
		} else {
			fullDebug(machine, param);
		}
		printf("Simulation fini en %dmilli seconds\n", SDL_GetTicks() - time_exec);
		printf("Veuillez appuyer sur une touche ");
		getchar();
		force_quit = true;
		printf("\n");
	}


	screen.join();
	printf("\n");
	return 0;
}
