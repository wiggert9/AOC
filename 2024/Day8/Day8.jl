#lines = readlines("testinput")
lines = readlines("input")

function generate_antennamap(lines)
    antennamap = Matrix{Char}(undef, length(lines),length(lines[1]))
    for i in 1:length(lines)
        for j in 1:length(lines[1])
            antennamap[i,j] = lines[i][j]
        end
    end
    return antennamap
end

antennamap = generate_antennamap(lines)
unique_nodes = unique(antennamap)

function antinode_map(antennamap,unique_nodes)
    antinodemap = zeros(size(antennamap))
    for char in unique_nodes
        if char == '.'
            continue
        else
            positions = findall(x->x==char, antennamap)
            num_pos = length(positions)
        end
        for i in 1:num_pos
            for j in i:num_pos
                pos1 = positions[i]
                pos2 = positions[j]
                if pos1 == pos2
                    continue
                else
                    diff = pos2-pos1
                    antinodepos1 = pos1-diff
                    antinodepos2 = pos2+diff
                    try
                        antinodemap[antinodepos1] = 1
                    catch 
                    
                    end
                    try
                        antinodemap[antinodepos2] = 1
                    catch
                    end
                end
            end
        end
    end
    return antinodemap
end

antinodemap = antinode_map(antennamap,unique_nodes)
println(sum(antinodemap))
                

function antinode_map_2(antennamap,unique_nodes)
    antinodemap = zeros(size(antennamap))
    for char in unique_nodes
        if char == '.'
            continue
        else
            positions = findall(x->x==char, antennamap)
            num_pos = length(positions)
        end
        for i in 1:num_pos
            for j in i:num_pos
                pos1 = positions[i]
                pos2 = positions[j]
                if pos1 == pos2
                    continue
                else
                    diff = pos2-pos1
                    temp = div.(Tuple(diff),gcd(diff[1],diff[2]))
                    step = CartesianIndex(temp[1], temp[2])
                    antinodemap[pos1] = 1
                    antinodemap[pos2] = 1
                for i in 1:size(antennamap)[1]
                    antinodepos1 = pos1-i*step
                    antinodepos2 = pos1+i*step
                    try
                        antinodemap[antinodepos1] = 1
                    catch 
                    
                    end
                    try
                        antinodemap[antinodepos2] = 1
                    catch
                    end
                end
                end
            end
        end
    end
    return antinodemap
end

antinodemap = antinode_map_2(antennamap,unique_nodes)
println(sum(antinodemap))
                