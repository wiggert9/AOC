#lines = readlines("testinput3.txt")
lines = readlines("input.txt")
N = length(lines)

map = Matrix{Char}(undef , N, N)
for i in 1:N
    for j in 1:N
        map[i,j] = lines[i][j]
    end
end


function check_corners(point)
    directions = [CartesianIndex(0,1), CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,-1)]
    options = []
    for i in directions
        for j in directions
            if i+j != CartesianIndex(0,0) && i!=j && !((j,i) in options)
                push!(options,(i,j))
            end
        end
    end

    corners = 0
    for op in options
        if 0 in Tuple(point+op[1])
            check1 = true
        elseif N+1 in Tuple(point+op[1])
            check1=true
        elseif map[point+op[1]] != map[point]
            check1 = true
        else
            check1=false
        end
        if 0 in Tuple(point+op[2])
            check2 = true
        elseif N+1 in Tuple(point+op[2])
            check2=true
        elseif map[point+op[2]] != map[point]
            check2 = true
        else
            check2=false
        end

        if !check1 && !check2
            if map[point+op[1]+op[2]] != map[point]
                check1=true
                check2=true
            end
        end
        if check1 && check2
            corners+=1
        end
    end
    #println(point)
    #println(corners)
    #println("")
    return corners
end


function check_region(points, area, perimiter, corners, plots_covered, map)
    new_points = []
    directions = [CartesianIndex(0,1), CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,-1)]
    for point in points
        for dir in directions
            if (0 in Tuple(point+dir)) || (N+1 in Tuple(point+dir))
                perimiter+=1
            else
                if map[point+dir] == map[point]
                    if !(point+dir in plots_covered)
                        push!(new_points, point+dir)
                        push!(plots_covered, point+dir)
                        area+=1
                    else
                        continue
                    end
                else
                    perimiter += 1
                end
            end
            #=println(point)
            println(new_points)
            println(point+dir)
            println(perimiter)
            println("")
            =#
        end
        corners +=check_corners(point)
    end
    
    if length(new_points)>0
        return check_region(new_points, area, perimiter, corners, plots_covered, map)
    else
        return area, perimiter, corners, plots_covered
    end
end



arealst = []
perimlst = []
vallst = []
i=1
j=1


function find_areas_corners(map)
    arealst = []
    perimlst = []
    cornerlst = []
    vallst = []
    plots_covered = []
    N = size(map)[1]
    
    i=1
    while i <= N
        println(i)
        j=1
        while j <=N
            if CartesianIndex(i,j) in plots_covered
                j+=1
            else
                region_start = [CartesianIndex(i,j)]
                area = 1
                perimiter = 0
                corners = 0
                push!(plots_covered, CartesianIndex(i,j))
                region_area, region_perimiter, region_corner, plots_covered = check_region(region_start, area, perimiter, corners, plots_covered, map)
                push!(arealst, region_area)
                push!(perimlst, region_perimiter)
                push!(cornerlst, region_corner)
                push!(vallst, map[i,j])
                j+=1
            end
        end
        i+=1
    end
    return arealst, perimlst, cornerlst, vallst
end

function find_cost(areas,perimiters)
    summ=0
    for i in 1:length(areas)
        summ+= areas[i]*perimiters[i]
    end
    return summ
end

a, p, c, v = find_areas_corners(map)

println(find_cost(a,c))
