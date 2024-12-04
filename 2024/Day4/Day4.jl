


#lines = readlines("testinput.txt")
lines = readlines("input.txt")
count=0
for i in 1:length(lines)
    for j in 1:length(lines[i])
        global count
        if lines[i][j] == 'X'
            if (j<(length(lines[i])-2))
                if (lines[i][j+1] == 'M') && (lines[i][j+2] == 'A') && (lines[i][j+3]=='S') 
                    count+=1
                end
            end
            if (j>3)
                if (lines[i][j-1] == 'M') && (lines[i][j-2] == 'A') && (lines[i][j-3]=='S')
                    count+=1
                end
            end
            if (i<(length(lines)-2))
                if (lines[i+1][j] == 'M') && (lines[i+2][j] == 'A') && (lines[i+3][j]=='S')
                    count+=1
                end
            end
            if (i>3)
                if (lines[i-1][j] == 'M') && (lines[i-2][j] == 'A') && (lines[i-3][j]=='S')
                    count+=1
                end
            end
            if (i<(length(lines)-2)) &&(j<(length(lines[i])-2))
                if (lines[i+1][j+1] == 'M') && (lines[i+2][j+2] == 'A') && (lines[i+3][j+3]=='S') 
                    count+=1
                end
            end
            if (i<(length(lines)-2)) && (j>3)
                if (lines[i+1][j-1] == 'M') && (lines[i+2][j-2] == 'A') && (lines[i+3][j-3]=='S') 
                    count+=1
                end
            end
            if (i>3) &&(j<(length(lines[i])-2))
                if (lines[i-1][j+1] == 'M') && (lines[i-2][j+2] == 'A') && (lines[i-3][j+3]=='S') 
                    count+=1
                end
            end
            if (i>3) && (j>3)
                if (lines[i-1][j-1] == 'M') && (lines[i-2][j-2] == 'A') && (lines[i-3][j-3]=='S')
                    count+=1
                end
            end
        end
    end
end
           
println(count)



count2 = 0
for i in 1:length(lines)
    for j in 1:length(lines[i])
        global count2
        if lines[i][j] == 'A'
            if i>1 && j>1 && i<length(lines) && j<length(lines[i])
                diag1 = [lines[i-1][j-1], lines[i+1][j+1]]
                diag2 = [lines[i-1][j+1], lines[i+1][j-1]]
                if 'S' in diag1 && 'M' in diag1 && 'S' in diag2 && 'M' in diag2
                    count2+=1
                end
            end
        end
    end
end

println(count2)