using Plots
data = read("testinput.txt", String)
data = read("input.txt", String)
data = split(data , "\r\n")



function processinput(data)
    robots =[]
    W=0
    L=0
    for i in 1:length(data)
        if data[i] == ""
            continue
        elseif i==length(data)
            A = match(r"W\=(\d+), L\=(\d+)", data[i])
            W=parse(Int,A[1])
            L=parse(Int,A[2])
        else
            matches = eachmatch(r"-?\d+", data[i])
            vals = parse.(Int, [match.match for match in matches])
            robot_params = [CartesianIndex(vals[1],vals[2]), [vals[3],vals[4]]]
            push!(robots, robot_params)
        end
    end

    return robots, W, L
end


function calc_positions(robots, W, L, t)
    robot_pos = Dict()
    for i in 1:length(robots)
        startpos = robots[i][1]
        vx = robots[i][2][1]
        vy = robots[i][2][2]
        finalpos_large = startpos + t*CartesianIndex(vx ,vy)
        finalpos = CartesianIndex(mod(finalpos_large[1],W), mod(finalpos_large[2],L))
        if finalpos in keys(robot_pos)
            robot_pos[finalpos]+=1
        else
            robot_pos[finalpos] = 1
        end
    end
    return robot_pos
end

function safety_factor(robot_pos, W, L)
    midx = div((W-1),2)
    midy = div((L-1),2)
    ul = 0
    ur = 0
    bl = 0
    br = 0
    for index in keys(robot_pos)
        x = index[1]
        y = index[2]
        if x<midx && y<midy
            ul+=robot_pos[index]
        elseif x>midx && y<midy
            ur +=robot_pos[index]
        elseif x<midx && y>midy
            bl += robot_pos[index]
        elseif x>midx && y>midy
            br += robot_pos[index]
        end
    end
    return ul* ur* bl* br
end

robots, W, L = processinput(data)
#robot_pos = calc_positions(robots, W, L, 100)
#sf = safety_factor(robot_pos, W, L)
#println(sf)

function plot_pos(robots, W, L)
    min=0
    max=100
    for start in max:-1:min
        for t in start:(start)
            time = 103+101*t
            robot_pos = calc_positions(robots, W, L, time)
            x_coords = [v[1] for v in keys(robot_pos)]
            y_coords = [v[2] for v in keys(robot_pos)]
            check = false
            for x in x_coords
                count=0
                for v in keys(robot_pos)
                    if v[1] == x
                        count+=1
                    end
                end
                if count>10
                    check = true
                    break
                end
            end
            if check == false
                for y in y_coords
                    count=0
                    for v in keys(robot_pos)
                        if v[2] == y
                            count+=1
                        end
                    end
                    if count>10
                        check = true
                        break
                    end
                end
            end

            if check == true
                p=plot()
                scatter!(x_coords, y_coords,ms=3, label = string(t))
                display(p)
            end
        end
    end
    print(max*2*+1)
end
plot_pos(robots, W, L)

