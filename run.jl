using Crayons.Box
const FILEPATH = @__DIR__

# Sets up tmp directory
if isdir("$FILEPATH/tmp")
    rm("$FILEPATH/tmp", recursive=true)
end
mkdir("$FILEPATH/tmp")

# Initialize global variables
POSSIBLE = readlines("$FILEPATH/words/words.txt")
CORRECTLETTERS = Set{Char}()
WRONGLETTERS = Set{Char}()
AUTOVIEW = false
VERSION = 0

"""Main Function"""
function main()
    global VERSION, POSSIBLE, CORRECTLETTERS, WRONGLETTERS, AUTOVIEW
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
            union!(CORRECTLETTERS, inputSplit[1])
            union!(WRONGLETTERS, inputSplit[2])
            correct, wrong = String(inputSplit[1]), String(inputSplit[2])
            filter!(word -> all(letter -> (letter in word), correct) && !any(letter -> (letter in word), wrong), POSSIBLE)

        # Filter for Specific conditions
        elseif isnumeric(input[1]) && ((isequal(length(input), 3) && isequal(input[2], 'y')) || (length(input) > 2 && isequal(input[2], 'n'))) && all(isletter, input[3:end])
            pos = parse(Int8, input[1])
            letters = collect(input[3:end])
            if isequal(input[2], 'y')
                if check_contradict(string(input[3:end]), "")
                    continue
                end
                filter!(word -> (word[pos] in letters), POSSIBLE)
                union!(CORRECTLETTERS, input[3])
            else
                filter!(word -> !(word[pos] in letters), POSSIBLE)
            end

        # Filter for repeating letters
        elseif isletter(input[1]) && isequal(length(input), 3) && isequal(input[2], 'r') && isnumeric(input[3])
            if check_contradict(string(input[1]), "")
                continue
            end
            times = parse(Int8, input[3])
            filter!(word -> count(==(input[1]), word) >= times, POSSIBLE)
            union!(CORRECTLETTERS, input[1])

        # For invalid inputs
        else
            println(BOLD, RED_FG, "Invalid input, try again.")
            continue
        end
        
        # Save and undo if no possible
        save()
        len = length(POSSIBLE)
        if len == 0
            println(BOLD, RED_FG, "No possible words, try again.")
            undo()
            continue
        elseif len == 1
            println(BOLD, LIGHT_GREEN_FG, "o$("-"^(displaysize(stdout)[2]-2))o", "\n| Possible Word(s): 1 \n|\n|   $(POSSIBLE[1])\n|   ")
            print(BOLD, LIGHT_BLUE_FG, "o$("-"^(displaysize(stdout)[2]-2))o", "\n| Empty input to exit, anything else to continue. \n|\n|   ", WHITE_FG, "input: ")
            input = lowercase(strip(readline()))
            if input == ""
                println(BOLD, MAGENTA_FG, "Program ended. 😄 \n")
                exit()
            end
        end

        # Automatic output of filtered list
        if AUTOVIEW || len <= 10
            view_possible()
        end
    end
end

"""Function for checking if 'correct' and 'wrong' contradict previous inputs in 'correctLetters' and 'wrongLetters (return true if contradicts, false otherwise)"""
function check_contradict(correct::String, wrong::String="")::Bool
    global CORRECTLETTERS, WRONGLETTERS
    if length(intersect(CORRECTLETTERS, wrong)) > 0 || length(intersect(WRONGLETTERS, correct)) > 0
        println(BOLD, RED_FG, "Input contradicts previous input, try again.")
        return true
    end
    return false
end

"""Function for checking special inputs/commands (return true if input is a command, false otherwise)"""
function check_commands(input::String)::Bool
    global AUTOVIEW, VERSION, POSSIBLE, CORRECTLETTERS, WRONGLETTERS
    if input == "1e" || input == "exit"
        println(BOLD, MAGENTA_FG, "Program ended. \n")
        exit()
    elseif input == "1v"
        view_possible()
    elseif input == "1av"
        AUTOVIEW = true
        view_possible()
    elseif input == "1avoff"
        AUTOVIEW = false
    elseif input == "1r" || input == "reset"
        AUTOVIEW = false
        for _ in 1:VERSION-1
            undo()
        end
        println(BOLD, MAGENTA_FG, "Program reset.")
    elseif input == "1i"
        println(BOLD, LIGHT_BLUE_FG, "Letters in the word: ", GREEN_FG, join(sort(collect(CORRECTLETTERS)), ' '))
        println(BOLD, LIGHT_BLUE_FG, "Letters not in the word: ", DARK_GRAY_FG, join(sort(collect(WRONGLETTERS)), ' '))
    elseif input == "1u"
        undo()
    elseif input == "1h" || input == "help" || input == "?"
        println(BOLD, LIGHT_BLUE_FG, "1e/exit: ", WHITE_FG, "End program")
        println(BOLD, LIGHT_BLUE_FG, "1v: ", WHITE_FG, "View filtered list of words")
        println(BOLD, LIGHT_BLUE_FG, "1av: ", WHITE_FG, "Automatic view of filtered list of words")
        println(BOLD, LIGHT_BLUE_FG, "1avoff: ", WHITE_FG, "Turn off automatic view")
        println(BOLD, LIGHT_BLUE_FG, "1r/reset: ", WHITE_FG, "Reset program")
        println(BOLD, LIGHT_BLUE_FG, "1i: ", WHITE_FG, "View letters in the word and letters not in the word")
        println(BOLD, LIGHT_BLUE_FG, "1u: ", WHITE_FG, "Undo last input")
        println(BOLD, LIGHT_BLUE_FG, "1h/help/?: ", WHITE_FG, "View help")
    else
        return false
    end
    return true
end

"""Function for checking validity of input (return true if passes check, false otherwise)"""
function check_input(input1::String, input2::String, mode::Bool=true)::Bool
    # Check if empty inputs on both side of '/'
    if isempty(input1) && isempty(input2)
        println(BOLD, RED_FG, "Empty input, try again.")
        return false
    elseif count(x -> x == '/', input1) > 1 || count(x -> x == '/', input2) > 1
        println(BOLD, RED_FG, "Invalid input, try again.")
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

"""Function for outputing the Filtered list"""
function view_possible()
    global POSSIBLE
    len = length(POSSIBLE)
    if len > 120
        println(BOLD, LIGHT_BLUE_FG, "Too many possible words, input more conditions.")
    elseif len > 0
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
                    message *= (POSSIBLE[j] * " "^space)
                end
                message *= "\n"
            end
            print(LIGHT_GREEN_FG, "o$("-"^(displaysize(stdout)[2]-2))o" * "\n| Possible Word(s): $len\n|\n" * message * "|   \n")
        end
    end
end

"""Function for saving the current input"""
function save()
    global VERSION, POSSIBLE, CORRECTLETTERS, WRONGLETTERS
    mkdir("$FILEPATH/tmp/$VERSION")
    open("$FILEPATH/tmp/$VERSION/possible.txt", "w") do io
        for word in POSSIBLE println(io, word) end
    end
    open("$FILEPATH/tmp/$VERSION/correctLetters.txt", "w") do io
        print(io, join(sort(collect(CORRECTLETTERS))))
    end
    open("$FILEPATH/tmp/$VERSION/wrongLetters.txt", "w") do io
        print(io, join(sort(collect(WRONGLETTERS))))
    end
    VERSION += 1
end

"""Function for undoing the last input"""
function undo()
    global VERSION, POSSIBLE, CORRECTLETTERS, WRONGLETTERS
    if VERSION == 1
        println(BOLD, RED_FG, "No previous version available.")
        return
    end
    VERSION -= 1

    # Deletes newest saves
    rm("$FILEPATH/tmp/$VERSION", recursive=true)

    # Loads previous saves
    POSSIBLE = readlines("$FILEPATH/tmp/$(VERSION-1)/possible.txt")
    CORRECTLETTERS = Set(readline("$FILEPATH/tmp/$(VERSION-1)/correctLetters.txt"))
    WRONGLETTERS = Set(readline("$FILEPATH/tmp/$(VERSION-1)/wrongLetters.txt"))
end

function cleanexit()
    rm("$FILEPATH/tmp", recursive=true)
end
atexit(cleanexit)

main()