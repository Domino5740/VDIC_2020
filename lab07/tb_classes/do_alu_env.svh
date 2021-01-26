/******************************************************************************
* DVT CODE TEMPLATE: env
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_env
`define IFNDEF_GUARD_do_alu_env

//------------------------------------------------------------------------------
//
// CLASS: do_alu_env
//
//------------------------------------------------------------------------------

class do_alu_env extends uvm_env;
	
	// Components of the environment
	do_alu_agent m_do_alu_agent;

	`uvm_component_utils(do_alu_env)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		begin
			// Create the configuration object if it has not been set
			do_alu_config_obj config_obj;
			if(!uvm_config_db#(do_alu_config_obj)::get(this, "", "m_config_obj", config_obj)) begin
				config_obj = do_alu_config_obj::type_id::create("m_config_obj", this);
				uvm_config_db#(do_alu_config_obj)::set(this, {"m_do_alu_agent","*"}, "m_config_obj", config_obj);
			end

			// Create the agent
			m_do_alu_agent = do_alu_agent::type_id::create("m_do_alu_agent", this);
		end

	endfunction : build_phase

endclass : do_alu_env

`endif // IFNDEF_GUARD_do_alu_env
