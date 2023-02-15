using Crayons.Box
FILEPATH = @__DIR__

# Sets up tmp directory
if isdir("$FILEPATH/tmp")
    rm("$FILEPATH/tmp", recursive=true)
end
mkdir("$FILEPATH/tmp")

# Initialize global variables
possible = readlines("$FILEPATH/words/words.txt")
correctLetters = Set{Char}()
wrongLetters = Set{Char}()
autoView = false
history = 0

"""Main Function"""
function main()
    global correctLetters, wrongLetters, autoView
    save()
    while true
        # Get input
        print(LIGHT_BLUE_FG, "o" * "-"^(displaysize(stdout)[2] - 2) * "o\n| ", BOLD, WHITE_FG, "input: ")
        input = lowercase(strip(readline()))

        # Check if input is command or invalid
        if check_commands(input) || !check_input(input, "", false)
            continue
        end
        # Filter for general conditions
        if all(isletter, replace(input, "/" => ""))
            inputSplit = split(input, '/')

            # Checks input validity
            if isequal(length(inputSplit), 1)
                push!(inputSplit, "")
            end
            if !check_input(String(inputSplit[1]), String(inputSplit[2]))
                continue
            end

            # Update correctLetters, wrongLetters and possible
            union!(correctLetters, inputSplit[1])
            union!(wrongLetters, inputSplit[2])
            updatepossible_generic(String(inputSplit[1]), String(inputSplit[2]))

            # Filter for Specific conditions
        elseif isnumeric(input[1]) && ((isequal(length(input), 3) && isequal(input[2], 'y')) || (length(input) > 2 && isequal(input[2], 'n'))) && all(isletter, input[3:end])
            if isequal(input[2], 'y')
                if check_contradict(string(input[3:end]), "")
                    continue
                end
                updatepossible_specific(parse(Int8, input[1]), true, collect(input[3:end]))
                union!(correctLetters, input[3])
            else
                updatepossible_specific(parse(Int8, input[1]), false, collect(input[3:end]))
            end

            # Filter for repeating letters
        elseif isletter(input[1]) && isequal(length(input), 3) && isequal(input[2], 'r') && isnumeric(input[3])
            if check_contradict(string(input[1]), "")
                continue
            end
            updatepossible_repeating(input[1], parse(Int8, input[3]))
            union!(correctLetters, input[1])

            # For invalid inputs
        else
            println(BOLD, RED_FG, "Invalid input, try again.")
            continue
        end
        save()
        # Automatic output of filtered list
        if autoView
            view_possible()
        end
    end
end

"""Function for checking if 'correct' and 'wrong' contradict previous inputs in 'correctLetters' and 'wrongLetters (return true if contradicts, false otherwise)"""
function check_contradict(correct::String, wrong::String="")::Bool
    global correctLetters, wrongLetters
    if length(intersect(correctLetters, wrong)) > 0 || length(intersect(wrongLetters, correct)) > 0
        println(BOLD, RED_FG, "Input contradicts previous input, try again.")
        return true
    end
    return false
end

"""Function for checking special inputs/commands (return true if input is a command, false otherwise)"""
function check_commands(input::String)::Bool
    global autoView, possible, correctLetters, wrongLetters
    if input == "1e" || input == "exit"
        println(BOLD, MAGENTA_FG, "Program ended. \n")
        cleanexit()
    elseif input == "1v"
        view_possible()
    elseif input == "1av"
        autoView = true
    elseif input == "1avoff"
        autoView = false
    elseif input == "1r" || input == "reset"
        autoView = false
        possible = readlines("words.txt")
        println(BOLD, MAGENTA_FG, "Program reset.")
    elseif input == "1i"
        println(BOLD, LIGHT_BLUE_FG, "Letters in the word: ", GREEN_FG, join(sort(collect(correctLetters)), ' '))
        println(BOLD, LIGHT_BLUE_FG, "Letters not in the word: ", DARK_GRAY_FG, join(sort(collect(wrongLetters)), ' '))
    elseif input == "1u"
        undo()
    elseif input == "1h" || input == "help"
        println(BOLD, LIGHT_BLUE_FG, "1e/exit: ", WHITE_FG, "End program")
        println(BOLD, LIGHT_BLUE_FG, "1v: ", WHITE_FG, "View filtered list of words")
        println(BOLD, LIGHT_BLUE_FG, "1av: ", WHITE_FG, "Automatic view of filtered list of words")
        println(BOLD, LIGHT_BLUE_FG, "1avoff: ", WHITE_FG, "Turn off automatic view")
        println(BOLD, LIGHT_BLUE_FG, "1r/reset: ", WHITE_FG, "Reset program")
        println(BOLD, LIGHT_BLUE_FG, "1i: ", WHITE_FG, "View letters in the word and letters not in the word")
        println(BOLD, LIGHT_BLUE_FG, "1u: ", WHITE_FG, "Undo last input")
        println(BOLD, LIGHT_BLUE_FG, "1h/help: ", WHITE_FG, "View help")
    else
        return false
    end
    return true
end

"""Function for checking validity of input (return true if passes check, false otherwise)"""
function check_input(input1::String, input2::String, mode::Bool=true)::Bool
    # Check for empty inputs
    if isempty(input1) && isempty(input2)
        println(BOLD, RED_FG, "Empty input, try again.")
        return false
    else
        # Check for repeated letters on both sides of '/'
        if length(intersect(input1, input2)) != 0
            println(BOLD, RED_FG, "Contradiction in input, try again.")
            return false
        end

        # Check if any letters contradict previous inputs
        if mode
            return !check_contradict(input1, input2)
        end
    end
    return true
end

"""Function for filtering the list of words with specific conditions"""
function updatepossible_specific(pos::Int8, type::Bool, letters::Vector{Char})
    global possible
    if type
        filter!(word -> (word[pos] in letters), possible)
    else
        filter!(word -> !(word[pos] in letters), possible)
    end
    check_endprogram()
end

"""Function for filtering the list of words with general conditions"""
function updatepossible_generic(correct::String="", wrong::String="")
    global possible
    filter!(word -> all(letter -> (letter in word), correct) && !any(letter -> (letter in word), wrong), possible)
    check_endprogram()
end

"""Function for filtering the list of words with repeating letters"""
function updatepossible_repeating(letter::Char, times::Int8)
    global possible
    filter!(word -> count(==(letter), word) >= times, possible)
    check_endprogram()
end

"""Function for outputing the Filtered list"""
function view_possible()
    global possible
    len = length(possible)
    if len > 120
        println(BOLD, LIGHT_BLUE_FG, "Too many possible words, input more conditions.")
    elseif len < 1
        println(BOLD, RED_FG, "No possible words. Program ended. \n")
        cleanexit()
    else
        message = ""
        height = min(displaysize(stdout)[1] - 6, 20, len)
        columns = Int16(ceil(len / height))
        space = min(6, (-5 + displaysize(stdout)[2] ÷ columns))
        if space < 1
            println(BOLD, LIGHT_BLUE_FG, "Too many possible words and not enough space to output, input more conditions.")
        else
            for i in 1:height
                message *= "|   "
                for j in i:height:len
                    message *= (possible[j] * " "^space)
                end
                message *= "\n"
            end
            print(LIGHT_GREEN_FG, "o$("-"^(displaysize(stdout)[2]-2))o" * "\n| Possible Word(s): $len\n|\n" * message * "|   \n")
        end
    end
end

"""Function for checking whether the program should end or not"""
function check_endprogram()
    global possible
    if isequal(length(possible), 1)
        view_possible()
        println(BOLD, MAGENTA_FG, "Program ended. 😄 \n")
        cleanexit()
    elseif isequal(length(possible), 0)
        println(BOLD, RED_FG, "No possible words. Program ended. \n")
        cleanexit()
    end
end

"""Function for saving the current input"""
function save()
    global possible, history, correctLetters, wrongLetters
    mkdir("$FILEPATH/tmp/$history")
    open("$FILEPATH/tmp/$history/possible.txt", "w") do io
        for word in possible println(io, word) end
    end
    open("$FILEPATH/tmp/$history/correctLetters.txt", "w") do io
        print(io, join(sort(collect(correctLetters))))
    end
    open("$FILEPATH/tmp/$history/wrongLetters.txt", "w") do io
        print(io, join(sort(collect(wrongLetters))))
    end
    history += 1
end

"""Function for undoing the last input"""
function undo()
    global possible, history, correctLetters, wrongLetters
    if history == 1
        println(BOLD, RED_FG, "No history to undo.")
        return
    end
    history -= 1

    # Deletes newest saves
    rm("$FILEPATH/tmp/$history", recursive=true)

    # Loads previous saves
    possible = readlines("$FILEPATH/tmp/$(history-1)/possible.txt")
    correctLetters = Set(readline("$FILEPATH/tmp/$(history-1)/correctLetters.txt"))
    wrongLetters = Set(readline("$FILEPATH/tmp/$(history-1)/wrongLetters.txt"))
end

"""Function for exiting the program"""
function cleanexit()
    global history
    rm("$FILEPATH/tmp", recursive=true)
    exit()
end

main()
