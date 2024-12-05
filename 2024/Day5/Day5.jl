rules = readlines("testrules.txt")
updates = readlines("testupdate.txt")

rules = readlines("rules.txt")
updates = readlines("update.txt")


rules_arr = [split(arr, "|") for arr in rules]
vec1 =  parse.(Int,getindex.(rules_arr,1))
vec2 =  parse.(Int,getindex.(rules_arr,2))
rules = hcat(vec1,vec2)

updates_arr = [split(arr, ",") for arr in updates]
updates_int_arr = [parse.(Int,vec) for vec in updates_arr]
updates = updates_int_arr

summ=0
wrong_updates = []
for arr in updates
    global summ
    global has_common
    global compare_pages
    global args
    check = true
    for i in 1:length(arr)
        pagenum = arr[i]
        args = findall(x->x==pagenum,rules[:,2])
        compare_pages = rules[args,1]
        leftoverpages = arr[i+1:end]
        has_common = any(x->x in compare_pages, leftoverpages)
        if has_common
            check=false
            push!(wrong_updates,arr) 
            break
        end
    end
    if check == true
        summ+= arr[Int((length(arr)+1)/2)]
    end
end

println(summ)
println("START")
summ2 = 0
corrected_updates = []
for j in 1:length(wrong_updates)
    global summ2
    global has_common
    global compare_pages
    global args
    arr = wrong_updates[j]
    check =false
    println("Old: $arr")
    while check == false
        has_common = false
        for i in 1:length(arr)
            pagenum = arr[i]
            args = findall(x->x==pagenum,rules[:,2])
            compare_pages = rules[args,1]
            leftoverpages = arr[i+1:end]
            has_common = any(x->x in compare_pages, leftoverpages)
            if has_common
                for k in length(arr):-1:i
                    if arr[k] in compare_pages
                        deleteat!(arr, i)
                        insert!(arr, k, pagenum)
                        break
                    end
                end
                break
            end
        end
        if has_common == false
            check = true
            push!(corrected_updates,arr)
            summ2 += arr[Int((length(arr)+1)/2)]
            println("Done!: $arr")
        end
    end
end

function final_check(arr)
    for i in 1:length(arr)
        pagenum = arr[i]
        args = findall(x->x==pagenum,rules[:,2])
        compare_pages = rules[args,1]
        leftoverpages = arr[i+1:end]
        has_common = any(x->x in compare_pages, leftoverpages)
    end
    return has_common
end
println(summ2)
