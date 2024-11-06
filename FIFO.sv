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
					 input logic [DATA_WIDTH-1:0] inputBus,
					output logic empty, full,
					output logic [DATA_WIDTH-1:0] outputBus
				   );
	
	// Temporary signals from control to data.
	logic [ADDR_WIDTH-1:0] r_addr, w_addr;
	logic wr_en;
	
	// Instance of FIFO_Control that accepts read and write signals that determine FSM behaviour.
	// FIFO status signals empty, full, wr_en, readAddr, writeAddr are ported to the memory.
	FIFO_Control #(ADDR_WIDTH) FC (.clk, .reset, 
									  .read, .write, 
									  .wr_en,
									  .empty, .full,
									  .r_addr, .w_addr
									 );

	
	// Instance of reg_file that accepts the input data, and control signals r_addr, w_addr, wr_en.
	// data_out is ported to the output of the entity.
	reg_file #(ADDR_WIDTH, DATA_WIDTH) memory (.r_addr, .w_addr, .data_in(inputBus), .wr_en, .clk, .data_out(outputBus));
	
endmodule 