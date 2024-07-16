# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## Please fill in your project documentation in this README.md file 

# STARS 2024 Design Final Project

## TEAM NAME
Team Members:
* Adam Grendys
* Justin Sanchez
* Sandeep Saravanakumar
* Yejin Oh 

Peer Mentor:
* Harnoor Cheema

## Project Type
This project is a wireless hangman game based off the wireless messaging architecture. It features a player and host side, where the host may set a word for the player to guess. We have a keypad for inputs and an LCD screen for the outputs (correct/incorrect guesses, win/lose screen, etc.).

## Pin Layout
Note that on the final chip, there are 38 gpio of which you have access to 4.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code

00[00] Input: Unassigned  
01[--] Input/Output: Pin_Function  
02[--] Input/Output: Pin_Function  
03[--] Input/Output: Pin_Function  
04[--] Input/Output: Pin_Function  
05[01] Input: Unassigned  
06[02] Input: Unassigned  
07[03] Input: Unassigned  
08[04] Input: Unassigned  
09[05] Input: Unassigned  
10[06] Output: ss7[0] (LCD data bit)  
11[07] Output: ss7[1] (LCD data bit)  
12[08] Output: ss7[2] (LCD data bit)  
13[09] Output: ss7[3] (LCD data bit)  
14[10] Output: ss7[4] (LCD data bit)  
15[11] Output: ss7[5] (LCD data bit)  
16[12] Output: ss7[6] (LCD data bit)  
17[13] Output: ss7[7] (LCD data bit)  
18[14] Input: nRst (negative reset for our game)  
19[15] Input: clk (global clock for our game)  
20[16] Output: blue (LED indicator that shows that data is being transmitted)  
21[17] Output: green (LED indicator that shows that the player has won)  
22[18] Input/Output: red (LED indicator that shows that the player has lost)  
23[19] Output: error_led (shows when the parity bit is incorrect which means that there was an error in data transmission)  
24[20] Input: rx_serial (serial input for the reciever from the transmitter)  
25[21] Input: read_row[0] (Player row input on the keypad, one of the 4 rows)  
26[22] Input: read_row[1] (Player row input on the keypad, one of the 4 rows)  
27[23] Input: read_row[2] (Player row input on the keypad, one of the 4 rows)  
28[24] Input: read_row[3] (Player row input on the keypad, one of the 4 rows)  
29[25] Output: tx_serial (transmission data that gets send from transmitter to reciever)  
30[26] Output: lcd_rs (lcd control signal)  
31[27] Output: lcd_rw (reads and writes to the lcd display)  
32[28] Output: lcd_en (enables the lcd to be able to read and write information)  
33[29] Output: scan_col[0] (Column tracker for the keypad that oscillates through the 4 columns)  
34[30] Output: scan_col[1] (Column tracker for the keypad that oscillates through the 4 columns)  
35[31] Output: scan_col[2] (Column tracker for the keypad that oscillates through the 4 columns)  
36[32] Output: scan_col[3] (Column tracker for the keypad that oscillates through the 4 columns)  
37[33] Input: mode (switches the game to player or host mode, player being 1 and host being 0)  
38[34] Input: Unassigned

## Supporting Equipment
List all the required equipment and upload a breadboard with the equipment set up (recommend using tinkercad circuits if possible)

Required equipment:
- 2x Keypad
- 2x LCD Screen
- 2x RGB LED, 2x Red LED
- 2x Switch
- 2x Button
- 2x XBee
- 2x Potentiometer
  
Breadboard with components:  
![IMG_7827](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/15b18ba7-766b-41ec-a224-6e2e166fe323)


## RTL Diagrams
All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams.  If you include an image, a short (0.5-1 sentence description) is required.
You may also place other files within this folder.
- Overall RTL  
![Screenshot from 2024-07-10 12-01-58](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/edebc274-61ce-438c-a582-87886e159e35)  
- Top Level Testbench for player winning
![Screenshot from 2024-07-10 13-37-50](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/ebe96712-74b0-4170-bfe7-4413809efcd6)  
This is the top level testbench and RTL diagram. Showcasing all of our submodules integrated together to present the final product. The testbench provides a visual representation of how our design would work physically.  

- Display FSM (Player side display)  
![Screenshot from 2024-07-10 13-01-04](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/f31ef5bd-7ef5-4b08-a38a-6ee80c7657d3)  
- Display FSM Testbench  
![Screenshot from 2024-07-10 13-41-22](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/b0900509-a1d4-473f-bd49-9b36a1c81d97)  
This is the display FSM for the player side display. The player side display simply shows the players current letter chosen as well as the guesses the player has made. Each part is on the top and bottom row respectively.  
  
- Buffer (for the message register)  
![Screenshot from 2024-07-10 13-00-36](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/c9037c1c-1c23-4c74-82a8-9ae0d31c1aa7)  
- Buffer Testbench  
![Screenshot from 2024-07-10 13-44-40](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/5da51682-8130-4a65-8aff-4174ce12db5a)  
The buffer is for the message register. It allows the user input to be taken and placed into the message register with no issues. A buffer is often used for signal amplification or acts as a medium between two modules.  
  
- UART Reciever  
![Screenshot from 2024-07-10 13-07-25](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/9ea40ab3-2032-44ce-9b9e-f0ac035b545d)  
- UART Reciever Testbench  
![Screenshot from 2024-07-10 13-43-51](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/9e5e57c4-2e51-492b-95c6-7ab059b95c20)  
The UART Reciever is at the core of this design which allows us to wirelessly transmit signals. The reciever takes in one bit at a time from the transmitter and puts the entire 8 bit ACSII character together to pass on into the game logic. The reciever follows a certain protocol that is incorporated into both the tx and rx modules.  
  
- UART Transmitter  
![Screenshot from 2024-07-10 13-07-46](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/bda757d6-f3a3-431f-9cef-63df1b653467)  
- UART Tx Testbench  
![Screenshot from 2024-07-10 13-42-58](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/dbde8485-c9d1-460c-9782-08786890c0a9)  
The UART Transmitter is able to transmit an 8 bit ASCII character one bit at a time using a certain protocol. The transmitter is always transmitting ones to the reciever until it recieves a player input, then the transmitter would send a zero indicating the transmission of data is about to begin. Then the transmitter sends the 8 bit ASCII character one bit at a time. We also have a parity bit for error detecting.  

- Game Logic  
![Screenshot from 2024-07-10 13-09-03](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/1198f9ad-a124-4fb1-944b-3f605e7e40c9)  
- Game Logic Testbench  
![Screenshot from 2024-07-10 13-45-49](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/8f4fcd22-6964-458f-b89f-3565a72d765e)  
The game logic is the main driver for the hangman game. It takes in the user input and a word that is set by the host before the game starts. Then as the user guesses the word it updates the incorrect or correct guesses until the user has 6 incorrect or 5 correct guesses. Indicating the game has ended. These signals are all sent to the host display.  
  
- Host Display  
![Screenshot from 2024-07-10 13-09-41](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/d68443c4-7442-4d4c-86a0-92a9d1b9c2bc)  
- Host Display Testbench  
![Screenshot from 2024-07-10 13-46-39](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/1f8ebbbf-d3d6-42c0-83d1-70700bd74a46)  
The host display shows how the user is currently doing in the game. With the top row showing the current word and any letters within the word that the user has gotten correct. So everytime the user gives a correct guess, the top row updates, filling in the letter that the user has guessed correct at the right space within the word. The bottom row simply shows incorrect guesses.  
  
- Message Register  
![Screenshot from 2024-07-10 13-10-34](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/044b0d42-c09f-47d9-a90a-05de4b7802d4)  
- Message Register Testbench  
![Screenshot from 2024-07-10 13-39-41](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/fbc8a470-c34d-4e50-a53d-de8ccc1d7ed2)  
The message register is on the player side of the design, it passes on the 8 bit ASCII character selected by the player into the UART transmitter so the host can recieve the letter.  
  
- Keypad Controller  
![Keypad Controller RTL Diagrams (Host and Player)](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/01cca860-028a-4e14-a93a-a28f0f988f86)  
- Keypad Controller Testbench  
![Screenshot from 2024-07-10 13-48-06](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/5989e4d7-5824-43d6-9d29-8aadbc4b1a93)  
The keypad controller is the heart of the input for the game. It allows for the game to have a game-end feature, a clear letter/word feature and a submit letter/word feature. The basic systen for inputting letters follows a classic matrix keypad. Where a user can cycle through letters by pressing a button over and over again. The user can then either submit a word or a letter and that information will be passed on into the next module.  
  
- Keypad FSM  
![Screenshot from 2024-07-10 13-27-39](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/597f99b4-3a8c-450b-819c-131acff8b711)  
This keypad FSM represents the states that the keypad goes through. It uses an ascii_encoder function for letter sets 2-9, keeping track of the number of consecutive button presses.
The user may clear (letter), submit (letter/word), or end game.  
  
- OpenLane Final Layout  
![Screenshot from 2024-07-10 13-30-00](https://github.com/STARS-Design-Track-2024/nebula-ii-team-10/assets/125313246/63523bd1-073c-4c34-b25e-8c0170cb2483)  
Here is our OpenLane final layout for our design.  
  
## Statement from Purdue  
Pending
  
_________________________________________________________________________________________________________________________________________________________________________________________________  
Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 

Refer to the following [readthedocs](https://caravel-sim-infrastructure.readthedocs.io/en/latest/index.html) for how to add cocotb tests to your project. 
