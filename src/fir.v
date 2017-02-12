/******************************************************************************
@ddblock_begin copyright

Copyright (c) 1999-2014
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
`define N 5

module fir(data_out, out_enable, error, data_in, sample_enable, coef_enable, clk, reset);

/**************************************************************************
	Parameters
**************************************************************************/

/* States of the FIR filter. */
parameter s_reset 	= 2'b00;
parameter s_coeff 	= 2'b01;
parameter s_filter 	= 2'b10;
parameter s_error 	= 2'b11;
//parameter N = 5;


/**************************************************************************
    Ports
**************************************************************************/

/* Ouput data in 16 bit unsigned integer representation. */
output [15:0] data_out;

/* data_out is valid when out_enable is high.*/
output out_enable;

/* If the coef_enable signal not valid for 'N' consecutive clock
* cycles, the error signal is asserted till the filter is reseted. */
output error;

/* Input data or coefficient in 8 bits unsigned integer representation. */
input [7:0] data_in;
	

/* A new data sample is on the data_in port when sample_enable is high. 
*/
input sample_enable;

/* A new coef is on the data_in port when coef_enable is high. 
*/
input coef_enable;

/* Clock */
input clk;

/* Reset */
input reset;
integer count_coeff, count_sample;	
wire[15:0] data_out;
reg[7:0] sample[`N-2 : 0];
reg[7:0] coeff[`N-1 : 0];
reg [1:0] currentState, next_state;
reg out_enable, error;
wire[7:0] sample0, sample1, sample2, sample3, sample4; 
//wire[7:0]sample4; 
//reg flag;  //flag to indicate that atleast 1 coeff has been read in
wire[7:0] coeff0, coeff1, coeff2, coeff3, coeff4; 
wire[15:0] sum;
integer i;
initial
begin
	for (i = 0; i < `N; i = i+1) begin
		coeff[i] = 0;
	end
	
	for (i = 0; i < `N-1; i = i+1) begin
		sample[i] = 0;
	end
//data_out = 'b0;
out_enable = 0;
error = 0;
count_coeff = 0;
count_sample = 0;
end

dotproduct dp(sum, sample0, sample1, sample2, sample3, sample4, coeff0, coeff1, coeff2, coeff3, coeff4);
assign data_out = sum;
//assign sample4 = data_in;
assign coeff0 = coeff[0];
assign	coeff1 = coeff[1];
assign	coeff2 = coeff[2];
assign	coeff3 = coeff[3];
assign	coeff4 = coeff[4];
assign	sample0 = currentState==s_filter?data_in:0;
assign	sample1 = currentState==s_filter?sample[(count_sample-1+(`N-1))%(`N-1)]:0;
assign	sample2 = currentState==s_filter?sample[(count_sample-2+(`N-1))%(`N-1)]:0;
assign	sample3 = currentState==s_filter?sample [(count_sample-3+(`N-1))%(`N-1)]:0;
assign	sample4 = currentState==s_filter?sample[count_sample]:0;


always @(*)
begin
next_state = currentState;
case (currentState)
	s_reset:begin
		
		out_enable = 0;
		//flag = 0;
		if (coef_enable == 1 && reset == 1)  //reset == 1 means we are out of reset phase
		begin
			next_state = s_coeff;
			//count = 0; //now count will be used to index coeffs
		end
	end
	s_coeff:begin   //what happens when count is 0
	out_enable = 0;
	if (sample_enable && coef_enable)
		next_state = s_error;
	if (coef_enable == 0)
	begin
		if (count_coeff%`N == 0)// && flag)begin   //since s_coeff state has been entered, it means count is atleast 1. therefore we will never have the case when coef_enable=0 and not even a single coeff has been saved. if count%`N == 0, then count has been to 5 atleast.
		begin
			next_state = s_filter;
			//count = 0;  //now count will be used to index samples
		end
		else
		begin
			//$display("XXXXXXXXX %d", count);
			next_state = s_error;
		end
	end
	//else
	//next_state = s_coeff;   //is it needed? do we need to recover from coeff-en = 0?
	end
	s_filter:begin
		if (coef_enable)
		begin
			if (sample_enable) 
			begin
				next_state = s_error;
			end
			else
			begin
				next_state = s_coeff;
				//out_enable = 0;
			end
		end
		else
		begin
			if (sample_enable == 1)
				out_enable = 1;
			else
				out_enable = 0;
		end
	end
	s_error:begin
		out_enable = 0;
	end	

endcase
end
		
		
always @(posedge clk or negedge reset)
begin
if (~reset)begin
	currentState <= s_reset;
	for (i = 0; i < `N; i = i+1) begin
		coeff[i] <= 0;
	end
	for (i = 0; i < `N-1; i = i+1) begin
		sample[i] <= 0;
	end
	count_coeff <= 0;
	count_sample <= 0;
	end
else
begin
currentState <= next_state;
	
if (next_state == s_coeff) //coeff loading
begin
//if (coef_enable == 1)
if (currentState == s_filter)
begin
	//$display("xxx c %d",count);
	coeff[0] <= data_in;
	count_coeff <= 1;
end
else
begin
	coeff[count_coeff] <= data_in;
	//flag <= 1;
	if (count_coeff < `N-1)
		count_coeff <= count_coeff + 1;
	else
		count_coeff <= 0;
end
	
end
//$display(", %d %d %d %d %d", coeff[0], coeff[1], coeff[2], coeff[3], coeff[4]);
$display("%2p", sample);
if (next_state == s_filter) //sample loading and filtering
begin
	//if (currentState == s_coeff)
	//begin
		//for (i = 0; i < `N-1; i = i+1) begin
			//sample[i] <= 0;
		//end
		//no need to set count to 1 as it will only enter here from coeff with count = 0 (else it will go to error)
	//end
	//data_out <= sum;
	if (sample_enable == 1)begin
		sample[count_sample] <= data_in;
		if (count_sample < `N-2)
			count_sample <= count_sample + 1;	
		else
			count_sample <= 0;
		
	
	//$display("%d %d %d %d %d %d %d %d %d %d", sample[count], sample[(count-1)%`N], sample[(count-2)%`N], sample[(count-3)%`N], sample[(count-4)%`N], coeff[0], coeff[1], coeff[2], coeff[3], coeff[4]);
	//$display(" %d %d %d %d %d",  count, (count-1+`N)%`N, (count-2+`N)%`N, (count-3+`N)%`N, (count-4+`N)%`N);
	//$display("%2p, , , %2p", coeff, sample);
	$display("%d %d %d %d %d ", sample0, sample1, sample2, sample3, sample4);
	end
end

if (next_state == s_error)
	error <= 1;

end
end
endmodule


//test case: coeff stays high for when sampled at clock rising edge, but goes to 0 in the intervening time: the fir should not give error in this case.
	