/*
	reg_file is a dual port 2**ADDR_WIDTH x DATA_WIDTH memory with asynchronous read and synchronous write capabilities.
	The contents of the array at the address specified by 4-bit input r_addr is instantly available on 8-bit output data_out.
	When 1-bit input wr_en is asserted, 8-bit input data_in is written to the memory array at the specified w_addr.
	The above input and output sizes are modular in respect to parameters ADDR_WIDTH and DATA_WIDTH.
*/

module reg_file #(parameter ADDR_WIDTH=4, DATA_WIDTH=8) (r_addr, w_addr, data_in, wr_en, clk, data_out);
	input logic wr_en, clk;
	input logic [ADDR_WIDTH-1:0] r_addr, w_addr;
	input logic [DATA_WIDTH-1:0] data_in;
	output logic [DATA_WIDTH-1:0] data_out;
	
	// Definition of the array holding the contents of the memory.
	logic [DATA_WIDTH-1:0] memory_array [0:2**ADDR_WIDTH-1];
	
	// Synchronous Write
	always_ff @(posedge clk) begin
		if (wr_en)
			memory_array[w_addr] <= data_in;
	end
	
	// Asynchronous Read
	assign data_out = memory_array[r_addr];
endmodule
