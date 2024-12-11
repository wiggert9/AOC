lines =  split(readlines("input.txt")[1], " ")
#lines =  split(readlines("testinput.txt")[1], " ")
start = [parse(Int, num) for num in lines]

startstones = Dict()
for i in start
    startstones[i] = get(startstones, i, 0) +1
end

function blink(stones)
    new_stones= Dict()
    for key in keys(stones)
        if key == 0
            if 1 in keys(new_stones)
                new_stones[1] += get(stones, key, 0)
            else
                new_stones[1] = get(stones, key, 0)
            end
        elseif length(digits(key)) %2 == 0
            half = div(length(digits(key)),2)
            firsthalf = parse(Int, string(key)[1:half])
            secondhalf = parse(Int, string(key)[half+1:end]) 

            if firsthalf in keys(new_stones)
                new_stones[firsthalf] += get(stones, key, 0)
            else
                new_stones[firsthalf] = get(stones, key, 0)
            end

            if secondhalf in keys(new_stones)
                new_stones[secondhalf] += get(stones, key, 0)
            else
                new_stones[secondhalf] = get(stones, key, 0)
            end
        else
            if key*2024 in keys(new_stones)
                new_stones[key*2024] += get(stones, key, 0)
            else
                new_stones[key*2024] = get(stones, key, 0)
            end
        end
    end
    return new_stones
end

@time begin
function countfinal(stones)
    for i in 1:1000
        stones = blink(stones)
    end
    summ=0
    for (i,j) in stones
        summ+=j
    end
    return summ
end
end

println(countfinal(startstones))
