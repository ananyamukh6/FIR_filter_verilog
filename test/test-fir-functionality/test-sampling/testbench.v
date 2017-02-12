/******************************
@ddblock_begin copyright

Copyright (c) 1999-2014
George Zaki, University of Maryland

Permission is hereby granted, without written agreement and without
license or royalty fees, to use, copy, modify, and distribute this
software and its documentation for any purpose, provided that the above
copyright notice and the following two paragraphs appear in all copies
of this software.

IN NO EVENT SHALL THE UNIVERSITY OF MARYLAND BE LIABLE TO ANY PARTY
FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
THE UNIVERSITY OF MARYLAND HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

THE UNIVERSITY OF MARYLAND SPECIFICALLY DISCLAIMS ANY WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE
PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
MARYLAND HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.

@ddblock_end copyright
******************************/


`timescale 1ns / 1ps

module testbench;

	// Inputs
	reg [7:0] data_in;
	reg sample_enable;
	reg coef_enable;
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] data_out;
	wire out_enable;
	wire error;

	integer descr;

	fir MUT (
		.data_out(data_out), 
		.out_enable(out_enable), 
		.data_in(data_in), 
		.sample_enable(sample_enable), 
		.coef_enable(coef_enable), 
		.error(error), 
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		descr = $fopen("out.txt");
		$fmonitor(descr, "data_out: %d, out_enable: %d",
					 data_out,out_enable);
	end

	initial begin
		$monitor("clk: %d, reset: %d", clk, reset);
	end

	always @(data_out, out_enable) begin
		if (out_enable) begin 
			$display("data_out = %d\n",data_out );
		end
	end


	initial begin
		// Initialize Inputs
		clk = 0;
		data_in = 0;
		sample_enable = 0;

		// Reset the system.
        reset = 1;
		#5
		reset = 0;

		/* Update coefficients. */
		#5 reset = 1;
		coef_enable = 1;
        data_in = 4;
		#10 clk = 1;


		#10 clk = 0;
		data_in = 5;
		#10clk = 1;


		#10 clk = 0;
		data_in = 6;
		#10clk = 1;

		#10 clk = 0;
		data_in = 7;
		#10clk = 1;

		#10 clk = 0;
		data_in = 8;
		#10clk = 1;



		/* Switch to the sampling state. */

		#10 clk = 0;
		coef_enable = 0;
		#10clk = 1;


		#10 clk = 0;
		data_in = 1;
		coef_enable = 0;
		sample_enable = 1;
		#10clk = 1;


		#10 clk = 0;
		data_in = 1;
		sample_enable = 1;
		#10clk = 1;


		#10 clk = 0;
		data_in = 1;
		sample_enable = 1;
		#10clk = 1;



		#10 clk = 0;
		data_in = 1;
		sample_enable = 1;
		#10clk = 1;


		#10 clk = 0;
		data_in = 1;
		sample_enable = 1;
        #10
        $finish;

	end

endmodule

