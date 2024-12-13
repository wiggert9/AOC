using JuMP, GLPK
#data = read("testinput.txt", String)
data = read("input.txt", String)
machines = split(data , "\r\n")
push!(machines, "")

ButtonA = []
ButtonB = []
Prize = []
t=10000000000000
for j in 1:div(length(machines),4)
    i = (j-1)*4+1

    A = match(r"X\+(\d+), Y\+(\d+)", machines[i])
    Ax = parse(Int, A[1])
    Ay = parse(Int, A[2])
    push!(ButtonA, (Ax,Ay))

    B = match(r"X\+(\d+), Y\+(\d+)", machines[i+1])
    Bx = parse(Int, B[1])
    By = parse(Int, B[2])
    push!(ButtonB, (Bx,By))

    P = match(r"X\=(\d+), Y\=(\d+)", machines[i+2])
    Px = parse(Int, P[1])
    Py = parse(Int, P[2])
    push!(Prize, (Px+t,Py+t))
end


function sim_eq_solver(a,b,c,d,e,f)
    y=(c*d-f*a)/(b*d-e*a)
    x = c/a - b/a * y
    return x,y
end

summ=0
for i in 1:length(Prize)
    println(i)
    global summ
    x,y = sim_eq_solver(ButtonA[i][1], ButtonB[i][1], Prize[i][1], ButtonA[i][2], ButtonB[i][2], Prize[i][2])
    x= round(x, digits = 1)
    y= round(y, digits = 1)
    if isinteger(x) && isinteger(y)
        summ+= 3*x + y
    end
end

println(summ)