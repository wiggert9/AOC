
lines = readlines("input")

map = zeros(ComplexF16, size(lines)[1], length(lines[1]))

function process(map)
    for i in 1:size(map)[1]
        global currentpos
        for j in 1:size(map)[2]
            posval = lines[i][j]
            if posval == '#'
                map[i,j] = 9
            elseif posval == '^'
                map[i,j] = 2
                currentpos = (i,j)
            end
        end
    end
    return currentpos, map
end

function check_if_in_bounds(pos, map)
    N, M = size(map)
    if (pos[1] <1) || (pos[1]>N) || (pos[2] <1) || (pos[2]>M)
        return false
    else
        return true
    end
end

function find_new_pos(pos,map)
    posval = real(map[pos...])
    if posval == 2
        return (pos[1]-1,pos[2])
    elseif posval == 3
        return (pos[1], pos[2]+1)
    elseif posval == 4
        return (pos[1]+1, pos[2])
    elseif posval == 5
        return (pos[1], pos[2]-1)
    end
end

function update_direction(direction)
    if real(direction) == 5
        return 2 +imag(direction)
    else
        return real(direction)+1 +imag(direction)
    end
end

#=
currentpos, map = process(map)
checkbound = true
while checkbound == true
    global currentpos
    global checkbound
    #println(currentpos)
    nextpos = find_new_pos(currentpos, map)
    checkbound = check_if_in_bounds(nextpos,map)
    if checkbound
        while map[nextpos...] == 9
            map[currentpos...] = update_direction(map[currentpos...]) 
            nextpos = find_new_pos(currentpos,map)
        end
        map[nextpos...] = copy(map[currentpos...])
        map[currentpos...] = im
        currentpos = nextpos
    else
        map[currentpos...] = im
    end
end
println(sum(imag(map)))
=#

function check_if_gets_out(block, currentpos, oldmap)
    whilecount=0
    checkbound=true
    local map
    map = copy(oldmap)
    map[block...] = 9
    while checkbound == true && whilecount<10000
        nextpos = find_new_pos(currentpos, map)
        checkbound = check_if_in_bounds(nextpos,map)
        if checkbound
            while map[nextpos...] == 9
                map[currentpos...] = update_direction(map[currentpos...]) 
                nextpos = find_new_pos(currentpos,map)
            end
            map[nextpos...] = copy(map[currentpos...])
            currentpos = nextpos
        end
        whilecount+=1
    end
    if checkbound == false
        return 0
    else
        return 1
    end
end

currentpos, map = process(map)
@time begin
function count_positions(currentpos,map)
    count=0
    for i in 1:size(map)[1]
        println(i)
        for j in 1:size(map)[2]
            if (i,j) != currentpos
                count += check_if_gets_out((i,j),currentpos,map)
            end
        end
    end
    return count
end
end
count_positions(currentpos,map)