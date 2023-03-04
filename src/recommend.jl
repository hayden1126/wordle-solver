sigmoid(z::Real) = 1.0 / (1.0 + exp(-z))

# Count the number of words that contain a letter and the number of times a letter appears in a word
function word_count(possible::Vector{String})::Tuple{Dict{Char, Int}, Dict{Char, Int}}
    # Dictionary for storing the number of words that contain a letter
    wordcount = Dict{Char, Int}('a' => 0, 'b' => 0, 'c' => 0, 'd' => 0, 'e' => 0, 'f' => 0, 'g' => 0, 'h' => 0, 'i' => 0, 'j' => 0, 'k' => 0, 'l' => 0, 'm' => 0, 'n' => 0, 'o' => 0, 'p' => 0, 'q' => 0, 'r' => 0, 's' => 0, 't' => 0, 'u' => 0, 'v' => 0, 'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0)
    repeatcount = Dict{Char, Int}('a' => 0, 'b' => 0, 'c' => 0, 'd' => 0, 'e' => 0, 'f' => 0, 'g' => 0, 'h' => 0, 'i' => 0, 'j' => 0, 'k' => 0, 'l' => 0, 'm' => 0, 'n' => 0, 'o' => 0, 'p' => 0, 'q' => 0, 'r' => 0, 's' => 0, 't' => 0, 'u' => 0, 'v' => 0, 'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0)
    for word in possible
        for letter in Set(word)
            wordcount[letter] += 1
        end
        for (index,letter) in enumerate(word)
            if letter in word[1:index-1] 
                repeatcount[letter] += 1
                @goto repeatcountloop
            end
        end
        @label repeatcountloop
    end
    return wordcount, repeatcount
end

# Score a word
function score(word::String, wordcount::Dict{Char, Int}, repeatcount::Dict{Char, Int}, correct::Set{Char}, wrong::Set{Char}, locked::Vector{Char}, len::Int)::Float64
    # Dictionary for storing the number of times a letter appears in a word
    score = 0.0
    for (index, letter) in enumerate(word)
        if letter in word[1:index-1] continue end
        # If letter is in locked
        if letter in locked
            # If letter is locked at the right position
            if locked[index] != letter
                score -= 150.0
            # If letter is locked not at the right position
            else
                score += 60.0
            end
        # If letter is not locked but in correct
        elseif letter in correct
            if len > 3
                score -= 130.0
            else
                score += 400.0
            end
        # If letter is in wrong
        elseif letter in wrong
            score -= 200.0
        end

        if wordcount[letter] == len
            score -= (60 + len/24.0)
        elseif len < 4 && wordcount[letter] == len
            score += 300.0
        else
            score += 2.0*wordcount[letter] + sigmoid(len-10)*repeatcount[letter]
        end
    end
    return score
end

# Rank the guesses by the number of times they appear in the possible words
function filter_guesses(possible::Vector{String}, correct::Set{Char}, wrong::Set{Char}, locked::Vector{Char}, number::Int=5)::Vector{String}
    len = length(possible)
    if len == 2 return possible end
    guesses = readlines("$FILEDIR/words/guess_$(WORDLENGTH)ltr.txt")
    wordcount, repeatcount = word_count(possible)
    sort!(guesses, by = x -> (score(x, wordcount, repeatcount, correct, wrong, locked, len)), rev = true)
    return guesses[1:number]
end