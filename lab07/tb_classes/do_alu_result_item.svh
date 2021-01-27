/******************************************************************************
* DVT CODE TEMPLATE: sequence item
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu_result
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_result_item
`define IFNDEF_GUARD_do_alu_result_item

//------------------------------------------------------------------------------
//
// CLASS: do_alu_result_item
//
//------------------------------------------------------------------------------

class  do_alu_result_item extends uvm_sequence_item;

	bit signed [31:0] C_data;
	bit [3:0] alu_flags;
	bit [2:0] rec_3b_CRC;
	bit [5:0] err_flags;
	bit parity_bit;

	`uvm_object_utils_begin(do_alu_result_item)
		`uvm_field_int(C_data, UVM_ALL_ON)
		`uvm_field_int(alu_flags, UVM_ALL_ON)
		`uvm_field_int(rec_3b_CRC, UVM_ALL_ON)
		`uvm_field_int(err_flags, UVM_ALL_ON)
		`uvm_field_int(parity_bit, UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "do_alu_result_item");
		super.new(name);
	endfunction : new

endclass :  do_alu_result_item

`endif // IFNDEF_GUARD_do_alu_result_item
