/******************************************************************************
* DVT CODE TEMPLATE: sequence
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
* uvc_trans = item, seq_name = minmax_sequence
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_minmax_sequence
`define IFNDEF_GUARD_do_alu_minmax_sequence

//------------------------------------------------------------------------------
//
// CLASS: do_alu_minmax_sequence
//
//------------------------------------------------------------------------------

class do_alu_minmax_sequence extends do_alu_base_sequence;
	`uvm_object_utils(do_alu_minmax_sequence)

   	function new (string name = "");
    	super.new(name);
	endfunction : new

	do_alu_item seq_item;
	
	task body();

		`uvm_create(seq_item)
		`uvm_info("RESETTING ALU", "START", UVM_MEDIUM)
		`uvm_rand_send_with(seq_item, {tester_op == rst_op_test;})
		`uvm_info("MINMAX_SEQ", "START", UVM_MEDIUM)
		
		repeat(10000) begin : tester_loop
			
			`uvm_rand_send_with(seq_item, { A_data dist {'h00000000 := 1, ['h00000001 : 'hFFFFFFFE] :/ 1, 'hFFFFFFFF := 1};
                      	B_data dist {'h00000000 := 1, ['h00000001 : 'hFFFFFFFE] :/ 1, 'hFFFFFFFF := 1};})
			
		end : tester_loop
		
	endtask : body

endclass : do_alu_minmax_sequence

`endif // IFNDEF_GUARD_do_alu_minmax_sequence
