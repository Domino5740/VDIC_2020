class driver extends uvm_component;
	`uvm_component_utils(driver)
	
	virtual alu_bfm bfm;
	uvm_get_port #(command_s) command_port;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual alu_bfm)::get(null, "*", "bfm", bfm))
			$fatal(1, "Failed to get BFM");
		command_port = new("command_port", this);
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);
		command_s command;
		
		forever begin : command_loop
			command_port.get(command);
			bfm.test_op(command.A_data, command.B_data, command.tester_op_set);
		end : command_loop
	endtask : run_phase
	
endclass : driver