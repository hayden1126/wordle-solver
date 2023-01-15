using DelimitedFiles
using Crayons.Box

# Initialize global variables
possible = vec(DelimitedFiles.readdlm("words.txt", '\t', String))
correctLetters = Set{Char}()
wrongLetters = Set{Char}()
autoView = false
specialInput = false

# Main Function
function main()
    global correctLetters, wrongLetters, autoView, specialInput
    while true
        if autoView
            viewPossible()
        end
        
        # Get input
        print(LIGHT_BLUE_FG, "o"*"-"^(displaysize(stdout)[2]-2)*"o\n| ", BOLD, WHITE_FG, "input: ")
        input = lowercase(strip(readline()))
        checkInput(input)  

        # Filter for general conditions
        if all(isletter, replace(input, "/" => ""))
            input = split(input, '/')
            
            # Checks input validity
            if isequal(length(input), 1)
                push!(input, "")
            end
            if !checkInput(String(input[1]), String(input[2]))
                continue
            end

            # Update correctLetters, wrongLetters and possible
            union!(correctLetters, input[1])
            union!(wrongLetters, input[2])
            updatePossibleGeneric(String(input[1]), String(input[2]))
        
        # Filter for Specific conditions
        elseif isnumeric(input[1]) && length(input) > 2 && input[2] in ['y', 'n'] && all(isletter, input[3:end])
            updatePossibleSpecific(parse(Int8, input[1]), isequal(input[2], 'y'), collect(input[3:end]))
        
        # For invalid inputs
        elseif !specialInput
            println(BOLD, RED_FG, "Invalid input, try again.")      
        end
    end
end

# Function for checking validity of input
function checkInput(input1::String, input2::String = "")::Bool
    global correctLetters, wrongLetters, autoView, specialInput
    specialInput = false
    if isempty(input2)
        # Check for empty inputs
        if isempty(input1)
            println(BOLD, RED_FG, "Empty input, try again.")
            return false

        # Special inputs: commands
        elseif input1 == "exit"
            println(BOLD, LIGHT_BLUE_BG, "Program ended. \n")
            exit()
        elseif input1 == "1v"
            viewPossible()
        elseif input1 == "1av"
            autoView, specialInput = true, true
        elseif input1 == "1avoff"
            autoView, specialInput = false, true
        end      
    else
        # Check for repeated letters on both sides of '/'
        if length(intersect(input1, input2)) != 0
            println(BOLD, RED_FG, "Letters on both sides are not allowed, input again.")
            return false
        end
        
        # Check if any letters contradict previous inputs
        if length(intersect(correctLetters, input2)) > 0 || length(intersect(wrongLetters, input1)) > 0
            println(BOLD, RED_FG, "Input contradicts previous input, try again.")
            return false
        end   
    end
    return true
end

# Function for filtering the list of words with specific conditions
function updatePossibleSpecific(pos::Int8, type::Bool, letters::Vector{Char})
    global possible
    if type
        possible = filter(word -> (word[pos] in letters), possible)
    else
        possible = filter(word -> !(word[pos] in letters), possible)
    end
    checkEndProgram
end

# Function for filtering the list of words with general conditions
function updatePossibleGeneric(correct::String = "", wrong::String = "")
    global possible
    filter!(word -> all(letter->(letter in word), correct) && !any(letter->(letter in word), wrong), possible)
    checkEndProgram()
end

# Function for outputing the Filtered list 
function viewPossible()
    global possible
    len = length(possible)
    if len > 120
        println(BOLD, LIGHT_BLUE_FG, "Too many possible words, input more conditions.")
    elseif len < 1
        println(BOLD, RED_FG, "No possible words. Program ended. \n")
        exit()
    else
        message = ""
        height = min(displaysize(stdout)[1]-6, 20, len)
        columns = Int16(ceil(len/height))
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
            print(LIGHT_GREEN_FG, "o$("-"^(displaysize(stdout)[2]-2))o" * "\n| Possible Word(s): $len\n|\n"*message*"|   \n")
        end
    end
end

# Function for checking whether the program should end or not
function checkEndProgram()
    global possible
    if isequal(length(possible), 1)
        viewPossible()
        println(BOLD, LIGHT_BLUE_FG, "Program ended. 😄 \n")
        exit()
    elseif isequal(length(possible), 0)
        println(BOLD, RED_FG, "No possible words. Program ended. \n")
        exit()
    end
end

main()