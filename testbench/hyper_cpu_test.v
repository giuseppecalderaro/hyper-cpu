`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:05:01 06/11/2011
// Design Name:   hyper_cpu
// Module Name:   C:/Users/giuseppe/Projects/FpgaDev/hyper_cpu/hyper_cpu_test.v
// Project Name:  hyper_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hyper_cpu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module hyper_cpu_test;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] pc_out;

	// Instantiate the Unit Under Test (UUT)
	hyper_cpu uut (
		.clk(clk), 
		.rst(rst), 
		.pc_out(pc_out)
	);

	always
		#5 clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		rst = 0;

	end
      
endmodule

