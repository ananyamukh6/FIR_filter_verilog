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
`include "../../src/dotproduct.v"

module sample_cla_testbench;

    reg [7:0] sample0, sample1, sample2, sample3, sample4;
    reg [7:0] coeff0, coeff1, coeff2, coeff3, coeff4;
    wire [15:0] sum;
	
	
	dotproduct finalprod(sum, sample0, sample1, sample2, sample3, sample4, coeff0, coeff1, coeff2, coeff3, coeff4);
	
    initial begin
        $monitor("%d:  sum: %d, %d, %d %d", $time, sum, finalprod.multiplier0.sample, finalprod.multiplier0.coeff, finalprod.multiplier0.mult_out);
		#1000 $finish;
    end

    initial begin		
		sample0 = 0 ; coeff0 = 0;
		 sample1 = 0; coeff1 = 0;
		 sample2 = 0; coeff2 = 0;
		 sample3 = 0; coeff3 = 0;
		 sample4 = 0; coeff4 = 0;
		#3
		 sample0 = 3 ; coeff0 = 5;
		 sample1 = 5; coeff1 = 2;
		 sample2 = 7; coeff2 = 5;
		 sample3 = 1; coeff3 = 2;
		 sample4 = 1; coeff4 = 4;
		 #10
		 sample0 = 3 ; coeff0 = 5;
		 #10
		 sample0 = 5; coeff1 = 2;
		 

    end

endmodule
