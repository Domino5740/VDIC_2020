/******************************************************************************
* DVT CODE TEMPLATE: sequence
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
* uvc_trans = item, seq_name = random_sequence
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_random_sequence
`define IFNDEF_GUARD_do_alu_random_sequence

//------------------------------------------------------------------------------
//
// CLASS: do_alu_random_sequence
//
//------------------------------------------------------------------------------

class do_alu_random_sequence extends do_alu_base_sequence;

	// Item to be used by the sequence
	do_alu_item seq_item;

	`uvm_object_utils(do_alu_random_sequence)

	// new - constructor
	function new(string name = "do_alu_random_sequence");
		super.new(name);
	endfunction : new

	// Sequence body
	task body();

		`uvm_create(seq_item)
		`uvm_info("RANDOM_SEQ", "START", UVM_MEDIUM)
		
		repeat(10000) begin : tester_loop
			
			`uvm_rand_send(seq_item);
			
		end : tester_loop
	endtask : body

endclass : do_alu_random_sequence

`endif // IFNDEF_GUARD_do_alu_random_sequence
