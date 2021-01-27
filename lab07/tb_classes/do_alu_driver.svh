/******************************************************************************
* DVT CODE TEMPLATE: driver
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_driver
`define IFNDEF_GUARD_do_alu_driver

//------------------------------------------------------------------------------
//
// CLASS: do_alu_driver
//
//------------------------------------------------------------------------------

class do_alu_driver extends uvm_driver #(do_alu_item);

	// The virtual interface to HDL signals.
	protected virtual do_alu_if m_do_alu_vif;

	// Configuration object
	protected do_alu_config_obj m_config_obj;

	`uvm_component_utils(do_alu_driver)

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
			`uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		// Driving should be triggered by an initial reset pulse
		@(negedge m_do_alu_vif.reset)
			do @(posedge m_do_alu_vif.clk);
			while(m_do_alu_vif.reset!==1);
		// Start driving
		get_and_drive();
	endtask : run_phase

	virtual protected task get_and_drive();
		process main_thread; // main thread
		process rst_mon_thread; // reset monitor thread

		forever begin
			// Don't drive during reset
			while(m_do_alu_vif.reset!==1) @(posedge m_do_alu_vif.clk);

			// Get the next item from the sequencer
			seq_item_port.get_next_item(req);
			$cast(rsp, req.clone());
			rsp.set_id_info(req);
			// Drive current transaction
			fork
				// Drive the transaction
				begin
					main_thread=process::self();
					`uvm_info(get_type_name(), $sformatf("do_alu_driver %0d start driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)
					drive_item(rsp);
					`uvm_info(get_type_name(), $sformatf("do_alu_driver %0d done driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)

					if (rst_mon_thread) rst_mon_thread.kill();
				end
				// Monitor the reset signal
				begin
					rst_mon_thread = process::self();
					@(negedge m_do_alu_vif.reset) begin
						// Interrupt current transaction at reset
						if(main_thread) main_thread.kill();
						// Do reset
//						reset_signals();
//						reset_driver();
					end
				end
			join_any

			// Send item_done and a response to the sequencer
			seq_item_port.item_done();
			// If the current transaction was interrupted by a reset you should set a field in the rsp item to indicate this to the sequence
//			seq_item_port.put_response(rsp);
		end
	endtask : get_and_drive
//
//	virtual protected task reset_signals();
//		// Reset the signals to their default values
//	endtask : reset_signals
//
//	virtual protected task reset_driver();
//		// Reset driver specific state variables (e.g. counters, flags, buffers, queues, etc.)
//	endtask : reset_driver

	virtual protected task drive_item(do_alu_item item);
		m_do_alu_vif.test_op(item.A_data, item.B_data, item.tester_op, item.opcode);
	endtask : drive_item

endclass : do_alu_driver

`endif // IFNDEF_GUARD_do_alu_driver
