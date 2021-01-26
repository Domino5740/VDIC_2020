/******************************************************************************
* DVT CODE TEMPLATE: monitor
* Created by dorlowski on Jan 26, 2021
* uvc_company = do, uvc_name = alu
*******************************************************************************/

`ifndef IFNDEF_GUARD_do_alu_command_monitor
`define IFNDEF_GUARD_do_alu_command_monitor

//------------------------------------------------------------------------------
//
// CLASS: do_alu_command_monitor
//
//------------------------------------------------------------------------------

class do_alu_command_monitor extends do_alu_monitor;
	
	// Collected item
	protected do_alu_item m_collected_item;

	// Collected item is broadcast on this port
	uvm_analysis_port #(do_alu_item) m_collected_item_port;

	`uvm_component_utils(do_alu_command_monitor)

	function new (string name, uvm_component parent);
		super.new(name, parent);

		// Allocate collected_item.
		m_collected_item = do_alu_item::type_id::create("m_collected_item", this);

		// Allocate collected_item_port.
		m_collected_item_port = new("m_collected_item_port", this);
	endfunction : new
	
	virtual protected task collect_items();
		forever begin
			wait(m_do_alu_vif.new_data);
			m_collected_item.tester_op = m_do_alu_vif.tester_op_set;
			m_do_alu_vif.read_serial_sin(m_collected_item.A_data, m_collected_item.B_data, m_collected_item.sent_4b_CRC, m_collected_item.opcode, m_collected_item.data_error);
			`uvm_info(get_full_name(), $sformatf("Item collected :\n%s", m_collected_item.sprint()), UVM_HIGH)
			m_collected_item_port.write(m_collected_item);
		end
	endtask : collect_items

endclass : do_alu_command_monitor

`endif // IFNDEF_GUARD_do_alu_command_monitor
