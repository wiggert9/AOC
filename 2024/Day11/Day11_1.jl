lines =  split(readlines("input.txt")[1], " ")
#lines =  split(readlines("testinput.txt")[1], " ")
start = [parse(Int, num) for num in lines]

function blink(stones)
    newarr = []
    for i in 1:length(stones)
        if stones[i] == 0
            push!(newarr, 1)
        elseif length(digits(stones[i])) %2 == 0
            half = div(length(digits(stones[i])),2)
            firsthalf = parse(Int, string(stones[i])[1:half])
            secondhalf = parse(Int, string(stones[i])[half+1:end]) 
            push!(newarr,firsthalf)
            push!(newarr,secondhalf)
        else
            push!(newarr, stones[i]*2024)
        end
    end
    return newarr
end

function countfinal(stones)
    for i in 1:75
        println(i)
        stones = blink(stones)
    end
    return length(stones)
end

countfinal(start)