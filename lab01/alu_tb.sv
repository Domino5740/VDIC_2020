typedef enum bit[2:0] {
	and_op = 3'b000,
	or_op  = 3'b001,
	add_op = 3'b100,
	sub_op = 3'b101
} operation_t;

byte bit_counter, byte_counter;
bit [4:0] [7:0] received_data;
bit [3:0] [7:0] A_data, B_data;
int C_data;
bit error_ocurred;
bit [3:0] alu_flags; // CARRY, OVERFLOW, ZERO, NEGATIVE
bit [2:0] CRC_checksum;
bit [5:0] err_flags; //ERR_DATA, ERR_CRC, ERR_OP, ERR_DATA(duplicated), ERR_CRC(duplicated), ERR_OP(duplicated)
bit parity_bit;
operation_t op_set;

int expected_C_data;
int expected_CRC;

bit clk, rst_n;
bit sin, sout;

mtm_Alu DUT (.clk, .rst_n, .sin, .sout);

initial begin
	clk = 0;
	forever #10 clk = ~clk;
end

covergroup op_cov;
	option.name = "cg_op_cov";
	coverpoint op_set {
		bins A1_all_op[] = ([and_op:sub_op]); //ok?
		bins A2_rst_op[] = (!rst_n => [and_op:sub_op]); //nie moze tak byc - bad specification/understanding
		bins A3_op_rst[] = ([and_op:sub_op] => !rst_n);
		bins A4_twoops[] = ([and_op:sub_op] [* 2]);
	}
endgroup

covergroup data_corners_cov;
	option.name = "specific_data_corners_cov";
	//coverpoint
endgroup

function operation_t get_op();
	bit[1:0] op_choice;
	op_choice = $random;
	case(op_choice)
		2'b00	:	return and_op;
		2'b01	:	return  or_op;
		2'b10	:	return add_op;
		2'b11	:	return sub_op;
	endcase
endfunction

function calculate_CRC();
	expected_CRC = {expected_C_data, 1'b0, alu_flags};
endfunction

function debug();
	received_data[byte_counter][bit_counter] = sout;
	
	if(byte_counter == 4 && bit_counter == 7) begin
		C_data = received_data[3:0];
		if(received_data[4][0] == 0) begin
			error_ocurred = 0;
			
			for(byte i = 0; i <= 3; i++) begin
				alu_flags[i] = received_data[4][i + 1];
			end
			
			for(byte i = 0; i <= 2; i++) begin
				CRC_checksum[i] = received_data[4][i + 5];
			end
		end
		else if(received_data[4][0] == 1) begin
			error_ocurred = 1;
			
			for(byte i = 0; i <= 5; i++) begin
				err_flags[i] = received_data[4][i + 1];
			end
			
			parity_bit = received_data[4][7];
			
		end
	end
	
	if(bit_counter <= 7) begin
		bit_counter += 1;
	end
	else begin
		bit_counter = 0;
		byte_counter = (byte_counter >= 4) ? 0 : byte_counter + 1;
	end
	
endfunction