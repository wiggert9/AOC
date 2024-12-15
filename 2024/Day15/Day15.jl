
map_input = readlines("testmap")
moves_input = read("testmoves", String)

#map_input = readlines("map")
#moves_input = read("moves", String)

N = length(map_input)
map = Dict()
for i in 2:(length(map_input)-1)   
    for j in (2:length(map_input[1])-1)
        index = CartesianIndex(j-1,i-1)
        if map_input[i][j] != '.'
            map[index] = map_input[i][j]
            if map_input[i][j] == '@'
                map['@'] = index
            end
        end
    end
end

moves_arr = []
count=0
for move in moves_input
    if move == '<'
        t_move = CartesianIndex(-1,0)
    elseif move == '>'
        t_move = CartesianIndex(1,0)
    elseif move == '^'
        t_move = CartesianIndex(0,-1)
    elseif move == 'v'
        t_move = CartesianIndex(0, 1)
    else
        t_move = "shitty ass parsing error"
    end
    if !(t_move =="shitty ass parsing error")
        push!(moves_arr, t_move)
    end
end

function single_step(move, map)
    robotpos = map['@']
    newpos = robotpos + move
    if 0 in Tuple(newpos) || N-1 in Tuple(newpos)
        k=1
    elseif !(newpos in keys(map))
        delete!(map, robotpos)
        delete!(map, '@')
        map[newpos] = '@'
        map['@'] = newpos
    elseif map[newpos] == '#'
        k=1
    elseif map[newpos] == 'O'
        map = move_robot_and_boxes(robotpos, move, map)
    end
    return map
end


function move_robot_and_boxes(robotpos, move, map)
    nextpos = robotpos+move
    check = true
    while check == true
        nextpos +=move
        if !(nextpos in keys(map))
            check = false
        elseif !(map[nextpos] == 'O')
            check = false
        end
    end

    if 0 in Tuple(nextpos) || N-1 in Tuple(nextpos)
        k=1
    elseif !(nextpos in keys(map))
        delete!(map, robotpos)
        delete!(map, '@')
        delete!(map, robotpos+move)
        map[robotpos+move] = '@'
        map['@'] = robotpos+move
        map[nextpos] = 'O'
    end
    return map
end

function process_moves(moves_arr, map)
    for move in moves_arr
        map = single_step(move, map)
    end
    return map
end

function GPS(map)
    summ=0
    for pos in keys(map)
        if map[pos] == 'O'
            x = pos[1]
            y = pos[2]
            summ+= 100*y + x
        end
    end
    return summ
end

map = process_moves(moves_arr, map)
summ = GPS(map)
println(summ)

