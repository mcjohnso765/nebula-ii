# STARS 2024 Design Final Project

## Dino Jump Game
* Eshan Mathur
* Minghan Wang
* Rebecca Patino
* Creighton Bennett
* Kaden Jackson-Dietzer
* Jakob Dieffenbach

## Project Type
The idea of this project was to create a game similar to the Google Chrome Dinosaur Game, in which the game's objective is for a dinosaur to jump over obstacles, like cacti, as they approach the dinosaur. Over time, the user's score, and the speed at which the cacti approach increases. We added our own elements into the game to make it unique; rather than ending the game as soon as a collision occurs, we opted to decrease a user's score significantly to encourage the user to continue playing. The game ends when the user's score reaches zero, or if they reach the high score of 99. 

## Pin Layout
Note that on the final chip, there are 38 gpio of which you have access to 4.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code

00[00] Input: Reset Button
01[--] Input/Output: N/A
02[--] Input/Output: N/A
03[--] Input/Output: N/A
04[--] Input/Output: N/A
05[01] Input: Changing Game State/Jump Button
06[02] Input: Display Toggle Button
07[03] Output: tft_sck output pin for serial display / cs output pin for parallel display 
08[04] Output: tft_sdi output pin for serial display / cd output pin for parallel display
09[05] Output: tft_dc output pin for serial display / wr output pin for parallel display
10[06] Output: tft_reset pin for serial display / rd output pin for parallel display
11[07] Output: tft_cs pin for serial display / grounded output pin for parallel display
12[08] Output: data output pin for parallel
13[09] Output: data output pin for parallel 
14[10] Output: data output pin for parallel 
15[11] Output: data output pin for parallel 
16[12] Output: data output pin for parallel 
17[13] Output: data output pin for parallel 
18[14] Output: data output pin for parallel 
19[15] Output: data output pin for parallel 
20[16] Output: ones digit for seven-segment display for score 
21[17] Output: ones digit for seven-segment display for score 
22[18] Output: ones digit for seven-segment display for score
23[19] Output: ones digit for seven-segment display for score
24[20] Output: ones digit for seven-segment display for score
25[21] Output: ones digit for seven-segment display for score
26[22] Output: ones digit for seven-segment display for score
27[23] Output: tens digit for seven-segment display for score 
28[24] Output: tens digit for seven-segment display for score
29[25] Output: tens digit for seven-segment display for score
30[26] Output: tens digit for seven-segment display for score
31[27] Output: tens digit for seven-segment display for score
32[28] Output: tens digit for seven-segment display for score
33[29] Output: tens digit for seven-segment display for score
34[30] Output: collision detection LED
35[31] Input/Output: N/A
36[32] Input/Output: N/A
37[33] Input/Output: N/A
38[34] Input/Output: N/A

## Supporting Equipment
Three push buttons, two seven-segment displays, one LED, one SPI display, one parallel display
![breadboard](https://github.com/user-attachments/assets/2e2efbd5-e6cc-4c4a-a8fe-4d211bfabf1c)


## RTL Diagrams
![DinoGame-TopLevel drawio](https://github.com/user-attachments/assets/c200db74-c040-4251-ba3b-087345d8adf8)
![DinoGame-CactusGen drawio (1)](https://github.com/user-attachments/assets/c5bac072-d876-4c2a-b1c5-ba4f8e2e8b47)
![DinoGame-DinoJump drawio (2)](https://github.com/user-attachments/assets/72d09f05-5cab-49fa-9354-9478bdfa9709)
![DinoGame-CollisionDetector drawio](https://github.com/user-attachments/assets/26e8958e-b853-49fb-9954-6fe1c295d7e2)
![DinoGame-floorGenerator drawio](https://github.com/user-attachments/assets/7a0b4e65-804c-406a-bbac-7ee915c08699)
![DinoGame-Audio Output drawio](https://github.com/user-attachments/assets/a382efce-4ce3-49fd-a295-d854cf5976b4)
![DinoGame-stateMachine drawio](https://github.com/user-attachments/assets/e16e8acc-05d2-4385-8fe4-19dcc62d58e2)
![DinoGame-scoreCounter drawio (1)](https://github.com/user-attachments/assets/b0f03694-1cd0-4580-a65c-aba8285448e1)


## Statement from Purdue
Pending

