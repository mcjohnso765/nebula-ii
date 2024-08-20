[9:59 PM] Eshtrefi, Emri Frederick
# STARS 2024 Design Final Project
 
## Halting Problem
* Daniel Kim
* Yilin Xu
* Emri Esthrefi
* Wayne Hsieh
* Yunhao Lan
 
## Project Type
We are making a single cycle 32-bit CPU that follows the risc-V instruction set. Our CPU
is connected to a wishbone manager that gets data and instruction from the SRAM. Our CPU can also write data back into the SRAM. To show our CPU, we prototyped a simple calculator that is capable of simple addition, subtraction, multiplication and divison. Our calculator can also store the previous answer and use it again in the next calculation.
 
## Pin Layout
Note that on the final chip, there are 38 gpio of which you have access to 4.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code
 
00[00] Output: LCD register select
01[--] Input/Output: Pin_Function
02[--] Input/Output: Pin_Function
03[--] Input/Output: Pin_Function
04[--] Input/Output: Pin_Function
05[01] Output: LCD read/ write
06[02] Output: LCD enable
07[03] Output: LCD data 0
08[04] Output: LCD data 1
09[05] Output: LCD data 2
10[06] Output: LCD data 3
11[07] Output: LCD data 4
12[08] Output: LCD data 5
13[09] Output: LCD data 6
14[10] Output: LCD data 7
15[11] Input/: keypad rows 0
16[12] Input/: keypad rows 1
17[13] Input/: keypad rows 2
18[14] Input/: keypad rows 3
19[15] Output: keypad columns 0
20[16] Output: keypad columns 1
21[17] Output: keypad columns 2
22[18] Output: keypad columns 3
23[19] Input/Output: Pin_Function
24[20] Input/Output: Pin_Function
25[21] Input/Output: Pin_Function
26[22] Input/Output: Pin_Function
27[23] Input/Output: Pin_Function
28[24] Input/Output: Pin_Function
29[25] Input/Output: Pin_Function
30[26] Input/Output: Pin_Function
31[27] Input/Output: Pin_Function
32[28] Input/Output: Pin_Function
33[29] Input/Output: Pin_Function
34[30] Input/Output: Pin_Function
35[31] Input/Output: Pin_Function
36[32] Input/Output: Pin_Function
37[33] Input/Output: Pin_Function
38[34] Input/Output: Pin_Function
 
## Supporting Equipment
List all the required equipment and upload a breadboard with the equipment set up (recommend using tinkercad circuits if possible)
 
1602A LCD display
4x4 keypad matrix
breadboard
10k potentiometer 

 
## RTL Diagrams
All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams.  If you include an image, a short (0.5-1 sentence description) is required.
You may also place other files within this folder.
 
## Statement from Purdue
Pending
 
 
 