# Wordle Solver
Wordle Solver is a CLI-based program that assists solving the Wordle game on https://www.nytimes.com/games/wordle/index.html .
- The program works by filtering words using your input.
- The program is coded in Julia and tested for Julia v1.8.4 (should work for most other versions too)


## Introduction

Wordle is a game where you have to guess a 5-letter word. You have 6 tries and your tries will give you information on whether the actual word has the letters you guessed or not as well as positions of letters in the actual word. Wordle Solver helps you get the words that fit the information that the game has given you from your guesses.


## Installation and Set-up

1. Have the Julia programming language installed [here](https://julialang.org/downloads/), and make sure it is accessible by running `julia` in the command line.

2. Clone this git or download all its files onto your computer.

3. Using your command line, run the setup script (make sure you are in the right directory):
    ```
    julia setup.jl
    ```

4. To run the main script, run:
    ```
    julia run.jl
    ```

## Program Guide

- Start by running the main script: ```julia run.jl```
- The program works by filtering words using your input, so you need to get some information about the word on [Wordle](https://www.nytimes.com/games/wordle/index.html) beforehand.
  - First, type in 1 to 2 words, example:
    ![image](https://user-images.githubusercontent.com/90701608/212551008-38d7278e-f04d-4720-9355-5d118fe26fe6.png)
    
    Information you can get:
    - Gray letters: The actual word does not contain any gray letters.
    - Yellow letters: The actual word contains the yellow letter but not at that character position.
    - Green letters: The actual word contains the green letter at that exact position.

- Next, you can input the information into the running script according to the following 4 Types of input:
    #### 1. General conditions - what letters are in the actual word or not (ignoring their position)
    - For the above example, input: `ie/abdcough`
        - letters before the dash '/' represent letters that the actual word contain (green and yellow letters)
        - letters after the dash '/' represent letters that the actual word does not contain (gray letters)
        - *You can input/type these conditions in any order or separately, so you can input `/abcdough`, press enter, then input `ie`, and this will do the same thing

    #### 2. Specific conditions
    - For the above example, you can input: `3yi` and `5ye` separately
    - For `3yi`: `3` represents the position of the letter; `y` means yes/is; `i` represents the letter
    - So this means the '3'rd character of the actual word is 'i'
    - Conversely, you can input `3ni` meaning the `3`rd character of the actual word is not `i` (`n` representing no/not)
    - You can also type multiple letters after 'n': `2nenp` means `2`nd character is not `e`, `n`, or `p`

    #### 3. Repeating conditions
    - If you know that the word has repeated letters, for example if there are 2 'e's in the word, input `er2` meaning `e` repeats `2` times

    #### 4. Special commands/inputs
    - input `1v` to view/print out a list of the filtered words
    - input `1av` to turn ON Auto-View (which automatically prints out the list of filtered words every time you input something)
    - input `1avoff` to turn OFF Auto-View
    - input `1i` to view all the information you have previously inputted (limited to what letters are in or not in the actual word)
    - input `1u` to undo your last input. You can undo more than once, but you cannot reverse your undo
    - input `1r` or `reset` to Reset the program
    - input `1e` or `exit` to End program (Program ends automatically when the Wordle has been solved)
    - input `1w` to launch the official Wordle website onto your browser
    - input `1h` or `help` or `?` to list descriptions for each special command

## Features

- Wordle Solver is a prettified program and outputs nicely, it also outputs dynamically based on the size of your Terminal window:

![image](https://user-images.githubusercontent.com/90701608/212552953-dc9cca69-bade-4245-afac-19c6e100de00.png)

![image](https://user-images.githubusercontent.com/90701608/212553887-7999291b-9c63-425c-8dae-34de0f827907.png)

![image](https://user-images.githubusercontent.com/90701608/212554602-f1ed3752-19ca-4e48-934b-d69b4b1ca056.png)

- Wordle Solver will check for invalid inputs:

![image](https://user-images.githubusercontent.com/90701608/212554548-1ec27c93-e9dd-498a-b29e-d530a6bbccad.png)


## Afterword

Wordle Solver is a mini-project and has limitations. More functions will be added soon to improve program and user experience.

