# this is Yiovi's alcohol SPN experiment with black oddballs
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui, parallel
from pyglet.gl import * #a graphic library
import math
import visualExtra

parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)

expName='Alcohol'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'AlcoholData/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('AlcoholData'):
    os.makedirs('AlcoholData')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'deg', fullscr= True, color=(-1, -1, -1))
myClock = core.Clock()
fixationSize = 0.5

axes = 4
ndots = 64
dotSize = 17
orientation = 0
radius = 63 # 1.75 raidus =  3.5 diameter degrees wide
minimumDist = 5.3
gap = 3

# duration parameters
firstBaselineDuration = 1.5 # blank grey disk
patternDuration = 1.5 # pattern



fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=0.5, color='white', colorSpace='rgb')


border =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')


line1 =visual.Line(myWin, start=[-340,0], end=[340,0], lineWidth=1, lineColor='black')
myTexture = zeros([4,4])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
myTexture = zeros([4,4])+1

gaborWhite = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
gaborRed = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(.8,-1,-1), units='pix', size=[dotSize,dotSize])
gaborPink = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(0.4,-0.6,-0.6), units='pix', size=[dotSize,dotSize])
gaborLightGreen= visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,0.5,-1), units='pix', size=[dotSize,dotSize])
gaborDarkGreen = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-0.2,-1), units='pix', size=[dotSize,dotSize])
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-1,-1), units='pix', size=[dotSize,dotSize])

circularRegion =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')




def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. Your task is to decide whether the dots are black or green. Please fixate on the red cross')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, it is the same, but much longer. Try not to blink and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
    
def responseCollect(colour,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('Black          Green')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'Black'
            if colour == 'black':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'Green'
            if colour == 'darkGreen':
                respCorr = 1

    elif responseScreenVersion == 2:
        responseScreen.setText('Green          Black')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Black'
            if colour == 'black':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'Green'
            if colour == 'darkGreen':
                respCorr = 1
    return respCorr, choice

    

def generateOriPhases(n=10, symmetry='r'):
    orientations =[]
    phases =[]
    for i in range(n):
            orientations.append(random.randint(0,180))
            phases.append(0.25)
    return orientations, phases


# draw the stimuli
def drawingShape(stimulus, orientation, colour, cx, cy):

    v1 = [visualExtra.polar2cartesian(i[0],i[1]) for i in stimulus]    # get cartesian coordinates
    v = [[x+cx,y+cy] for [x,y] in v1]
    if colour =='red':
        for i in v:
            gaborRed.setPos(i)
            gaborRed.draw()
    elif colour =='pink':
        for i in v:
            gaborPink.setPos(i)
            gaborPink.draw()
    elif colour == 'lightGreen':
            for i in v:
                gaborLightGreen.setPos(i)
                gaborLightGreen.draw()
    elif colour == 'darkGreen':
            for i in v:
                gaborDarkGreen.setPos(i)
                gaborDarkGreen.draw()
    elif colour == 'black':
            for i in v:
                gaborBlack.setPos(i)
                gaborBlack.draw()
                



def generateStimulus(symmetry, axes, n, minimumDist, gap, propNoise, radius):
    nyes =(n* (1.0-propNoise)) *1.0
    nno  =(n * propNoise) * 1.0
    if symmetry =='no' or propNoise==0:
        fullStim =visualExtra.generateSymmetry(symmetry=symmetry, axes=int(axes), ndots=n, radius=radius, minDist=minimumDist, gapAxis=gap)
        return fullStim
    elif symmetry =='r':
        target = visualExtra.generateSymmetry(symmetry=symmetry, axes=axes, ndots=nyes, radius=radius, minDist=minimumDist, gapAxis=gap)
        asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)
        #this loop is necessary to make sure target and noise elements do not overlap
        overlap =visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)
        t = myClock.getTime()
        while  overlap == True:
             asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)
             overlap = visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)
    return target + asy
    




def runBlock(trialbook,Reps):
    blockDuration = 24
    nBlocksToGo = Reps
    trialCounter = 0
    
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

        if patternType == 'random':
            symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
            propNoise = 1
        elif patternType == 'symmetry':
            symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random
            propNoise = 0
            
        border.draw()
        fixation1.draw()
        fixation2.draw()
        myWin.flip() # baseline on
        
        w = myClock.getTime() + firstBaselineDuration
        border.draw()
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, 0, radius)
        drawingShape(stimulus, orientation,Color,0,0)   # this is the first type of noise approach target+random
        fixation1.draw()
        fixation2.draw()
        
        while myClock.getTime() < w:
            pass # second baseline on (white circle)
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
                
        myWin.flip() # stim on
        w = myClock.getTime() + patternDuration
        
        parallel.setData(trigger)
        core.wait(0.01)
        parallel.setData(0)

   
        while myClock.getTime() < w:
            pass # pattern on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()

        respCorr, choice = responseCollect(Color, responseScreenVersion)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook2.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook2.xlsx',8) #24x8 = 192 trials
message('Goodbye')
core.wait(2)
myWin.close
core.quit()