

#map_input = readlines("testmap copy")
#moves_input = read("testmoves copy", String)

#map_input = readlines("testmap")
#moves_input = read("testmoves", String)

map_input = readlines("map")
moves_input = read("moves", String)

N = length(map_input)
map = Dict()
for i in 2:(length(map_input)-1)   
    for j in (2:length(map_input[1])-1)
        index = CartesianIndex(2*(j-1)-1,i-1)
        if map_input[i][j] != '.'
            if map_input[i][j] == 'O'
                map[index] = '['
                map[index+CartesianIndex(1,0)] = ']'
            elseif map_input[i][j] == '@'
                map['@'] = index
                map[index] = '@'
            elseif map_input[i][j] == '#'
                map[index] = '#'
                map[index+CartesianIndex(1,0)] = '#'
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
    if 0 in Tuple(newpos) || newpos[1] == 2*(N-2)+1 || newpos[2] == N-1
        k=1
    elseif !(newpos in keys(map))
        delete!(map, robotpos)
        delete!(map, '@')
        map[newpos] = '@'
        map['@'] = newpos
    elseif map[newpos] == '#'
        k=1
    elseif map[newpos] == '[' || map[newpos] == ']'
        map = move_robot_and_boxes(robotpos, move, map)
    end
    return map
end

function check_box_wall(pos, move, box_list, map, wall_check)
    newpos = pos+move
    if 0 in Tuple(newpos) || newpos[1] == 2*(N-2)+1 || newpos[2] == N-1
        wall_check+=1
    elseif !(newpos in keys(map))
        wall_check+=0
    elseif map[newpos] == '#'
        wall_check+=1
    elseif map[newpos] == '['
        push!(box_list, (newpos, '['))
        push!(box_list, (newpos + CartesianIndex(1,0), ']'))
        box_list, wall_check = check_box_wall(newpos, move , box_list, map, wall_check)
        box_list, wall_check = check_box_wall(newpos+ CartesianIndex(1,0), move , box_list, map, wall_check)
    elseif map[newpos] == ']'
        push!(box_list, (newpos, ']'))
        push!(box_list, (newpos + CartesianIndex(-1,0), '['))
        box_list, wall_check = check_box_wall(newpos, move , box_list, map, wall_check)
        box_list, wall_check = check_box_wall(newpos+ CartesianIndex(-1,0), move , box_list, map, wall_check)
    end
    return box_list, wall_check
end

function move_robot_and_boxes(robotpos, move, map)
    nextpos = robotpos+move
    if move[2] == 0
        wall = false
        val = map[nextpos]
        count=1
        while val == ']' || val =='['
            nextpos+=move
            count+=1
            if 0 in Tuple(nextpos) || nextpos[1] == 2*(N-2)+1 || nextpos[2] == N-1
                wall = true
                val = '#'
            elseif !(nextpos in keys(map))
                val = '#'
            elseif map[nextpos] == '#'
                wall = true
                val = '#'
            else
                val=map[nextpos]
            end
        end
        if wall == false
            right = true
            if map[robotpos+move] == '['
                counter=0
            else
                counter=1
            end
            for i in 2:count
                if counter%2 ==0
                    map[robotpos+i*move] = '['
                else
                    map[robotpos+i*move] = ']'
                end
                counter+=1
            end
            delete!(map, robotpos)
            map[robotpos+move] = '@'
            map['@'] = robotpos+move
        end
    else
        wall_check = 0
        box_list = []
        box_list, wall_check = check_box_wall(robotpos, move, box_list, map, wall_check)
        if wall_check ==0
            for point in box_list
                x = point[1][1]
                y = point[1][2]
                delete!(map, CartesianIndex(x,y))
            end
            for point in box_list
                x = point[1][1]
                y = point[1][2]
                newpos = CartesianIndex(x,y)+move
                side = point[2]
                map[newpos] = side
            end
            delete!(map, robotpos)
            map[robotpos+move] = '@'
            map['@'] = robotpos+move
        end
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
        if map[pos] == '['
            x = pos[1]+1
            y = pos[2]
            summ+= 100*y + x
        end
    end
    return summ
end

function readout(map)
    for j in 1:(N-2)
        str = ""
        for i in 1:2*(N-2)
            if CartesianIndex(i,j) in keys(map)
                str*= map[CartesianIndex(i,j)]
            else
                str*='.'
            end
        end
        println(str)
    end
end
#map = process_moves(moves_arr, map)
#summ = GPS(map)
#println(summ)
println("###################### NEW RUN ####################")
map = process_moves(moves_arr, map)
readout(map)
summ = GPS(map)
println(summ)
