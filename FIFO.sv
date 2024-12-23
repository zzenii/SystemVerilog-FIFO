/*
	FIFO brings the control circuitry of FIFO_Control and data circuitry of ram to complete the FIFO design.
	It accepts 1-bit read and write signals (with associated desired functionality), and (DATA_WIDTH-1)-bit inputBus (the data to be written).
	It outputs the 1-bit control signals empty and full, and (DATA_WIDTH-1)-bit outputBus (the data read).
*/


module FIFO #(
	  parameter ADDR_WIDTH = 4,
	  parameter DATA_WIDTH = 8
	  )(
		input logic clk, reset,
		input logic read, write,
		input logic [DATA_WIDTH-1:0] data_in,
		output logic empty, full,
		output logic [DATA_WIDTH-1:0] data_out
	   );
	
	// Temporary signals from control to data.
	logic [ADDR_WIDTH-1:0] r_addr, w_addr;
	logic wr_en;
	
	// Instance of FIFO_Control that accepts read and write signals that determine FSM behaviour.
	// Control signals wr_en, r_addr, w_addr are ported to the memory.
	FIFO_Control #(ADDR_WIDTH) FC (.*);
	
	// Instance of reg_file that accepts the input data, and control signals r_addr, w_addr, wr_en.
	// data_out is ported to the output of the entity.
	reg_file #(ADDR_WIDTH, DATA_WIDTH) memory (.*);
	
endmodule 
