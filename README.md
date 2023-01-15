# Wordle Solver
Wordle Solver is a terminal based program that assists solving the Wordle game on https://www.nytimes.com/games/wordle/index.html .
- The program works by filtering words from your input conditions. 
- The program is coded in Julia so Julia.exe is needed to run file.


## Introduction

Wordle is a game where you have to guess a 5-letter word. You have 6 tries and your tries will give you information on whether the actual word has the letters you guessed or not as well as positions of letters in the actual word. Wordle Solver helps you get the words that fit the information that the game has given you from your guesses.


## Installation and Set-up

1. Download the Julia programming language from https://julialang.org/downloads/ .
2. Clone this Git or download/copy the program 'main.jl' along with 'words.txt'.
3. Using your computer Terminal/Command Prompt, go into the programme's file path and run:

```
julia main.jl
```


## Program Guide

- First, type in 1 to 2 words into the Wordle page on https://www.nytimes.com/games/wordle/index.html .
  Example: 
![image](https://user-images.githubusercontent.com/90701608/212551008-38d7278e-f04d-4720-9355-5d118fe26fe6.png)

- Gray letters: The actual word does not contain any gray letters.
- Yellow letters: The actual word contains the yellow letter but not at that character position.
- Green letters: The actual word contains the green letter at that exact position.

### There are 4 Types of input for Wordle Solver
#### 1. General conditions - what letters are in the actual word or not (ignoring their position)
For the above example, type:
```
ie
/abdcough
```
  or
```
ie/abdcough
```
- letters before the dash '/' represent letters that the actual word contain (ie. for green and yellow letters)
- letters after the dash '/' represent letters that the actual word does not contain
- *You can type these conditions in any order.


#### 2. Specific conditions
For the above example, type:
```
3yi
5ye
```

- ```3yi```: '3' represents the position of the letter; 'y' means yes/is; 'i' represents the letter
- So this means the '3'rd character of the actual word is 'i'
- Similarly, you can type ```3ni``` representing the '3'rd character of the actual word is not 'i' ('n' represents no/not)
- You can also type multiple letters after 'n': ```2nenp``` represents '2'nd character is not 'e', 'n', or 'p'


#### 3. Repeating conditions
- If you know that the word has repeated letters, for example there are 2 'e's in the word, type ```er2``` meaning 'e' repeats 2 times
- 


#### 4. Special commands/inputs
- input ```1v``` to view/print out a list of the filtered words
- input ```1av``` to turn ON Auto-View (which automatically prints out the list of filtered words every time you input something)
- input ```1avoff``` to turn OFF Auto-View
- input ```exit``` to End program


## Features

- Wordle Solver is a prettified program and outputs nicely, it also outputs dynamically based on the size of your Terminal window:

![image](https://user-images.githubusercontent.com/90701608/212552953-dc9cca69-bade-4245-afac-19c6e100de00.png)

![image](https://user-images.githubusercontent.com/90701608/212553887-7999291b-9c63-425c-8dae-34de0f827907.png)

![image](https://user-images.githubusercontent.com/90701608/212554602-f1ed3752-19ca-4e48-934b-d69b4b1ca056.png)

- Wordle Solver will check for invalid inputs:

![image](https://user-images.githubusercontent.com/90701608/212554548-1ec27c93-e9dd-498a-b29e-d530a6bbccad.png)


## Afterword

Wordle Solver is a mini-project developed in a weekend. There are still limitations. More functions will be added soon to improve program and user experience. Finally, this is open-sourced and you can use/copy this for your own uses.


