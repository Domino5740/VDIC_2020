/******************************************************************************
* DVT CODE TEMPLATE: random test
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_random_test
`define IFNDEF_GUARD_do_alu_random_test

class  do_alu_random_test extends do_alu_base_test;

	`uvm_component_utils(do_alu_random_test)

	function new(string name = "do_alu_random_test", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this,
			"m_env.m_do_alu_agent.m_sequencer.run_phase",
			"default_sequence",
			do_alu_random_sequence::type_id::get());
       	// Create the env
		super.build_phase(phase);
	endfunction

endclass

`endif // IFNDEF_GUARD_do_alu_random_test
