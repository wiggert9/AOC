lines = readlines("testinput3.txt")
lines = readlines("input.txt")
N = length(lines)

map = Matrix{Char}(undef , N, N)
for i in 1:N
    for j in 1:N
        map[i,j] = lines[i][j]
    end
end

function check_region(points, area, perimiter, plots_covered, map)
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
    end
    if length(new_points)>0
        return check_region(new_points, area, perimiter, plots_covered, map)
    else
        return area, perimiter, plots_covered
    end
end



arealst = []
perimlst = []
vallst = []
i=1
j=1


function find_areas_perimiters(map)
    arealst = []
    perimlst = []
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
                push!(plots_covered, CartesianIndex(i,j))
                region_area, region_perimiter, plots_covered = check_region(region_start, area, perimiter, plots_covered, map)
                push!(arealst, region_area)
                push!(perimlst, region_perimiter)
                push!(vallst, map[i,j])
                j+=1
            end
        end
        i+=1
    end
    return arealst, perimlst, vallst
end

function find_cost(areas,perimiters)
    summ=0
    for i in 1:length(areas)
        summ+= areas[i]*perimiters[i]
    end
    return summ
end

a, p, v = find_areas_perimiters(map)

println(find_cost(a,p))
