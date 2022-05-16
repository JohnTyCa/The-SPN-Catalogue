from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual,core, data, event,  gui, parallel
import math
parallel.setPortAddress(0x378)#address for parallel port on many machines
parallel.setData(0)

size=20
sizedot =5
n =20
stimDuration = 1.5 
displacement = 180
quadrantSize=120
screenWidth = 600
screenHeight = 600
baselineMin = 1.5
baselineMax = 2.0
darkR =1.0
lightR = 0.2

expName='Double sided'#from the Builder filename that created this script
expInfo={'participant':'','order':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s_order%s' %(expInfo['participant'], expInfo['date'],expInfo['order'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  


myWin = visual.Window(allowGUI=False, size=[screenWidth,screenHeight],units='pix', fullscr= True, color = 'black')
fixation=visual.TextStim(myWin, text='+', height=30, color='white')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
dot = visual.Circle(myWin, radius=sizedot, fillColor='white', lineColor=None, edges=12)

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether they are light or dark')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation cross')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(Colour,responseScreenVersion):
    global respCorr
    if responseScreenVersion == 1:
        responseScreen.setText('Pink           Red')
        if Colour == 'dark':
            correctAnswer = 'l'
        elif Colour == 'light':
            correctAnswer = 'a'
    elif responseScreenVersion == 2:
        responseScreen.setText('Red            Pink')
        if Colour == 'dark':
            correctAnswer = 'a'
        elif Colour == 'light':
            correctAnswer = 'l'
    responseScreen.draw()
    myWin.flip()

    event.clearEvents()
    responseKey = event.waitKeys(keyList=['a', 'l']) 
#    print responseKey[0]
#    print correctAnswer
    respCorr =(correctAnswer==responseKey[0])
#    print respCorr
    if event.getKeys(["escape"]): 
        core.quit()
        event.clearEvents()
        myWin.close
    
    
def drawItem(x,y, d,Colour):
    if Colour == 'dark':
        dot.setFillColor([darkR,-1.,-1.],'rgb')
    elif Colour == 'light':
        dot.setFillColor([lightR,0.,0.],'rgb')
    dot.setPos([x+d,y])
    dot.draw()

def pattern_hv_new(d, Colour):
    
    memory =[]
    circle1 =visual.Circle(myWin, radius=quadrantSize, fillColor=(1.,1.,1.), lineColor=None, edges=24)

    for i in range(n):
        x =randint(quadrantSize)
        y =randint(quadrantSize)
        while (not circle1.contains((x,y))):
                x =randint(quadrantSize)
                y =randint(quadrantSize)
        drawItem(x, y, d,Colour)
        memory.append([x,y])
    
    i=0
    for i in range(n):
        x = memory[i][0]
        y = memory[i][1]
        drawItem(-x, y, d,Colour)

    i=0
    for i in range(n):
        x = memory[i][0]
        y = memory[i][1]
        drawItem(x, -y, d,Colour)
        
    i=0
    for i in range(n):
        x = memory[i][0]
        y = memory[i][1]
        drawItem(-x, -y, d,Colour)
        
def pattern_a_new(d, Colour):
    circle1 =visual.Circle(myWin, radius=quadrantSize, fillColor=(1.,1.,1.), lineColor=None, edges=24)
    for i in range(n):
        x =randint(quadrantSize)
        y =randint(quadrantSize)
        while (not circle1.contains((x,y))):
                x =randint(quadrantSize)
                y =randint(quadrantSize)
        drawItem(x, y, d,Colour)
    
    for i in range(n):
        x =-randint(quadrantSize)
        y =-randint(quadrantSize)
        while (not circle1.contains((x,y))):
                x =randint(quadrantSize)
                y =randint(quadrantSize)
        drawItem(x, y, d,Colour)

    for i in range(n):
        x =-randint(quadrantSize)
        y =randint(quadrantSize)
        while (not circle1.contains((x,y))):
                x =randint(quadrantSize)
                y =randint(quadrantSize)
        drawItem(x, y, d,Colour)
    
    for i in range(n):
        x =randint(quadrantSize)
        y =-randint(quadrantSize)
        while (not circle1.contains((x,y))):
                x =randint(quadrantSize)
                y =randint(quadrantSize)
        drawItem(x, y, d,Colour)
        
def pattern_hv(d, Colour):
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)
#
#    glColor3f(1.,1.,1.)
#    glRecti(-(size*5),-(size*5),(size*5),(size*5))
    
    i=0
    
    if Colour == 'dark':
        dot.setFillColor([darkR,0.,0.],'rgb')
    elif Colour == 'light':
        dot.setFillColor([lightR,0.,0.],'rgb')
        
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
    #        if randint(1, 3)==1:
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, d)
            i=i+1
                    
    i=0
#    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, d)
            i=i+1
            
    memory.reverse()
    i=0
    #glColor3f(0.,0.,0)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, d)
            i=i+1
    
    i=0
    #glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, d)
            i=i+1

def pattern_a(d, Colour):
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    memory =(a*(100-ndots*4)+(b*ndots*4))
    shuffle(memory)
    
    i=0
    if Colour == 'dark':
        dot.setFillColor([darkR,0.,0.],'rgb')
    elif Colour == 'light':
        dot.setFillColor([lightR,0.,0.],'rgb')
        
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, d)
            i=i+1
                    
#    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, d)
            i=i+1
            
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, d)
            i=i+1
    
#    glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, d)
            i=i+1

def runBlock(trialbook,Reps):
    trialCounter = 0
    blockDuration = 24
    nBlocksToGo = 6
    myClock = core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0

        trialCounter = trialCounter + 1
        fixation.draw()
        

            
        myWin.flip()
        ITI = uniform(baselineMin,baselineMax)
        core.wait(ITI)

        fixation.draw()
        
        if event.getKeys(["escape"]):
            core.quit()    # to close  and exit
            event.clearEvents()
            myWin.close
            
        if RightPattern == 'Random':
            pattern_a_new(displacement, Colour)
        elif RightPattern == 'Reflection':
            pattern_hv_new(displacement, Colour)

        if LeftPattern == 'Random':
            pattern_a_new(-displacement, Colour)
        elif LeftPattern == 'Reflection':
            pattern_hv_new(-displacement, Colour)
        
        parallel.setData(Trigger)
        myWin.flip()
        parallel.setData(0)
        core.wait(stimDuration)
        myWin.flip()
        
        responseCollect(Colour,responseScreenVersion)
        trials.addData('respCorr', respCorr)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(['g'])
runBlock('trialbook.xlsx',2)
message('HelloMain')
event.waitKeys(['g'])
runBlock('trialbook.xlsx',18)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()