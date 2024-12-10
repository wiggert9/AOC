#lines = readlines("testinput.txt")
#lines = readlines("testinput2.txt")
lines = readlines("input.txt")
topmap = zeros(Int8, length(lines),length(lines[1]))

for i in 1:length(lines)
    for j in 1:length(lines[1])
        topmap[i,j] = parse(Int,lines[i][j]) 
    end
end

function find_end_points(topmap, points)
    val = topmap[points[1]]
    vector = [CartesianIndex(1,0), CartesianIndex(0,1), CartesianIndex(-1,0), CartesianIndex(0,-1)]
    if val ==9 
        return points
    end
    new_points = []
    for p in points
        for vec in vector
            try
                if topmap[p+vec] == val+1
                    push!(new_points, p+vec)
                end
            catch
            end
        end
    end
    if length(new_points)>0
        return find_end_points(topmap, new_points)
    end
end

function score(topmap, startpoints)
    summ=0
    for start in startpoints
        summ+=length((find_end_points(topmap,[start])))
    end
    return summ
end

startpoints = findall(x->x==0, topmap)
println(score(topmap, startpoints))
