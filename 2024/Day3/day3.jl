using CSV, StatsBase

#data = read("testinput.txt", String)
data = read("input.txt", String)
summ=0
doo = true
for i in 1:length(data)
    global summ
    global doo
    if doo
        if data[i] == 'm'
            if data[i+1] =='u'
                if data[i+2] == 'l'
                    if data[i+3] == '('
                        nextchar = data[i+4]
                        firstnum = ""
                        j=0
                        while isdigit(nextchar)
                            firstnum *=nextchar 
                            j+=1
                            nextchar = data[i+4+j]
                        end
                        if nextchar == ','
                            nextchar = data[i+4+j+1]
                            secondnum = ""
                            k=0
                            while isdigit(nextchar)
                                secondnum *=nextchar 
                                k+=1
                                nextchar = data[i+4+j+1+k]
                            end
                            if nextchar == ')'
                                summ+=parse(Int64,firstnum)*parse(Int64,secondnum)
                            end
                        end
                    end
                end
            end
        end
    end
    if data[i] == 'd'
        if data[i+1]=='o'
            if data[i+2] == '('
                if data[i+3]== ')'
                    doo =true
                end
            elseif data[i+2] == 'n'  
                if data[i+3] == '''
                    if data[i+4] == 't'
                        if data[i+5] == '('
                            if data[i+6] == ')'
                                doo = false
                            end
                        end
                    end
                end
            end
        end
    end      
end

println(summ)