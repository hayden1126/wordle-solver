# Wordle Solver
Wordle Solver is a CLI-based program that assists solving the Wordle game on https://www.nytimes.com/games/wordle/index.html .
- The program works by filtering words using your input.
- The program is coded in Julia and tested for Julia v1.8.4 (should work for most other versions too)


## Introduction

Wordle is a game where you have to guess a 5-letter word. You have 6 tries and your tries will give you information on whether the actual word has the letters you guessed or not as well as positions of letters in the actual word. Wordle Solver helps you get the words that fit the information that the game has given you from your guesses.


## Installation and Set-up

1. Have the Julia programming language installed [here](https://julialang.org/downloads/), and make sure it is accessible by running `julia` in the command line.

2. Clone this git or download all its files onto your computer.

3. Using your command line, run the setup script which setups the necessary packages (make sure you are in the right directory):
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
       
    ![image](https://user-images.githubusercontent.com/90701608/222910446-9224ca45-b209-4ac0-bf57-a9924ef62225.png)
    
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
    - For the above example, you can input: `2ne` and `3nr` separately
    - For `2ne`: `2` represents the position of the letter; `n` means not/no; `e` represents the letter
    - So this means the '2'nd character of the actual word is not 'e'
    - You can also type multiple letters after 'n', example: `1nenp` means `1`st character is not `e`, `n`, or `p`
    - Conversely, you can input `3yi` meaning the `3`rd character of the actual word is `i` (`y` representing yes/is)

    #### 3. Repeating conditions
    - If the word has repeated letters, for example if there are 2 or MORE 'e's in the word, input `er2` meaning `e` repeats AT LEAST `2` times
    - If the letter only repeats EXACTLY 2 times, input `eo2` meaning `e` repeats ONLY `2` times

    #### 4. Special commands/inputs
    - input `1g` or `1g <optional number>` to view/print out that number of recommended words (words that can help you get the most amount of information)
    - input `1v` to view/print out a list of the filtered possible words
    - input `1av` to turn ON Auto-View (which automatically prints out the list of filtered words every time you input something)
    - input `1avoff` to turn OFF Auto-View (This is turned back on if the number of possible words left is 10 or less)
    - input `1i` to view all the information you have previously inputted (limited to what letters are in or not in the actual word)
    - input `1u` to undo your last input. You can undo more than once, but you cannot reverse your undo
    - input `1r` or `reset` to Reset the program
    - input `1e` or `exit` to End program (Program ends automatically when the Wordle has been solved)
    - input `1w` to launch the official Wordle website onto your browser
    - input `1h` or `help` or `?` to list descriptions for each special command

- For the above example, after inputing the filtering conditions, I would type `1g` to get some recommended words:

    ![image](https://user-images.githubusercontent.com/90701608/222912360-b97183e3-2992-4635-8d34-2bac44de5c58.png)

- Then I would guess the first word in the recommended list:

    ![image](https://user-images.githubusercontent.com/90701608/222912913-ea3a2e22-abdf-476d-a632-bacb4bc33df6.png)

- Then input the conditions again:

    ![image](https://user-images.githubusercontent.com/90701608/222913277-4b246a23-cab8-4d87-8064-56ec148a5d0d.png)

- Wow! This is great, I do not even have to input more conditions such as `3nt` and `5yd`, and we already got the answer to the wordle!

    ![image](https://user-images.githubusercontent.com/90701608/222913387-ae3970c4-10bd-402b-9ef3-c3f9e986d6b7.png)

## Features

- Wordle Solver is a prettified program and outputs nicely, it also outputs dynamically based on the size of your Terminal window:

![image](https://user-images.githubusercontent.com/90701608/212553887-7999291b-9c63-425c-8dae-34de0f827907.png)

- Wordle Solver will check for invalid inputs:

![image](https://user-images.githubusercontent.com/90701608/212554548-1ec27c93-e9dd-498a-b29e-d530a6bbccad.png)


## Afterword

Wordle Solver started out as a mini-project made in a weekend. Now, a lot more functions have been added. However, there are still improvements to be made, more updates coming soon!

