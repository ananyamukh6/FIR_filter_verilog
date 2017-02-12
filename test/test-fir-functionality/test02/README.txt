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

>This test checks the fir functionality for the resest state
>This test initializes the coefficients and make sure that the dot product is correct.
We start loading the coefficient registers but before 5 clock cycles are completed the reset signal is low and it moves to resest state. Now after that when again reset signal is high it starts loading the coefficients and after 5 clock cycles go to the sample enable state. Loads 2 sample and again the reset is low so it resets the coeff and sample registers. Now after that when reset is high ad coef_enable is high for 5 clock cycle loads coefficients and moves to s_filter state as sample enable is high and starts sampling
>The final result should equal the dot product between the coefficients (4,5,6,7,8) and the samples (0,0,1,1,1) wich equals 15.

Check the transcript file for more detailed information.
