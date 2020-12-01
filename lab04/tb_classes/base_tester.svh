virtual class base_tester extends uvm_component;
	`uvm_component_utils(base_tester)
	
	uvm_put_port #(command_s) command_port;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		command_port = new("command_port", this);
	endfunction : build_phase
	
	pure virtual function tester_op_t get_op();
	pure virtual function bit [31:0] get_data();
	
	task run_phase(uvm_phase phase);

		command_s command;
		
		phase.raise_objection(this);
		
		repeat(1000) begin : tester_loop
			
			command.tester_op_set = get_op();
			command.A_data = get_data();
			command.B_data = get_data();
			command_port.put(command);
		end : tester_loop
		
		phase.drop_objection(this);
		
	endtask : run_phase
	
endclass : base_tester