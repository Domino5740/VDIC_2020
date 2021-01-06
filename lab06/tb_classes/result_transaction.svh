class result_transaction extends uvm_transaction;
	`uvm_object_utils(result_transaction)
	
	bit signed [31:0] C_data;
	bit [3:0] alu_flags;
	bit [2:0] rec_3b_CRC;
	bit [5:0] err_flags;
	bit parity_bit;
   
   	function new (string name = "");
    	super.new(name);
	endfunction : new

   	virtual function void do_copy(uvm_object rhs);
		result_transaction copied_result_transaction_h;

      	if(rhs == null) 
        	`uvm_fatal("RESULT TRANSACTION", "Tried to copy from a null pointer")
 
      	super.do_copy(rhs); // copy all parent class data

      	if(!$cast(copied_result_transaction_h,rhs))
        	`uvm_fatal("RESULT TRANSACTION", "Tried to copy wrong type.")
      
      	C_data  = copied_result_transaction_h.C_data;
      	alu_flags  = copied_result_transaction_h.alu_flags;
      	rec_3b_CRC = copied_result_transaction_h.rec_3b_CRC;
      	err_flags = copied_result_transaction_h.err_flags;
      	parity_bit = copied_result_transaction_h.parity_bit;
      
   	endfunction : do_copy

   	virtual function result_transaction clone_me();
	   
	   	result_transaction clone;
      	uvm_object tmp;

      	tmp = this.clone();
      	$cast(clone, tmp);
      	return clone;
   	endfunction : clone_me
   

   	virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	   	result_transaction compared_result_transaction_h;
	   	bit   same;
      
      	if (rhs==null) `uvm_fatal("RESULT TRANSACTION", 
                                  "Tried to do comparison to a null pointer");
      
      	if (!$cast(compared_result_transaction_h,rhs))
	      	same = 0;
      	else
        	same = super.do_compare(rhs, comparer) && 
        		(compared_result_transaction_h.C_data == C_data) &&
        		(compared_result_transaction_h.alu_flags == alu_flags) &&
               	(compared_result_transaction_h.rec_3b_CRC == rec_3b_CRC) &&
               	(compared_result_transaction_h.err_flags == err_flags) &&
               	(compared_result_transaction_h.parity_bit == parity_bit);
               
      	return same;
   	endfunction : do_compare
   	
   	virtual function string convert2string();
	   	string s;
     	s = $sformatf("C_data: %8h  alu_flags: %b rec_3b_CRC: %b err_flags: %b parity_bit %b",
	     			   C_data, alu_flags, rec_3b_CRC, err_flags, parity_bit);
	   	return s;
   	endfunction : convert2string

endclass : result_transaction