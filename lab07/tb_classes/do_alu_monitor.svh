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

class do_alu_monitor extends uvm_monitor;

	// The virtual interface to HDL signals.
	protected virtual do_alu_if m_do_alu_vif;

	// Configuration object
	protected do_alu_config_obj m_config_obj;

	// Collected item
	protected do_alu_item m_collected_item;

	// Collected item is broadcast on this port
	uvm_analysis_port #(do_alu_item) m_collected_item_port;

	`uvm_component_utils(do_alu_monitor)

	function new (string name, uvm_component parent);
		super.new(name, parent);

		// Allocate collected_item.
		m_collected_item = do_alu_item::type_id::create("m_collected_item", this);

		// Allocate collected_item_port.
		m_collected_item_port = new("m_collected_item_port", this);
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
						reset_monitor();
					end
				end
			join_any

			if (rst_mon_thread) rst_mon_thread.kill();
		end
	endtask : run_phase

	virtual protected task collect_items();
		forever begin
			wait(m_do_alu_vif.new_data);
			m_collected_item.tester_op = m_do_alu_vif.tester_op_set;
			m_do_alu_vif.read_serial_sin(m_collected_item.A_data, m_collected_item.B_data, m_collected_item.sent_4b_CRC, m_collected_item.opcode, m_collected_item.data_error);
			`uvm_info(get_full_name(), $sformatf("Item collected :\n%s", m_collected_item.sprint()), UVM_HIGH)
			m_collected_item_port.write(m_collected_item);
//			if (m_config_obj.m_checks_enable)
//				perform_item_checks();
		end
	endtask : collect_items

	virtual protected function void perform_item_checks();
		// Perform item checks here
	endfunction : perform_item_checks

	virtual protected function void reset_monitor();
		//  Reset monitor specific state variables (e.g. counters, flags, buffers, queues, etc.)
	endfunction : reset_monitor

endclass : do_alu_monitor

`endif // IFNDEF_GUARD_do_alu_monitor
