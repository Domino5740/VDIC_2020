package alu_pkg;

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
	
`include "coverage.svh"
`include "tester.svh"
`include "scoreboard.svh"
`include "testbench.svh"

endpackage : alu_pkg