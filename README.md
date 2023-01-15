# Wordle Solver
Wordle Solver is a terminal based program that assists solving the Wordle game on https://www.nytimes.com/games/wordle/index.html .
The program works by filtering words from your input conditions. 
The program is coded in Julia so Julia.exe is needed to run file.


## Introduction

Wordle is a game where you have to guess a 5-letter word. You have 6 tries and your tries will give you information on whether the actual word has the letters you guessed or not as well as positions of letters in the actual word. Wordle Solver helps you get the words that fit the information that the game has given you from your guesses.


## Installation and Set-up

Download the Julia programming language on https://julialang.org/downloads/ .
Git clone or download the program along with the word.txt file.
Using your computer terminal/Command Prompt, go into the programme's file path and run 
'''julia main.jl'''


## Program Guide

First type in 1 to 2 words into the Wordle page on https://www.nytimes.com/games/wordle/index.html .
Example: 
![image](https://user-images.githubusercontent.com/90701608/212551008-38d7278e-f04d-4720-9355-5d118fe26fe6.png)

Gray letters: The actual word does not contain gray letters
Yellow letters: The actual word contains the yellow letter but not at that position
Green letters: The actual word contains the green letter at that exact position

### There are 2 types of input for Wordle Solver
#### 1. General conditions - what letters are in the actual word or not (ignoring their position)
For the above example, type:
'''
ie
/abdcough
'''
or
'''
ie/abdcough
'''
letters before the dash '/' represent letters that the actual word contain (ie. for green and yellow letters)
letters after the dash '/' represent letters that the actual word does not contain

You can type these conditions in any order.


#### 2. Specific conditions
For the above example, type:
'''
3yi
5ye
'''

'3yi': '3' represents the position of the letter; 'y' means yes/is; 'i' represents the letter
- so this means the '3'rd character of the actual word is 'i'
- similarly you can type '3ni' representing the '3'rd character of the actual word is not 'i'


## Afterword

Wordle Solver is a mini-project developed in a day. More functions to this will be added soon. This is open-sourced and you can use/copy this for your own uses.


