`timescale 1ns/1ps
module top_TB;

mtm_Alu DUT (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));

alu_bfm bfm();
coverage cov_i(bfm);
tester tst_i(bfm);
scoreboard score_i(bfm);

endmodule