import os
import termplotlib as tpl


# divN = 840000
divN = 1000000

divNFile = open("numOfdivisions.txt", "w")
divNFile.write(str(divN))
divNFile.close()

num2mean = 10

calculationTimes_p2p = list()
calculationTimes_col = list()
xPlotArguments = [i for i in range(1,9)]

# calculate point to point interaction time
for procNum in range(1,9):

    commandStr = \
        "{{ time mpirun -n {:d} integral_p2p.out".format(procNum) + \
        " < numOfdivisions.txt > outfile.txt  ; } 2>> outfile.txt"

    meanTime = 0

    for i in range(num2mean):
        os.system(commandStr)
        line = ""
        fileIn = open("outfile.txt")
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = line.split()
        meanTime += float(line[4])
        fileIn.close()
    meanTime/=num2mean

    calculationTimes_p2p.append(meanTime)


speedup_p2p = list()
efficiency_p2p = list()
cost_p2p = list()

print("==========================================================")
print("Point to point sending")

for i in range(len(calculationTimes_p2p)):
    speedup_p2p.append(calculationTimes_p2p[0]/calculationTimes_p2p[i])
    efficiency_p2p.append(speedup_p2p[i]/(i+1))
    cost_p2p.append((i+1)*calculationTimes_p2p[i])

    print("{:d} proc| Calculation time = {:.3E} s| speedup = {:.3E}|"\
          "efficiency = {:.3E}| cost = {:.3E}".format(i+1,
           calculationTimes_p2p[i], speedup_p2p[i], 
           efficiency_p2p[i], cost_p2p[i]))



# calculate collective interaction time
for procNum in range(1,9):

    commandStr = \
        "{{ time mpirun -n {:d} integral_col.out".format(procNum) + \
        " < numOfdivisions.txt > outfile.txt  ; } 2>> outfile.txt"

    meanTime = 0

    for i in range(num2mean):
        os.system(commandStr)
        line = ""
        fileIn = open("outfile.txt")
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = fileIn.readline()
        line = line.split()
        meanTime += float(line[4])
        fileIn.close()
    meanTime/=num2mean

    calculationTimes_col.append(meanTime)

speedup_col = list()
efficiency_col = list()
cost_col = list()

print("==========================================================")
print("Collective sending")

for i in range(len(calculationTimes_col)):
    speedup_col.append(calculationTimes_col[0]/calculationTimes_col[i])
    efficiency_col.append(speedup_col[i]/(i+1))
    cost_col.append((i+1)*calculationTimes_col[i])

    print("{:d} proc| Calculation time = {:.3E} s| speedup = {:.3E}|"\
          "efficiency = {:.3E}| cost = {:.3E}".format(i+1,
           calculationTimes_col[i], speedup_col[i], 
           efficiency_col[i], cost_col[i]))





fig = tpl.figure()
print("\n\n\n Time of calculations")
fig.plot(xPlotArguments, calculationTimes_p2p, 
        #  width=132, height = 43, 
         label="Point to point sending")
fig.plot(xPlotArguments, calculationTimes_col, 
        #  width=132, height = 43, 
         label="Collective sending")
fig.show()


fig = tpl.figure()
print("\n\n\n Speedup")
fig.plot(xPlotArguments, speedup_p2p, 
        #  width=132, height = 43, 
         label="Point to point sending")
fig.plot(xPlotArguments, speedup_col, 
        #  width=132, height = 43, 
         label="Collective sending")
fig.show()


fig = tpl.figure()
print("\n\n\n Efficiency")
fig.plot(xPlotArguments, efficiency_p2p, 
        #  width=132, height = 43, 
         label="Point to point sending")
fig.plot(xPlotArguments, efficiency_col, 
        #  width=132, height = 43, 
         label="Collective sending")
fig.show()


fig = tpl.figure()
print("\n\n\n Cost")
fig.plot(xPlotArguments, cost_p2p, 
        #  width=132, height = 43, 
         label="Point to point sending")
fig.plot(xPlotArguments, cost_col, 
        #  width=132, height = 43, 
         label="Collective sending")
fig.show()