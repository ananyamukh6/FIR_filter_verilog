//`include "myLibs.v"
//`include "cla_adder16.v"

module dotproduct(sum, sample0, sample1, sample2, sample3, sample4, coeff0, coeff1, coeff2, coeff3, coeff4);
	output[15:0] sum;
	input[7:0] sample0, sample1, sample2, sample3, sample4; 
	input[7:0] coeff0, coeff1, coeff2, coeff3, coeff4; 
	wire carry_in;
	wire[15:0] sum, sum2, sum1, sum0;
	wire[15:0] multout0, multout1, multout2, multout3, multout4;
	assign carry_in = 0;
	mult multiplier0(multout0, sample0, coeff0);
	mult multiplier1(multout1, sample1, coeff1);
	mult multiplier2(multout2, sample2, coeff2);
	mult multiplier3(multout3, sample3, coeff3);
	mult multiplier4(multout4, sample4, coeff4);

	
	cla_adder16 adder0(sum0, carry_out, multout0, multout1, carry_in);
	cla_adder16 adder1 (sum1, carry_out, multout2, multout3, carry_in);
	cla_adder16 adder2 (sum2, carry_out, multout4, sum1, carry_in);
	cla_adder16 adder3 (sum, carry_out, sum0, sum2, carry_in);
	
endmodule

