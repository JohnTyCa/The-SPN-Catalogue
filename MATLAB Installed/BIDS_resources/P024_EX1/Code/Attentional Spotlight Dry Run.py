
#This is Yiovi's new dot probe experiment


from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import core, data, event, visual, gui #these are the psychopy libraries
import math, scipy, random, os, copy
import visualExtra
import gazepoint

# Connect to Eyetracker#
gp3 = gazepoint.EyeTracker()
print gp3.isConnected()
gp3.setRecordingState(False)
print 'done'
gp3.sendMessage(0) #this resets message
#Connect BIOSEMI#
import serial, time
ser = serial.Serial('COM3', 115200, timeout=100)
ser.write(chr(0))

# global parameters
baselineDuration = 1.5
duration = 1.0
endBlankDuration = 0.3

axes = 4
ndots = 64
dotSize = 17
orientation = 0
radius = 63 # 1.75 raidus =  3.5 diameter degrees wide
minimumDist = 5.3
gap = 3

xOffset = 126 # This is 3.5 degrees from screen center. 
yOffset = 0
cueYoffset = 50

colour = 'black'

probeOnMin = 0.3
probeOnMax = 0.8
probeSize = dotSize*4


#  set the experiment
expName='Attentional Spotlight with Dot probe'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(size = [800,800], allowGUI=False, monitor = 'EEGlab3d', units = 'pix', fullscr= True, color=(-1 -1 -1), screen=1)
myClock = core.Clock()


#endBlank = visual.ImageStim(myWin, image='endBlank.png', mask=None, units='', pos=(0.0, 0.0), size = [radius+dotSize,radius+dotSize],ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
#baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='', pos=(0.0, 0.0), size = [radius+dotSize,radius+dotSize],ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)


responseScreen=visual.TextStim(myWin, ori=0, height=20, color='blue', colorSpace='rgb', units= 'pix',bold = 'true')
circularRegion =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[1, 1 ,1], lineColor=[1,1,1])

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


cue=visual.TextStim(myWin, ori=0, pos=[0, 0], height=40, color='white', colorSpace='rgb', units= 'pix')

attP = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-1,1), units='pix', size=[probeSize,probeSize], pos = [0,0])
#attP.setPos([-100,-300])
#attP.draw()
#screenshot = visual.BufferImageStim(myWin)
#myWin.flip()
#
#
#core.wait(2)
#myWin.flip()
#
#attP.setPos([-100,300])
#
#screenshot.draw()
#attP.draw()
#myWin.flip()
#core.wait(2)
#myWin.close()
#core.quit()

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
#    v2 = [visualExtra.rotateVertex(vertex=i, a=orientation) for i in v1]  
#    v = visualExtra.rotateVertices(vertices=v1, a=-orientation) # rotate the pattern
    
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
    print symmetry, axes, n, minimumDist, gap, propNoise, radius, nyes, nno
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
#             if (myClock.getTime() - t) >15:
#                return target
#    print 'sizes:', len(target), len(asy)
    return target + asy
    



def message(Type, nBlocksToGo = 1):
    
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether there is any regularity present')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()



def responseCollect(trialType,responseScreenVersion,cueDir):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    circularRegion.setPos([-xOffset,yOffset])
    circularRegion.draw()
    circularRegion.setPos([xOffset,yOffset])
    circularRegion.draw()
    cue.draw()
    
    if responseScreenVersion == 1:
        if cueDir == 'left':
            responseScreen.setPos([-xOffset,cueYoffset])
            responseScreen.setText('Symmetry')
            responseScreen.draw()
            responseScreen.setPos([-xOffset,-cueYoffset])
            responseScreen.setText('Random')
            responseScreen.draw()
        elif cueDir == 'right':
            responseScreen.setPos([xOffset,cueYoffset])
            responseScreen.setText('Symmetry')
            responseScreen.draw()
            responseScreen.setPos([xOffset,-cueYoffset])
            responseScreen.setText('Random')
            responseScreen.draw()
        
        
        myWin.flip()
        responseKey = event.waitKeys(keyList=['y','b']) 
        if responseKey == ['y']:
            choice = 'Symmetry'
            if trialType == 'Symmetry':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['b']:
            choice = 'Random'
            if trialType == 'Random':
                respCorr = 1
            else:
                respCorr = 0
    
    elif responseScreenVersion == 2:
        if cueDir == 'left':
            responseScreen.setPos([-xOffset,-cueYoffset])
            responseScreen.setText('Symmetry')
            responseScreen.draw()
            responseScreen.setPos([-xOffset,cueYoffset])
            responseScreen.setText('Random')
            responseScreen.draw()
        elif cueDir == 'right':
            responseScreen.setPos([xOffset,cueYoffset])
            responseScreen.setText('Symmetry')
            responseScreen.draw()
            responseScreen.setPos([xOffset,-cueYoffset])
            responseScreen.setText('Random')
            responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['y','b']) 
        if responseKey == ['b']:
            choice = 'Symmetry'
            if trialType == 'Symmetry':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['y']:
            choice = 'Random'
            if trialType == 'Random':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice



def pairDraw(leftImage,rightImage):
    if leftImage == 'Symmetry':
        symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 0
        circularRegion.setPos([-xOffset,yOffset])
        circularRegion.draw()
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
        drawingShape(stimulus, orientation, colour,-xOffset,yOffset)   # this is the first type of noise approach target+random



    if rightImage == 'Symmetry':
        symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 0
        circularRegion.setPos([xOffset,yOffset])
        circularRegion.draw()
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
        drawingShape(stimulus, orientation, colour,xOffset,yOffset)   # this is the first type of noise approach target+random


    if leftImage == 'Random':
        symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 1
        circularRegion.setPos([-xOffset,yOffset])
        circularRegion.draw()
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
        drawingShape(stimulus, orientation, colour,-xOffset,yOffset)   # this is the first type of noise approach target+random


    if rightImage == 'Random':
        symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 1
        circularRegion.setPos([xOffset,yOffset])
        circularRegion.draw()
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
        drawingShape(stimulus, orientation, colour,xOffset,yOffset)   # this is the first type of noise approach target+random
    
    cue.draw()


def runBlock(trialbook,Reps):
    blockDuration = 3000
    nBlocksToGo = Reps/2
    trialCounter = 0
    eyeTrig = 0
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
        
        if cueDir == 'left':
            cue.setText('<')
        elif cueDir == 'right':
            cue.setText('>')
        
        probeOnset = 0
        if probe == 1:
            probeOnset = uniform(probeOnMin,probeOnMax) # what timePoint do we want the little probe coming on?
        
        cue.draw()
        circularRegion.setPos([-xOffset,yOffset])
        circularRegion.draw()
        circularRegion.setPos([xOffset,yOffset])
        circularRegion.draw()
        
        # random mask in the baseline
#        symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
#        propNoise = 1
#        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
#        drawingShape(stimulus, orientation, colour,-xOffset,yOffset)   # this is the first type of noise approach target+random
#        drawingShape(stimulus, orientation, colour,xOffset,yOffset) 
        w = myClock.getTime()+baselineDuration
        myWin.flip()
 
        pairDraw(leftImage,rightImage)
        
        screenshot = visual.BufferImageStim(myWin) # clever way of getting screenshot without heavy redrawing operation using seeds etc. 
        
        while myClock.getTime() < w:
            if event.getKeys(["escape"]):
                gp3.setRecordingState(False)
                core.quit()
                event.clearEvents()
                myWin.close

        
        eyeTrig = eyeTrig+1
        gp3.sendMessage(eyeTrig)
        core.wait(0.1)
        gp3.sendMessage(trigger) #this tells to Gazepoint which condition it is
        
        
       
        
        
        w = myClock.getTime() + duration-probeOnset
        
        ser.write(chr(trigger))# this is the EEG trigger
        myWin.flip()   # THIS IS THE CRITICAL WIN FLIP        ser.write(chr(trigger))# this is the EEG trigger. Actually it is better to do trigger after win flip, but we want to be consistent with previous experiment
        ser.write(chr(0))
        

        while myClock.getTime() < w:
            if event.getKeys(["escape"]):
                gp3.setRecordingState(False)
                core.quit()
                event.clearEvents()
                myWin.close

        if probe == 1:
            
            if probePos =='left':
                attP.setPos([-xOffset,yOffset])
                
            elif probePos == 'right':
                attP.setPos([xOffset,yOffset])
            screenshot.draw()
            attP.draw()
            
            w = myClock.getTime() + duration
            
            myWin.flip(clearBuffer = True)
            ser.write(chr(trigger+100)) # this is the trigger for the probe onset. Its after the win flip. it would have been better to do it this way all along, but I don't want to break consistency with first expt
            core.wait(0.01)
            ser.write(chr(0))
            
        while myClock.getTime() < w: # wait until the end of the trial, after the probe has come on. . 
            if event.getKeys(["escape"]):
                gp3.setRecordingState(False)
                core.quit()
                event.clearEvents()
                myWin.close
        
        
        
        

        gp3.sendMessage(0) #this resets message

        w = myClock.getTime() + endBlankDuration
        
        myWin.flip()
        circularRegion.setPos([-xOffset,yOffset])
        circularRegion.draw()
        circularRegion.setPos([xOffset,yOffset])
        circularRegion.draw()
        cue.draw()
        while myClock.getTime() < w:
            pass
            
        #respCorr, choice = responseCollect(correctResponse, responseScreenVersion,cueDir)
        core.wait(2)
#        trials.addData('respCorr',respCorr)
#        trials.addData('choice',choice)
    
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1)
message('HelloMain')

event.waitKeys(keyList = ['g'])

gp3.sendMessage(0) #this resets the gazepiont tigger
gp3.setRecordingState(True)
runBlock('trialbook.xlsx',60)
gp3.setRecordingState(False)
gp3.close()
ser.close()


message('Goodbye')
core.wait(8)
myWin.close
core.quit()
