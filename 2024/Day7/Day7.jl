#lines = readlines("testinput")
using Base.Threads
lines = readlines("input")
data = [split(arr, ":") for arr in lines]

target = zeros(length(data))
elements = Vector{Vector{Int}}(undef, length(data))
for i in 1:length(data)
    target[i] = parse(Int64,data[i][1])
    elements[i] = parse.(Int64, split(data[i][2][2:end], " " ))
end


function add_one_binary(array,index)
    array[index] +=1
    if array[index] == 2
        array[index] = 0
        array = add_one_binary(array,index+1)
    end
    return array
end

summ=0
for i in 1:length(data)
    global summ
    operations = zeros(length(elements[i])-1)
    finish = false
    checkcount = 0
    while finish == false
        val = elements[i][1]
        for j in 1:length(operations)
            if operations[j] == 0
                val += elements[i][j+1]
            elseif operations[j] == 1
                val *= elements[i][j+1]
            end
        end

        if val == target[i]
            summ+=val
            finish = true
        elseif sum(operations) == (length(elements[i]) - 1)
            finish = true
        elseif checkcount == 2^(length(elements[i]))
            finish = true
        else
            operations = add_one_binary(operations,1)
        end
        checkcount +=1
    end
end

println(summ)


function add_one_trinary(array,index)
    array[index] +=1
    if array[index] == 3
        array[index] = 0
        array = add_one_trinary(array,index+1)
    end
    return array
end

@time begin
summ2=0
@threads for i in 1:length(data)
    global summ2
    operations = zeros(length(elements[i])-1)
    finish = false
    while finish == false
        val = elements[i][1]
        for j in 1:length(operations)
            if operations[j] == 0
                val += elements[i][j+1]
            elseif operations[j] == 1
                val *= elements[i][j+1]
            elseif operations[j] == 2
                val = parse(Int64, string(val)*string(elements[i][j+1]))
            end
        end
        if val == target[i]
            summ2+=val
            finish = true
        elseif sum(operations) == 2*(length(elements[i]) - 1)
            finish = true
        else
            operations = add_one_trinary(operations,1)
        end
    end
end
end
println(summ2)