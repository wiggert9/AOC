using JuMP, GLPK
data = read("testinput.txt", String)
data = read("input.txt", String)
machines = split(data , "\r\n")
push!(machines, "")

ButtonA = []
ButtonB = []
Prize = []
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
    push!(Prize, (Px,Py))
end

m = Model(GLPK.Optimizer)

@variable(m, 0<=x1<=100, Int)
@variable(m, 0<=x2<=100, Int)

@objective(m, Min, 3*x1 + x2 )

summ=0
for i in 1:length(Prize)
    println(i)
    #println(ButtonA[i])
    #println(ButtonB[i])
    #println(Prize[i])
    global summ
    @constraint(m, constraint1, ButtonA[i][1]*x1 + ButtonB[i][1]*x2 <= Prize[i][1])
    @constraint(m, constraint2, ButtonA[i][2]*x1 + ButtonB[i][2]*x2 <= Prize[i][2])
    @constraint(m, constraint3, ButtonA[i][1]*x1 + ButtonB[i][1]*x2 >= Prize[i][1])
    @constraint(m, constraint4, ButtonA[i][2]*x1 + ButtonB[i][2]*x2 >= Prize[i][2])
    JuMP.optimize!(m)
    #print(m)

    #println("Optimal Solutions:")
    try
        println("x1 = ", JuMP.value(x1))
        println("x2 = ", JuMP.value(x2))
        println("")
        summ+= 3*JuMP.value(x1) + JuMP.value(x2)
    catch
    end
    delete(m, constraint1)
    delete(m, constraint2)
    delete(m, constraint3)
    delete(m, constraint4)
    unregister(m, :constraint1)
    unregister(m, :constraint2)
    unregister(m, :constraint3)
    unregister(m, :constraint4)
end

println(summ)