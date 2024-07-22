# STARS 2024 Design Final Project

## TEAM NAME

* Jason Klutho
* Alex Weyer
* Levi Thompson
* John Brower
* Hassan Al-alawi

## Project Type

The Team 12 STARS 2024 project is a polyphonic synthesiszer with 75 degress of polyphony and interfaced to a MIDI-UART port. The project can be interacted with by attaching a MIDI capable device to the chip or streaming a MIDI file over a USB to MIDI cable from any PC.

## Pin Layout

Note that on the final chip, there are 38 gpio of which you have access to 4.
The first number represents the GPIO on the physical board. The second number
in brackets represents the number in your verilog code

00[00] Input: MIDI-UART Serial-In
01[--] Input/Output: SPI Flash
02[--] Input/Output: SPI Flash
03[--] Input/Output: SPI Flash
04[--] Input/Output: SPI Flash
05[01] Input: Clear Notes
06[02] Input: Wave Mode Button
07[03] Output: DAC_IN_0
08[04] Output: DAC_IN_1
09[05] Output: DAC_IN_2
10[06] Output: DAC_IN_3
11[07] Output: DAC_IN_4
12[08] Output: DAC_IN_5
13[09] Output: DAC_IN_6
14[10] Output: DAC_IN_7
15[11] Output: DAC_IN_8
16[12] Output: DAC_IN_9
17[13] Output: DAC_IN_10
18[14] Output: DAC_IN_11
19[15] Output: DAC_IN_12
20[16] Output: DAC_IN_13
21[17] Output: DAC_IN_14
22[18] Output: DAC_IN_15
23[19] Output: NA
24[20] Output: NA
25[21] Output: NA
26[22] Output: NA
27[23] Output: NA
28[24] Output: NA
29[25] Output: NA
30[26] Output: NA
31[27] Output: NA
32[28] Output: NA
33[29] Output: NA
34[30] Output: NA
35[31] Output: NA
36[32] Output: NA
37[33] Output: NA
38[34] Output: NA

## Supporting Equipment

12-16 Input DAC/ 12-16 Input R2R DAC

LM386N Op-Amp

Audio Jack

PC817 Octocoupler

MIDI Connector

![1721667175371](image/README/1721667175371.png)

## RTL Diagrams

Refrence the drawio files in folder.

## Statement from Purdue

Pending
