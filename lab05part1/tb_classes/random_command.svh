class random_command extends uvm_transaction;
	`uvm_object_utils(random_command)
	
	rand bit signed [31:0] A_data;
	rand bit signed [31:0] B_data;
	rand tester_op_t tester_op;
	opcode_t opcode;
	//TODO: remove opcode generation from the bfm, maybe create enum vali_data
	bit [3:0]  sent_4b_CRC;
	bit data_error;
   
   	function new (string name = "");
    	super.new(name);
	endfunction : new

   	virtual function void do_copy(uvm_object rhs);
		random_command copied_random_command_h;

      	if(rhs == null) 
        	`uvm_fatal("RANDOM COMMAND", "Tried to copy from a null pointer")
 
      	super.do_copy(rhs); // copy all parent class data

      	if(!$cast(copied_random_command_h,rhs))
        	`uvm_fatal("RANDOM COMMAND", "Tried to copy wrong type.")
      
      	A_data  = copied_random_command_h.A_data;
      	B_data  = copied_random_command_h.B_data;
      	tester_op = copied_random_command_h.tester_op;
      	opcode = copied_random_command_h.opcode;
      	sent_4b_CRC = copied_random_command_h.sent_4b_CRC;
      	data_error = copied_random_command_h.data_error;
      
   	endfunction : do_copy

   	virtual function random_command clone_me();
	   
	   	random_command clone;
      	uvm_object tmp;

      	tmp = this.clone();
      	$cast(clone, tmp);
      	return clone;
   	endfunction : clone_me
   

   	virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	   	random_command compared_random_command_h;
	   	bit   same;
      
      	if (rhs==null) `uvm_fatal("RANDOM COMMAND", 
                                  "Tried to do comparison to a null pointer");
      
      	if (!$cast(compared_random_command_h,rhs))
	      	same = 0;
      	else
        	same = super.do_compare(rhs, comparer) && 
        		(compared_random_command_h.A_data == A_data) &&
        		(compared_random_command_h.B_data == B_data) &&
               	(compared_random_command_h.tester_op == tester_op) &&
               	(compared_random_command_h.opcode == opcode) &&
               	(compared_random_command_h.sent_4b_CRC == sent_4b_CRC) &&
               	(compared_random_command_h.data_error == data_error);
               
      	return same;
   	endfunction : do_compare

   	virtual function string convert2string();
	   	string s;
     	s = $sformatf("A_data: %8h  B_data: %8h tester_op: %s opcode: %s sent_4b_CRC %1h data_error: %1b",
	     			   A_data, B_data, tester_op.name(), opcode.name(), sent_4b_CRC, data_error);
	   	return s;
   	endfunction : convert2string

endclass : random_command