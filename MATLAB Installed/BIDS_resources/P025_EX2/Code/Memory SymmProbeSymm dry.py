# this is Yiovi's memory SPN experiment
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui#, parallel
from pyglet.gl import * #a graphic library
import math
import visualExtra

#import serial, time
#ser = serial.Serial('COM3', 115200, timeout=100)
#ser.write(chr(0).encode())

expName='Memory and Symmetry'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'MemoryData/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('MemoryData'):
    os.makedirs('MemoryData')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'testMonitor', units = 'deg', fullscr= True, color=(-1, -1, -1))
myClock = core.Clock()
fixationSize = 0.5

pPreserved = 0.875

np = int(pPreserved*100)


axes = 4
ndots = 64
dotSize = 17
orientation = 0
radius = 63 # 1.75 raidus =  3.5 diameter degrees wide
minimumDist = 5.3
gap = 3
memTaskCol = 'darkGreen'

# duration parameters
firstBaselineDuration = 0.1 # blank grey disk
standardDuration = 0.1 # standard shapes
secondBaselineDuration = 0.1 # grey before symm/rand
patternDuration = 0.1 # pattern
testDuration = 0.1


fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=0.5, color='white', colorSpace='rgb')



sample = visual.ImageStim(myWin, mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128)
test = visual.ImageStim(myWin,  mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128)


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

border =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')
border2 =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')


def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of shapes. Your task is to decide whether the shapes are the same in the first and second presentation. Please fixate on the red cross')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, it is the same, but much longer. Try not to blink and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(change,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('Green Same          Green Different')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'same'
            if change == 1:
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'change'
            if change == 1:
                respCorr = 1
            else:
                respCorr = 0
    elif responseScreenVersion == 2:
        responseScreen.setText('Green Different          Green Same')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'same'
            if change == 1:
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'change'
            if change == 1:
                respCorr = 1
            else:
                respCorr = 0
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
    blockDuration = 8
    nBlocksToGo = Reps
    trialCounter = 0
    



def runBlock(trialbook,Reps):
    blockDuration = 8
    nBlocksToGo = Reps
    trialCounter = 0
    
    symmList = [] # It is essential to have 0 in this box to begin with
    for r in range(120):
        p = '%.0f' %(r)
        n= "%s" %(p)
        symmList.append(n)
    #print iList
    shuffle(symmList)
    c = 0
    
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting
        
        
        
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
            
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, 0, radius)
        border.draw()
        fixation1.draw()
        fixation2.draw()
        w = myClock.getTime() + firstBaselineDuration
        myWin.flip() # flip on first baseline 
        
        
        if change == 1:
            i = symmList[c]
            sn= "%s%s%s%s%s" %(np,border2Color,'Sample',i,'.png')
            test.setImage(sn)
            test.draw()
        elif change == 0:
            i = symmList[c]
            sn= "%s%s%s%s%s" %(100,border2Color,'Sample',i,'.png')
            test.setImage(sn)
            test.draw()
        
        while myClock.getTime() < w:
            pass # background square border on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        fixation1.draw()
        fixation2.draw()
        w = myClock.getTime() + standardDuration
        myWin.flip()  # flip on the standard symm
        

        
        border.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # standard colored squares on
            if event.getKeys(["escape"]): 

                event.clearEvents()
                myWin.close()
                core.quit()
                
        myWin.flip() # flip on the second baseline (white circle)
        
        w = myClock.getTime() + secondBaselineDuration
        border.draw()
        drawingShape(stimulus, orientation,'black',0,0)   
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # second baseline on (white circle)
            if event.getKeys(["escape"]): 
                event.clearEvents()
                myWin.close
                core.quit()
        w = myClock.getTime() + patternDuration
        myWin.flip() # flip on the actual pattern
        
        if change == 1:
            i = symmList[c]
            
            tn= "%s%s%s%s%s" %(np,border2Color,'Test',i,'.png')
            test.setImage(tn)
            test.draw()
        elif change == 0:
            i = symmList[c]
            tn= "%s%s%s%s%s" %(100,border2Color,'Test',i,'.png')
            test.setImage(tn)
            test.draw()
        
        
        
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # test colored squares on
            if event.getKeys(["escape"]): 
                event.clearEvents()
                myWin.close()
                core.quit()
        w = myClock.getTime() + testDuration
        myWin.flip() # flip on test c
        
        while myClock.getTime() < w:
            pass # test colored squares on
            if event.getKeys(["escape"]): 
                event.clearEvents()
                myWin.close()
                core.quit()
        # get the response
        # get the response
        #respCorr, choice = responseCollect(change, responseScreenVersion)
#        trials.addData('respCorr',respCorr)
#        trials.addData('choice',choice)

        print (i)
        c = c+1
        
        trials.addData('sampleImage',sn)
        trials.addData('testImage',tn)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbookMemory.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbookMemory.xlsx',15) #15x8 = 120 trials
message('Goodbye')
core.wait(2)
myWin.close()
core.quit()