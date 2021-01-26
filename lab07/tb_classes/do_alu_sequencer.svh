/******************************************************************************
* DVT CODE TEMPLATE: sequencer
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_sequencer
`define IFNDEF_GUARD_do_alu_sequencer

//------------------------------------------------------------------------------
//
// CLASS: do_alu_sequencer
//
//------------------------------------------------------------------------------

class do_alu_sequencer extends uvm_sequencer #(do_alu_item);
	
	`uvm_component_utils(do_alu_sequencer)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : do_alu_sequencer

`endif // IFNDEF_GUARD_do_alu_sequencer
