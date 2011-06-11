`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Giuseppe Calderaro
// 
// Create Date:    18:10:48 06/11/2011 
// Design Name: 
// Module Name:    functions 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
function integer log2;
	input integer value;
	begin
		value = value - 1;
		for (log2 = 0; value > 0; log2 = log2 + 1)
			value = value >> 1;
	end
endfunction
