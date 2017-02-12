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
PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
MARYLAND HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.

@ddblock_end copyright
******************************************************************************/
`timescale 1ns/10ps

/* 16-bit carry lookahead adder.
 * Reference: Givone, Donald. Digital Principles and Design. New York: McGraw
 * Hill, 2003.
 * modified for use with my_nand
 */

module cla_adder16 (sum, carry_out, a, b, carry_in);
    output [15:0] sum;
    output carry_out;    
    input  [15:0] a, b;
    input carry_in;

    wire [2:0] c1;
    wire [11:0] c0;
    wire [15:0] p,g;
    wire [3:0] P,G;
    wire [15:0] carrys;
    wire [3:0] carrys1;

    assign carrys1 = {c1, carry_in};
    assign carrys =  {c0[11:9], c1[2], c0[8:6], c1[1], c0[5:3], c1[0], c0[2:0], carry_in};

    cla_generator4 cla_gen4_0(c1,P_out,G_out,carry_in,P,G);
    cla_generator4 cla_gen4_1[3:0](c0, P, G, carrys1, p, g);    
    cla_adder cla_add[15:0](sum, p, g, a, b, carrys);		
    my_and cc1(c41, P_out,  carry_in);
    my_or cc2(carry_out, G_out, c41);
endmodule

/* 1-bit carry lookahead adder.
 */
module cla_adder(sum, p, g, a, b, c);
    output sum;
    output p;
    output g;
    input a;
    input b;
    input c;

    wire w1;
	
	 initial begin
	//$display("hello cla_adder\n");
	end
    
    my_xor xor1(w1, a, b);
    my_xor xor2(sum, w1, c);
    my_or or1(p, a, b);
    my_and and1(g, a, b);
endmodule

/* 4-bit carry lookahead generator.
 */
module cla_generator4(c, P, G, carry_in, p, g);
    output [2:0] c;
    output P;
    output G;
    input carry_in;
    input [3:0] p, g;
	
	initial begin
	//$display("hello cla_generator4\n");
	end

    /* c1 */
    my_and cc11(c11 ,carry_in, p[0]);
    my_or cc1(c[0], c11, g[0]);
    
    /* c2 */
    my_and3 cc21(c21, carry_in, p[0], p[1]);
    my_and cc22(c22, g[0], p[1]);
    my_or3 cc2(c[1], c21, c22, g[1]);
    
    /* c3 */
    my_and4 cc31(c31, carry_in, p[0], p[1] ,p[2]);
    my_and3 cc32(c32 ,g[0], p[1], p[2]);
    my_and cc33(c33, g[1], p[2]);
    my_or4 cc_o(c[2], g[2], c31, c32, c33);
    
    /* P */
    my_and4 pp1(P, p[0], p[1], p[2], p[3]);
    
    /* G */
    my_and4 gg1(g_out1, p[1], p[2], p[3], g[0]);
    my_and3 gg2(g_out2, p[2], p[3], g[1]);
    my_and gg3(g_out3, p[3], g[2]);
    my_or4 gg_o(G, g_out1, g_out2 ,g_out3, g[3]);
endmodule

