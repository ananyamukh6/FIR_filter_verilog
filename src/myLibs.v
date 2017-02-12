`timescale 1ns/10ps
//`include "myGlbl.v"

/* 2-input nor gate with resource counter and time delay
 */
module my_nor(y, a, b);
  output y;
  input a, b;
  wire y;
  
  //initial begin
  //$display("hello nor\n");
  //end
  
  nor (y,a,b);

  //global_vars gv;
  //global_vars.count = global_vars.count+1;

  /* at instantiation increment the resources used */
 

  /* add 2ns inherent delay */

endmodule

/* 2-input and gate using my_nor
 */

module my_and(y, a, b);
  output y;
  input a, b;
  wire r1,r2;
  my_nor n1(r1,a,a);
  my_nor n2(r2,b,b);
  my_nor n3(y,r1,r2);
endmodule

/* 3-input and gate using my_and
 */

module my_and3(y, a, b, c);
  output y;
  input a, b, c;
  wire r1,y;
  my_and a1(r1,a,b);
  my_and a2(y,r1,c);
endmodule

/* 4-input and gate using my_and
 */

module my_and4(y, a, b, c, d);
  output y;
  input a, b, c, d;
  wire r1,r2,y;
  my_and a1(r1,a,b);
  my_and a2(r2,c,d);
  my_and a3(y,r1,r2);
  
endmodule

/* 2-input or gate using my_nor
 */

module my_or(y, a, b);
  output y;
  input a, b;
  wire y,r1;
  my_nor n1(r1,a,b);
  my_nor n2(y,r1,r1);
endmodule

/* 3-input or gate using my_or
 */

module my_or3(y, a, b, c);
  output y;
  input a, b, c;
  wire y,r1;
  my_or o1(r1,a,b);
  my_or o2(y,c,r1);

endmodule

/* 4-input or gate using my_or
 */

module my_or4(y, a, b, c, d);
  output y;
  input a, b, c, d;
  wire r1,r2,y;
  my_or o1(r1,a,b);
  my_or o2(r2,c,d);
  my_or o3(y,r1,r2);
endmodule

/* 2-input xor gate using my_nor
 */

module my_xor(y, a, b);
  output y;
  input a, b;
  wire r1,r2,r3,r4,y;
  my_nor n1(r1,a,a);
  my_nor n2(r2,b,b);
  my_nor n3(r3,a,b);
  my_nor n4(r4,r1,r2);
  my_nor n5(y,r4,r3);

endmodule

/*8 bit multiplier
*/

module mult(mult_out, sample, coeff);
input [7:0] sample, coeff;
output [15:0] mult_out;
integer i;
reg [15:0] mult_out;

always@(*) begin
//mult_out = sample*coeff;
mult_out = 0;
for (i = 0; i < 8; i = i + 1)
begin
	if (coeff[i])
		mult_out = mult_out + (sample<<i);
end
end
endmodule
