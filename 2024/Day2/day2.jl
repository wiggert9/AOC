using CSV, StatsBase

#lines = readlines("testinput.txt")
lines = readlines("input.txt")

data = [parse.(Int,split(line)) for line in lines]
sum=0

data2 = Vector{Vector{Float64}}()

for i in 1:length(data)
    global sum
    global data2
    check = 0
    diff1 = data[i][1:(length(data[i])-1)]
    diff2 = data[i][2:end]
    trend = sign(mean(diff2.-diff1))
    for j in 1:(length(data[i])-1)
        diff = data[i][j+1] - data[i][j]  
        if 1<=(trend*diff)<=3
            continue
        else
            check=1
            newar1 = deleteat!(copy(data[i]),j)
            newar2 = deleteat!(copy(data[i]),j+1)
            push!(data2,newar1) 
            push!(data2,newar2) 
            break
        end

    end
    
    if check == 0
        sum+=1
    end
end
sum2 = sum
k=0
for i in 1:length(data2)
    global sum
    global k
    check = 0
    trend = 0
    if i==k
        continue
    else
        for j in 1:(length(data2[i])-1)
            diff = data2[i][j+1] - data2[i][j]
            if j==1
                trend = sign(diff)
            end

            if 1<=(trend*diff)<=3   
                continue
            else
                check=1
                break
            end
        end

        if check == 0
            if !iseven(i)
                k=i+1
                #println(data[Int((i+1)/2)])
                #println(data2[i])
                #println(data2[i+1]) 
                #println()
            end 
            sum+=1
        end
    end
end
println(sum2)
println(sum)