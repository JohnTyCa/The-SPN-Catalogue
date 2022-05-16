from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, visual, data, event,  gui #,parallel #these are the psychopy libraries
from pyglet.gl import * #a graphic library
import math
#parallel.setPortAddress(0x378)#address for parallel port on many machines
expName='W rep and ref'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

maxIncrement = 50
minIncrement = 10

duration = 1.5 # how long do we want the trials to last?
baselineDuration = 1.5
xDim = 20 # number of cells on the grid
yDim = 22 #  number of y cells on the grid

elementSize = 10# size of each dot
slide = 6 # we don't want the pairs of glass patterned dots to overlap

color1 = 'black'
color2 = 'white'

myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= True, color='grey')
fixation = visual.TextStim(myWin, ori=0,text = '+', pos=[0, 1], height=30, color='red', units= 'pix')
centerLineV = visual.Line(myWin, start=(0, -500), end=(0, 500))
centerLineH = visual.Line(myWin, start=(-1000, 0), end=(1000,0))
#e =  visual.GratingStim(myWin, tex='sin', mask='gauss', size = [elementSize,elementSize], units = 'pix')
e = visual.Circle(myWin,interpolate=True,radius = elementSize/2,lineColor = 'grey')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', units= 'pix')

def scaling(control, minIncrement,maxIncrement,nPerHalf): # This scales the size of the cells, the number of cells never changes (i.e. 400)
    if control == 'sizeFixed':
        increment = sqrt(minIncrement*maxIncrement) 
    elif control == 'densityFixed':
        increment = sqrt(minIncrement*nPerHalf) # This is the key formula. It means cell size is linked to the number of dots
    xIncrement = increment # size of each cell
    yIncrement = increment # size of each cell
    return xIncrement,yIncrement
    

def Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf): # Lets build the right hand side
    nPlaces = xDim/2*yDim
    a = zeros([nPlaces-nPerHalf,1])
    b = ones([nPerHalf,1])
    c = append(a,b)
    shuffle(c)
    template = zeros([nPlaces,4])
    p = 0
    cCount = 0
    #xPos = (xIncrement/2)+xIncrement
    xPos = xIncrement# There are to be no dots on the midline
    for x in range (xDim/2):
        yPos = -((yDim/2)*yIncrement)+(yIncrement/2)
        for y in range (yDim):
            template [p,0] = xPos
            template [p,1] = yPos
            template[p,2] = c[p]
            if c[p] == 1: # This gambit fixes it so every other dot is white
                if (cCount% 2 == 0):
                    template[p,3] = 1
                cCount = cCount+1
            p = p+1
            yPos = yPos+yIncrement
        xPos = xPos + xIncrement
    #print template
    return template
    

def patternDraw(type,xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf):
    if type == 'translation':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        translate = ((xDim/2)*xIncrement)+xIncrement
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                xPos = xPos-translate
                e.setPos([xPos,yPos])
                e.draw()
    elif type == 'reflection':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                e.setPos([-xPos,yPos])
                e.draw()
    elif type == 'random':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        translate = ((xDim/2)*xIncrement)+xIncrement
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]-translate
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
    elif type == 'glass':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf/2)
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                xPos = xPos-slide # dot Number 1 of the glass pattern
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                xPos = xPos+(slide*2.0)# dot Number 2 of the glass pattern
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf/2)
        translate = ((xDim/2)*xIncrement)+xIncrement
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]-translate
                xPos = xPos-slide
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                xPos = xPos+(slide*2.0)# dot Number 2 of the glass pattern
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
#    centerLineV.draw()
#    centerLineH.draw()


#xIncrement,yIncrement = scaling('sizeFixed', minIncrement,maxIncrement,30)
#fixation.draw()
#patternDraw('random',xDim, yDim, xIncrement, yIncrement, elementSize,30)
#
#myWin.flip()
#event.waitKeys('a')
#myWin.flip()
#myWin.close()
def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether they are reflection or random')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(Reg,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Regular      Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if Reg== 0:
                respCorr = 0
            elif Reg== 1:
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'rand'
            if Reg== 0:
                respCorr = 1
            elif Reg == 1:
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random       Regular')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if Reg == 0:
                respCorr = 0
            elif Reg == 1:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'rand'
            if Reg== 0:
                respCorr = 1
            elif Reg == 1:
                respCorr = 0
    return respCorr, choice
    
def runBlock(trialbook,Reps):
    #parallel.setData(0)
    trialCounter = 0
    blockDuration = 24
    nBlocksToGo = Reps
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
        
        
        w = myClock.getTime() + baselineDuration
        xIncrement,yIncrement = scaling(control, minIncrement,maxIncrement,nPerHalf)
        fixation.draw()
        patternDraw(Type,xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
                
        #parallel.setData(trigger)
        myWin.flip()
        
        #parallel.setData(0)
        w = myClock.getTime() + duration
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        respCorr, choice = responseCollect(Reg, ResponseScreenVersion)
        trials.addData('choice', choice)
        trials.addData('respCorr', respCorr)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()