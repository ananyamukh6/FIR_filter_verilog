/******************************************************************************
@ddblock_begin copyright

Copyright (c) 1999-2010
Maryland DSPCAD Research Group, The University of Maryland at College Park

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
N AN "AS IS" BASIS, AND THE UNIVERSITY OF
MARYLAND HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.

@ddblock_end copyright
******************************************************************************/
`timescale 1ns/10ps
`include "../../src/fir.v"

module fir_testbench;
	wire out_enable, error;
	wire[15:0] data_out;
	reg[7:0] data_in;
	reg sample_enable, coef_enable;
	reg clk, reset;
	
    fir fir1(data_out, out_enable, error, data_in, sample_enable, coef_enable, clk, reset);

    initial begin
		$monitor( "%2d - coef_enable: %d, sample_enable: %d, error: %d, data_in: %d, data_out: %d, curr: %d, nextst: %d, count: %d, coeff: %2p, sum: %d",
	    $time, coef_enable, sample_enable, error, data_in, data_out, fir1.currentState, fir1.next_state, fir1.count, fir1.coeff, fir1.dp.sum); 
		$monitor( "%d sum:%d sample: %d %d %d %d %d,,, coeff: %d %d %d %d %d,,, sample:%2p ",
	    $time, fir1.dp.sum, fir1.dp.sample0, fir1.dp.sample1, fir1.dp.sample2, fir1.dp.sample3, fir1.dp.sample4, fir1.dp.coeff0, fir1.dp.coeff1, fir1.dp.coeff2, fir1.dp.coeff3, fir1.dp.coeff4, fir1.sample); 
		
		#1000 $finish;
    end

    initial begin
	#1
	reset = 0;
	#1
	coef_enable = 1;
	data_in = 10;
	#10
	data_in = 20;
	#10
	data_in = 30;
	#10
	reset = 1;
	#10	data_in = 10;
	#10	data_in = 20;
	#10	data_in = 30;
	#10	data_in = 40;
	#10	data_in = 50;
	#1
	coef_enable = 0;
	#1
	sample_enable = 1; 
	#1	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#10	data_in = 1;
	#1
	coef_enable = 1;
	#30
	reset = 1;
	#10
	reset = 0;
    end

    initial begin
	clk = 0; reset = 1;
	forever begin
	    #5 clk = !clk;
	end
    end


endmodule
