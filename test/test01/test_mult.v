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
`include "../../src/myLibs.v"

module sample_cla_testbench;

    reg [7:0] sample;
    reg [7:0] coeff;
    wire [15:0] mult_out;
	
	
	mult m(mult_out, sample, coeff);
	
    initial begin
        //$monitor("%d:  sum: %d, %d, %d %d", $time, sum, finalprod.multiplier0.sample, finalprod.multiplier0.coeff, finalprod.multiplier0.mult_out);
		$monitor("%d:  sum: %d, %d, %d %d", $time, mult_out, sample, coeff);
		#1000 $finish;
    end

    initial begin		
		sample = 0 ; coeff = 0;
		#3
		 sample = 3 ; coeff = 5;
		 #10
		 sample = 3 ; coeff = 5;
		 #10
		 sample = 5; coeff = 2;
    end

endmodule
