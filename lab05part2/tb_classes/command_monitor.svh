class command_monitor extends uvm_component;
	`uvm_component_utils(command_monitor)
	
	uvm_analysis_port #(random_command) ap;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		
		alu_agent_config alu_agent_config_h;
		
		if(!uvm_config_db #(alu_agent_config)::get(this, "", "config", alu_agent_config_h))
			$fatal(1, "Failed to get config");
		
		alu_agent_config_h.bfm.command_monitor_h = this;
		ap = new("ap", this);
		
	endfunction : build_phase
	
	function void write_to_monitor(random_command cmd);
		ap.write(cmd);
	endfunction : write_to_monitor
	
endclass : command_monitor