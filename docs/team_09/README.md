# STARS 2024 Design Final Project

## TEAM NAME
* Caroline Chang
* Bryan Chiang
* Sam Gutterman
* Jash Pola
* Adrian Buczkowski

## Project Type
Chip that play Snake. Snake increases in length when apple in consumed and dies when it hits a border or itself. Inputs are buttons, outputs are LCD and DAC

## Pin Layout
Note that on the final chip, there are 38 gpio of which you have access to 34.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code

00[00] Output: D0 Pin on LCD Display
01[--] Input/Output: Pin_Function
02[--] Input/Output: Pin_Function
03[--] Input/Output: Pin_Function
04[--] Input/Output: Pin_Function
05[01] Output: D1 Pin on LCD Display
06[02] Output: D2 Pin on LCD Display 
07[03] Output: D3 Pin on LCD Display
08[04] Output: D4 Pin on LCD Display 
09[05] Output: D5 Pin on LCD Display 
10[06] Output: D6 Pin on LCD Display
11[07] Output: D7 Pin on LCD Display
12[08] Output: D/CX Pin on LCD Display
13[09] Output: WR Pin on LCD Display
14[10] Output: VA (LSB) for DAC 
15[11] Output: VB for DAC 
16[12] Output: VC for DAC 
17[13] Output: VD for DAC 
18[14] Output: VE for DAC 
19[15] Output: VF (MSB) for DAC 
20[16] Output: First Pin for Seven Segment Display 
21[17] Output: Second Pin for Seven Segment Display 
22[18] Output: Third Pin for Seven Segment Display 
23[19] Output: Fourth Pin for Seven Segment Display 
24[20] Output: Fifth Pin for Seven Segment Display 
25[21] Output: Sixth Pin for Seven Segment Display 
26[22] Output: Seventh Pin for Seven Segment Display 
27[23] Output: Enable B Pin for Seven Segment Display 
28[24] Output: Enable A Pin for Seven Segment Display 
29[25] Input: Up Button
30[26] Input: Down Button
31[27] Input: Right Button 
32[28] Input: Left Button
33[29] Input: Mode Button (changes the speed)
34[30] Input: Obstacle Toggle Button 
35[31] Input: Reset Button (Press when game is over)
36[32] Input/Output: Empty
37[33] Input/Output: Empty
38[34] Input/Output: Empty

#NOTE: ALL BUTTONS MUST BE EXTERNALLY DEBOUNCED, THERE IS NO DEBOUNCING LOGIC IN OUR DESIGN

## Supporting Equipment
- MI0283QT-9A TFT Display (1) 
- Seven Segment display (3) 
- Buttons (7) 
- Resistors (totaling 40 ohms) 
- 1K Ohm Resistors (7) 
- 500 Ohm Resistors (7) 
- 1.5K Ohm Resistors (2) 
- 2A104J Radial Polyester Film Capacitor (1) - 0.1 microfarad 
- 105 Ceramic Capacitor (1) - 1 microfarad 
- M575 LF356 Operational Amplifier (1) 
- SN74HC04 – HEX Inverter (1)
- SN74HC08 - Quad AND Gate (1)
  ![image](https://github.com/user-attachments/assets/1f805009-144c-4a64-8e48-ade35dd9651f)
  ![image](https://github.com/user-attachments/assets/36583b63-e938-44a6-8faf-d1b38dfb6198)
  ![image](https://github.com/user-attachments/assets/779d61e2-6cd4-4c24-af7b-cacc024f239a)

## RTL Diagrams
Image Generator RTL with state machines
![image](https://github.com/user-attachments/assets/7ce9f342-2a4d-4418-b049-1c6e3151fa7b)
Top Level RTL
![image](https://github.com/user-attachments/assets/2b107ba2-351f-4ee0-bcb8-6e202715a3d9)
Submodules:
![image](https://github.com/user-attachments/assets/84cf4cd9-acc5-4871-ae76-b469f46bd940)
![image](https://github.com/user-attachments/assets/60c0ab0a-5479-4a14-af33-f6e7cd181491)
![image](https://github.com/user-attachments/assets/044ccb93-c610-45c2-9fe8-2c0d9a77c245)
![image](https://github.com/user-attachments/assets/e55c82e5-31bc-40a7-8cac-58badec5f79e)
![image](https://github.com/user-attachments/assets/cfccb4ed-00b6-42a8-8a9e-9d38d540c715)
![image](https://github.com/user-attachments/assets/30297a3d-f80c-461e-af4f-bbb739e0f447)
![image](https://github.com/user-attachments/assets/d4815264-9df9-44c6-982b-9051840e65db)

## Statement from Purdue
Pending

