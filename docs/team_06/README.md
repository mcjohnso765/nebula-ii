# STARS 2024 Design Final Project

## Team 06
* Kyle Wang
* Randy Huang
* Drew Philhower
* Thomas Fang
* Tyler Sivertsen

## Project Type
The project is the snake game with modifications to the setting of the game. These modifications include 3 speed modes (fast, normal, and slow), 3 apple generation types (lucky, normal, and unlucky), and 4 different game modes (normal, 2-apple, wall spawn, and border). Apple generation type refers to the tendency for the apple to spawn close to the snake (lucky being closer and unlucky being farther on average) and the game modes are for normal snake game, the game with 2 apples at all times, the game with "randomly" spawning walls, and a mode where the game border changes size as you play.

## Pin Layout
Note that on the final chip, there are 38 gpio of which you have access to 4.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code

00[00] Input       : Reset Game (after Death)  
01[--] Input/Output: Pin_Function  
02[--] Input/Output: Pin_Function  
03[--] Input/Output: Pin_Function  
04[--] Input/Output: Pin_Function  
05[01] Input       : Move Right (Menu Selector)  
06[02] Input       : Move Left  
07[03] Input       : Move Up (Menu Selector)  
08[04] Input       : Move Down (Menu Selector)  
09[05] Input       : Start / Pause Game  
10[06] Output      : Game LCD Data  
11[07] Output      : Game LCD Data  
12[08] Output      : Game LCD Data  
13[09] Output      : Game LCD Data  
14[10] Output      : Game LCD Data  
15[11] Output      : Game LCD Data  
16[12] Output      : Game LCD Data  
17[13] Output      : Game LCD Data  
18[14] Output      : Game LCD WR  
19[15] Output      : Game LCD DCX  
20[16] Output      : Audio Output  
21[17] Output      : GoodCollision Pin  
22[18] Output      : Game LCD RS  
23[19] Output      : Menu LCD rw  
24[20] Output      : Menu LCD en  
25[21] Output      : Menu LCD Data  
26[22] Output      : Menu LCD Data  
27[23] Output      : Menu LCD Data  
28[24] Output      : Menu LCD Data  
29[25] Output      : Menu LCD Data  
30[26] Output      : Menu LCD Data  
31[27] Output      : Menu LCD Data  
32[28] Output      : Menu LCD Data  
33[29] Input/Output: Pin_Function  
34[30] Input/Output: Pin_Function  
35[31] Input/Output: Pin_Function  
36[32] Input/Output: Pin_Function  
37[33] Input/Output: Pin_Function  
38[34] Input/Output: Pin_Function  

## Supporting Equipment
1 16x2 LCD,  1 320x240 RGB LCD (with 8 bit parallel input),  6 push buttons, 1 potentiometer, 1 8 ohm speaker, 1 LM 386 amplifier, debouncing capacitors, and various resistors (as shown in included image).

## RTL Diagrams
All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams.  If you include an image, a short (0.5-1 sentence description) is required.
You may also place other files within this folder.

## Statement from Purdue
Pending

