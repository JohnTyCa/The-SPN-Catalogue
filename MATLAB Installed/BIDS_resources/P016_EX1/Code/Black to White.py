# THIS IS Black to White experiment 
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui, parallel
from pyglet.gl import * #a graphic library
import math


#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

expName='Black to White'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  



fixationSize = 40

baselineDuration = 1.5
duration = 0.5
ISI = 0.2

myWin = visual.Window(size = [850,850], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color= (-0.25, -0.25, -0.25))
myClock = core.Clock()
fixationSize = 30


imageSize = 15
i = visual.ImageStim(myWin, mask=None, units = 'deg',size = imageSize, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='deg', size = imageSize, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)

responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')


# For dry run
#baselineDuration = 0.1
#duration = 0.1
#ISI = 0.1

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
    
def repeaterTrial(T1,T2,T3,image1,image2,image3):
    baseline.draw()
    fixation1.draw()
    fixation2.draw()
    
    myWin.flip()
    core.wait(baselineDuration)
    images = [image1,image2,image3]
    triggers = [T1,T2,T3]
    t = myClock.getTime()
    for reps in range (3):
        w = myClock.getTime() + ISI
        baseline.draw()
        fixation1.draw()
        fixation2.draw()
        myWin.flip()
        i.setImage(images[reps])
        
        i.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
        
        
        w = myClock.getTime() + duration
       # parallel.setData(triggers[reps])

        myWin.flip()
    #    parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    trialDuration = myClock.getTime()-t
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
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('All Patterns          Blank in Middle')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
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
    
    
    refBlackList = pictureShuffle(360,'ReflectionBlack')  # this is a shuffled list of Reflection image names
    randBlackList = pictureShuffle(480,'RandomBlack') # this is a shuffled list of Random image names.
    refWhiteList = pictureShuffle(360,'ReflectionWhite')  # this is a shuffled list of Reflection image names
    randWhiteList = pictureShuffle(480,'RandomWhite') # this is a shuffled list of Random image names.

    blockDuration = 20
    nBlocksToGo = Reps
    trialCounter = 0
    

    refBlackCounter = -1
    randBlackCounter = -1
    refWhiteCounter = -1
    randWhiteCounter = -1
    
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
        print S1
        print S2
        print S3
        if S1 == 'Oddball':
            image1 = 'Oddball.png'
        if S2 == 'Oddball':
            image2 = 'Oddball.png'
        if S3 == 'Oddball':
            image3 = 'Oddball.png'

        if S1 == 'ReflectionBlack':
            refBlackCounter = refBlackCounter+1
            image1 = refBlackList[refBlackCounter]
        if S2 == 'ReflectionBlack':
            if identical < 1:
                refBlackCounter = refBlackCounter+1
            image2 = refBlackList[refBlackCounter]
        if S3 == 'ReflectionBlack':
            if identical < 1:
                refBlackCounter = refBlackCounter+1
            image3 = refBlackList[refBlackCounter]
        
        if S1 == 'RandomBlack':
            randBlackCounter =   randBlackCounter+1
            image1 =   randBlackList[randBlackCounter]
        if S2 == 'RandomBlack':
            if identical < 1:
                randBlackCounter = randBlackCounter+1
            image2 = randBlackList[randBlackCounter]
        if S3 == 'RandomBlack':
            if identical < 1:
                randBlackCounter = randBlackCounter+1
            image3 = randBlackList[randBlackCounter]





        if S1 == 'ReflectionWhite':
            refWhiteCounter = refWhiteCounter+1
            image1 = refWhiteList[refWhiteCounter]
        if S2 == 'ReflectionWhite':
            if identical < 1:
                refWhiteCounter = refWhiteCounter+1
            image2 = refWhiteList[refWhiteCounter]
        if S3 == 'ReflectionWhite':
            if identical < 1:
                refWhiteCounter = refWhiteCounter+1
            image3 = refWhiteList[refWhiteCounter]
        
        if S1 == 'RandomWhite':
            randWhiteCounter =   randWhiteCounter+1
            image1 =   randWhiteList[randWhiteCounter]
        if S2 == 'RandomWhite':
            if identical < 1:
                randWhiteCounter = randWhiteCounter+1
            image2 = randWhiteList[randWhiteCounter]
        if S3 == 'RandomWhite':
            if identical < 1:
                randWhiteCounter = randWhiteCounter+1
            image3 = randWhiteList[randWhiteCounter]


        trialDuration =repeaterTrial(T1,T2,T3,image1,image2,image3)
        #print trialDuration
        respCorr, choice = responseCollect(trialType, responseScreenVersion)
        
        trials.addData('overallDuration',trialDuration)
        trials.addData('refBlackCounter',refBlackCounter)
        trials.addData('refWhiteCounter',refWhiteCounter)
        trials.addData('randBlackCounter',randBlackCounter)
        trials.addData('randWhiteCounter',randWhiteCounter)
        trials.addData('image1',image1)
        trials.addData('image2',image2)
        trials.addData('image3',image3)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook Black to White.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook Black to White.xlsx',30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()
