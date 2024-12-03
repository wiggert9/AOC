using CSV

#lines = readlines("testinput.txt")
lines = readlines("input.txt")

data = [parse.(Int,split(line)) for line in lines]
N = size(data)[1]
ar1 = zeros(Int, N)
ar2 = zeros(Int, N)
for i in 1:N
    ar1[i] = Int(data[i][1])
    ar2[i] = Int(data[i][2])
end

ar1 = sort(ar1)
ar2 = sort(ar2)
sim=0
for i in 1:N
    global sim
    sim+= ar1[i]* count(x->(x==ar1[i]), ar2)
end
println(sim)