package alu_pkg;

import uvm_pkg::*;
	`include "uvm_macros.svh"

typedef enum bit[2:0] {
	no_op_test		 = 3'b000,
	and_op_test		 = 3'b001,
	or_op_test 		 = 3'b010,
	add_op_test 	 = 3'b011,
	sub_op_test 	 = 3'b100,
	rst_op_test 	 = 3'b101,
	bad_data_op_test = 3'b110,
	bad_crc_op_test  = 3'b111
} tester_op_t;

typedef enum bit[2:0] {
	and_opcode		= 3'b000,
	or_opcode 		= 3'b001,
	add_opcode 		= 3'b100,
	sub_opcode 		= 3'b101,
	no_opcode 		= 3'b111
} opcode_t;
	
typedef enum bit [1:0] {
	DATA = 2'b00,
	CTL = 2'b10,
	ERR = 2'b11
} byte_type_t;
	
typedef struct packed {
	bit signed [31:0] A_data;
	bit signed [31:0] B_data;
	bit [3:0]  sent_4b_CRC;
	tester_op_t tester_op_set;
	opcode_t op_set;
	bit data_error;
} command_s;
	
typedef struct packed {
	bit signed [31:0] C_data;
	bit [3:0] alu_flags;
	bit [2:0] rec_3b_CRC;
	bit [5:0] err_flags;
	bit parity_bit;
} result_s;
	
`include "coverage.svh"
`include "base_tester.svh"
`include "random_tester.svh"
`include "zeros_ones_tester.svh"
`include "scoreboard.svh"
`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"

`include "env.svh"

`include "random_test.svh"
`include "zeros_ones_test.svh"

endpackage : alu_pkg