import os
import termplotlib as tpl



os.system("gfortran main.f -fopenmp -o gfortran.out")

matrDimension = 590

calcTimes = []
speedup = []
efficiency = []
cost = []
xPlotArguments = [i for i in range(1,9)]


for threadsN in range(1,9):

    time2mean = []
    for i in range(100):
        outStr = os.popen(f"./gfortran.out {threadsN} {matrDimension}").read()
        calcTime = float(outStr.split()[-1])
        time2mean.append(calcTime)

    calcTimes.append(sum(time2mean)/100)



for i in range(len(calcTimes)):
    speedup.append(calcTimes[0]/calcTimes[i])
    efficiency.append(speedup[i]/(i+1))
    cost.append((i+1)*calcTimes[i])



fig = tpl.figure()
print("\n\n\n Time of calculations")
fig.plot(xPlotArguments, calcTimes)
fig.show()


fig = tpl.figure()
print("\n\n\n Speedup")
fig.plot(xPlotArguments, speedup)
fig.show()


fig = tpl.figure()
print("\n\n\n Efficiency")
fig.plot(xPlotArguments, efficiency)
fig.show()


fig = tpl.figure()
print("\n\n\n Cost")
fig.plot(xPlotArguments, cost)
fig.show()