/******************************************************************************
* DVT CODE TEMPLATE: monitor
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_monitor
`define IFNDEF_GUARD_do_alu_monitor

//------------------------------------------------------------------------------
//
// CLASS: do_alu_monitor
//
//------------------------------------------------------------------------------

virtual class do_alu_monitor extends uvm_monitor;

	// The virtual interface to HDL signals.
	protected virtual do_alu_if m_do_alu_vif;

	// Configuration object
	protected do_alu_config_obj m_config_obj;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		// Get the interface
		if(!uvm_config_db#(virtual do_alu_if)::get(this, "", "m_do_alu_vif", m_do_alu_vif))
			`uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".m_do_alu_vif"})

		// Get the configuration object
		if(!uvm_config_db#(do_alu_config_obj)::get(this, "", "m_config_obj", m_config_obj))
			`uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".m_config_obj"})
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		process main_thread; // main thread
		process rst_mon_thread; // reset monitor thread

		// Start monitoring only after an initial reset pulse
		@(negedge m_do_alu_vif.reset)
			do @(posedge m_do_alu_vif.clk);
			while(m_do_alu_vif.reset!==1);
		// Start monitoring
		forever begin
			fork
				// Start the monitoring thread
				begin
					main_thread=process::self();
					collect_items();
				end
				// Monitor the reset signal
				begin
					rst_mon_thread = process::self();
					@(negedge m_do_alu_vif.reset) begin
						// Interrupt current item at reset
						if(main_thread) main_thread.kill();
					end
				end
			join_any

			if (rst_mon_thread) rst_mon_thread.kill();
		end
	endtask : run_phase

	pure virtual protected task collect_items();

endclass : do_alu_monitor

`endif // IFNDEF_GUARD_do_alu_monitor
