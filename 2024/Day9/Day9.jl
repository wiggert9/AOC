#line =readlines("testinput.txt")[1]
line = readlines("input.txt")[1]

function make_diskmap(text)
    diskmap = []
    ID=0
    for i in 1:length(text)
        if iseven(i)
            for i in 1:parse(Int,(text[i]))
                push!(diskmap, '.')
            end
        else
            for i in 1:parse(Int,(text[i]))
                push!(diskmap,ID)
            end
            ID+=1
        end
    end
    return diskmap
end


function move_file_blocks(diskmap)
    newdiskmap = []
    dotcount = 0
    dotcountskip = 0
    N= length(diskmap)
    for i in 1:N
        if diskmap[i] == '.'
            while diskmap[N-dotcount-dotcountskip] == '.'
                dotcountskip+=1
            end
            push!(newdiskmap, diskmap[N-dotcount-dotcountskip])
            dotcount+=1
        else
            push!(newdiskmap,diskmap[i])
        end
    end
    return newdiskmap[1:N-dotcount]
end


function checksum(file)
    checksum = 0
    for i in 1:length(file)
        checksum += (i-1)*file[i]
    end
    return checksum
end

diskmap = make_diskmap(line)
file_blocked = move_file_blocks(diskmap)
answer = checksum(file_blocked)
#println(file_blocked)
println(answer)


function make_diskmap_2(text)
    diskmap = []
    IDcount = []
    ID=0
    for i in 1:length(text)
        val = parse(Int, text[i])
        if iseven(i)
            for i in 1:val
                str = '.'
                push!(diskmap, str)
            end
        else
            for i in 1:val
                push!(diskmap,ID)
            end
            push!(IDcount,val)
            ID+=1
        end
    end
    return diskmap, IDcount
end

function count_space(diskmap)
    space_arr = []
    start = 0
    count = 0
    for i in 1:length(diskmap)
        if diskmap[i] != '.' && count>0
            push!(space_arr, (start,count)) 
            count = 0
        elseif diskmap[i] == '.'
            if count==0
                start = i
            end
            count+=1
        end
    end
    return space_arr
end

function move_file_blocks_2(diskmap, IDcount, space_arr)
    new_diskmap = copy(diskmap)
    for i in length(IDcount):-1:1
        println(i)
        ID = i-1
        count = IDcount[i]
        for j in space_arr
            if j[2] >= count
                firstpos = findfirst(x->x==ID,new_diskmap)
                if firstpos>j[1]
                    new_diskmap = ifelse.(new_diskmap.==ID, '.', new_diskmap)
                    new_diskmap[j[1]:(j[1]+count-1)] .= ID
                    space_arr = count_space(new_diskmap)
                    break
                end
            end
        end
    end
    return new_diskmap
end

function checksum_2(file)
    summ =0
    for i in 1:length(file)
        if file[i] != '.'
            summ+=file[i]*(i-1)
        end
    end
    return summ
end

println("##################### NEW RUN ######################")
diskmap, IDcount = make_diskmap_2(line)
space_arr = count_space(diskmap)
file_blocked_2 = move_file_blocks_2(diskmap, IDcount, space_arr)
summ = checksum_2(file_blocked_2)