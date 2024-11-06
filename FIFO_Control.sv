/*
	FIFO_Control establishes the control circuitry of the FIFO, including how a full or empty FIFO with address space 2**depth should be handled.
	It accepts 1-bit inputs read and write (which trigger their respective operations), and outputs 1-bit wr_en, empty, full based on the status of the FIFO.
	It additionally specifies the read and write addresses for the register file, depth-1-bit outputs r_addr and w_addr.
	empty and full are determined by an internal counter, count, which records the number of elements currently in the FIFO.
*/

module FIFO_Control #(
							 parameter 	depth = 4
							 )(
								input logic clk, reset,
								input logic read, write,
							  output logic wr_en,
							  output logic empty, full,
							  output logic [depth-1:0] r_addr, w_addr
							  );
	
	// Intermediate Logic.
	logic [4:0] count, count_next; // Internal counter to record the number of elements in the FIFO
	logic [depth-1:0] rd_ptr, wr_ptr; // FIFO pointers
	
	// Full and Empty assertions based on the number of elements in the FIFO.
	always_comb begin
		empty = (count == 0);
		full = (count == 2**depth);
	end
	
	// wr_en to memory
	assign wr_en = write & ~full;
	
	// Establishing the next values to be taken by w_addr, r_addr, and count based on read and write.
	// Values are read / written according to the present values of w_addr and r_addr. We need the desired
	// incrementations to occur at the next clock cycle.
	always_comb begin
		// Base values (no change).
		wr_ptr = w_addr; 
		rd_ptr = r_addr;
		count_next = count;
		
		// Modifications to base values.
		case ({read, write})
			2'b11: 
			begin
				wr_ptr = (w_addr + 1) % (2**depth); 
				rd_ptr = (r_addr + 1) % (2**depth);
			end
			2'b10:
			begin
				if (~empty) begin 
					rd_ptr = (r_addr + 1) % (2**depth);
					count_next = count - 1;
				end
			end
			2'b01:
			begin
				if (~full) begin 
					wr_ptr = (w_addr + 1) % (2**depth); 
					count_next = count + 1;
				end
			end
			2'b00: ; // do nothing.
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			count <= 0;
			r_addr <= 0;
			w_addr <= 0;
		end
		
		// Asserting the "next-state" behaviour.
		else begin
			r_addr <= rd_ptr;
			w_addr <= wr_ptr;
			count <= count_next;
		end
	end
endmodule 