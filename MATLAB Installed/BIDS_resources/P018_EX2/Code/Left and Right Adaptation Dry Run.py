from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui#, parallel
from pyglet.gl import * #a graphic library
import math
import serial, time
#
#ser = serial.Serial('COM3', 115200, timeout=100)
#ser.write(chr(0))

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

expName='Left and Right'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

fixationSize = 40
imageSize = 200


myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color=(-1, -1, -1))
baseline = visual.ImageStim(myWin, size = imageSize, image='baseline.png',mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin, size = imageSize, mask=None, units='pix', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
myClock = core.Clock()
#baselineDuration = 1.5
#duration = 0.5
#ISI = 0.2
offset = 125 # this gives an distance of 3.5 degrees of visual angle between screen center and pattern center

# For dry run
baselineDuration = 0.1
duration = 0.1
ISI = 0.1

def message(Type, nBlocksToGo = 1):
    
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether there was a grey blank in the middle')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
    
def repeaterTrial(T1,T2,T3,leftImage1,leftImage2,leftImage3,rightImage1,rightImage2,rightImage3):
    baseline.setPos([-offset,0])
    baseline.draw()
    baseline.setPos([offset,0])
    baseline.draw()
    fixation1.draw()
    fixation2.draw()
       
    myWin.flip()
    core.wait(baselineDuration)
    leftImages = [leftImage1,leftImage2,leftImage3]
    rightImages= [rightImage1,rightImage2,rightImage3]
    triggers = [T1,T2,T3]
    t = myClock.getTime()
    for reps in range (3):
        w = myClock.getTime() + ISI
        baseline.setPos([-offset,0])
        baseline.draw()
        baseline.setPos([offset,0])
        baseline.draw()
        fixation1.draw()
        fixation2.draw()
        myWin.flip()
        
        i.setImage(leftImages[reps])
        i.setPos([-offset,0])
        i.draw()
        i.setImage(rightImages[reps])
        i.setPos([offset,0])
        i.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
        
        
        w = myClock.getTime() + duration
        #ser.write(chr(triggers[reps]))
        #parallel.setData(triggers[reps])
        myWin.flip()
        #ser.write(chr(0))
        #parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    trialDuration = myClock.getTime()-t
    print trialDuration
    return trialDuration

#repeaterTrial(1,2,3,'image01.png','image02.png','image03.png')
#core.quit()

def pictureShuffle(n,regType):
    iList = [] # It is essential to have 0 in this box to begin with
    for r in range(n):
        p = '%.0f' %(r+1)
        n= "%s%s%s" %(regType,p,'.png')
        iList.append(n)
    #print iList
    shuffle(iList)
    #print iList
    return iList 
    
#    
#a = pictureShuffle(20,'REF')
#b = a[19]
#print b
#core.quit()

def responseCollect(trialType,responseScreenVersion):
    event.clearEvents()
    if responseScreenVersion == 1:
        responseScreen.setText('All Patterns          Blank in Middle')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'Patterns'
            if trialType == 'RandOddballRand':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'Blank'
            if trialType == 'RandOddballRand':
                respCorr = 1
            else:
                respCorr = 0
    elif responseScreenVersion == 2:
        responseScreen.setText('Blank in Middle          All Patterns')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Patterns'
            if trialType == 'RandOddballRand':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'Blank'
            if trialType == 'RandOddballRand':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice
    
def runBlock(trialbook,Reps):
    
    VList = pictureShuffle(720,'Ref')  # this is a shuffled list of Reflection image names
    #HList = pictureShuffle(180,'Horizontal')  # this is a shuffled list of Reflection image names
    randList = pictureShuffle(1680,'Rand') # this is a shuffled list of Random image names.
    blockDuration = 14
    nBlocksToGo = Reps
    trialCounter = 0
    
    VCounter = -1
    HCounter = -1
    randCounter = -1
   
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
#        if trialCounter == blockDuration:
#                nBlocksToGo = nBlocksToGo - 1
#                message('Break',nBlocksToGo = nBlocksToGo)
#                event.waitKeys(keyList=['g'])
#                trialCounter = 0
#        trialCounter = trialCounter + 1
        
        if S1 == 'Oddball':
            leftImage1 = 'Oddball.png'
            rightImage1 = 'Oddball.png'
        if S2 == 'Oddball':
            leftImage2 = 'Oddball.png'
            rightImage2 = 'Oddball.png'
        if S3 == 'Oddball':
            leftImage3 = 'Oddball.png'
            rightImage3 = 'Oddball.png'
        
        if S1 == 'REFRAND':
            VCounter = VCounter+1
            leftImage1 =  VList[VCounter]
            randCounter = randCounter+1
            rightImage1 = randList[randCounter]
        if S2 == 'REFRAND':
            VCounter = VCounter+1
            leftImage2 =  VList[VCounter]
            randCounter = randCounter+1
            rightImage2 = randList[randCounter]
        if S3 == 'REFRAND':
            VCounter = VCounter+1
            leftImage3 =  VList[VCounter]
            randCounter = randCounter+1
            rightImage3 = randList[randCounter]


        if S1 == 'RANDREF':
            VCounter = VCounter+1
            rightImage1 =  VList[VCounter]
            randCounter = randCounter+1
            leftImage1 = randList[randCounter]
        if S2 == 'RANDREF':
            VCounter = VCounter+1
            rightImage2 =  VList[VCounter]
            randCounter = randCounter+1
            leftImage2 = randList[randCounter]
        if S3 == 'RANDREF':
            VCounter = VCounter+1
            rightImage3 =  VList[VCounter]
            randCounter = randCounter+1
            leftImage3 = randList[randCounter]



        if S1 == 'RANDRAND':
            randCounter = randCounter+1
            leftImage1 =  randList[randCounter]
            randCounter = randCounter+1
            rightImage1 = randList[randCounter]
        if S2 == 'RANDRAND':
            randCounter = randCounter+1
            leftImage2 =  randList[randCounter]
            randCounter = randCounter+1
            rightImage2 = randList[randCounter]
        if S3 == 'RANDRAND':
            randCounter = randCounter+1
            leftImage3 =  randList[randCounter]
            randCounter = randCounter+1
            rightImage3 = randList[randCounter]



        trialDuration =repeaterTrial(T1,T2,T3,leftImage1,leftImage2,leftImage3,rightImage1,rightImage2,rightImage3)
        #print trialDuration
        #respCorr, choice = responseCollect(trialType, responseScreenVersion)
        
        #trials.addData('overallDuration',trialDuration)
        #trials.addData('VCounter',VCounter)
        #trials.addData('randCounter',randCounter)
        trials.addData('leftImage1',leftImage1)
        trials.addData('leftImage2',leftImage2)
        trials.addData('leftImage3',leftImage3)
        trials.addData('rightImage1',rightImage1)
        trials.addData('rightImage2',rightImage2)
        trials.addData('rightImage3',rightImage3)
#        trials.addData('respCorr',respCorr)
#        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

#message('HelloPractice')
#event.waitKeys(keyList = ['g'])
#runBlock('trialbook Left and Right.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook Left and Right.xlsx',30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()
