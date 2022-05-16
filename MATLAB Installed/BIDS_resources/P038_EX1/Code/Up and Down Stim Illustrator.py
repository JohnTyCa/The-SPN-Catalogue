from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual,core,data, event,  gui
from pyglet.gl import * #a graphic library
import math

fixationSize = 40
myWin = visual.Window(size = [300,600], allowGUI=False, monitor = 'EEGlab3d', units = 'pix', fullscr= False, color=(0.5, 0.5, 0.5))
baseline = visual.ImageStim(myWin, image='baseline.png',mask=None, units='pix', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin, mask=None, units='pix', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
myClock = core.Clock()
baselineDuration = 0.1
duration = 0.1
ISI = 0.1
offset = 126 # this gives an distance of 3.5 degrees of visual angle between screen center and pattern center


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
    baseline.setPos([0,-offset])
    baseline.draw()
    baseline.setPos([0,offset])
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
        baseline.setPos([0,-offset])
        baseline.draw()
        baseline.setPos([0,offset])
        baseline.draw()
        fixation1.draw()
        fixation2.draw()
        myWin.flip()
        
        i.setImage(leftImages[reps])
        i.setPos([0,-offset])
        i.draw()
        i.setImage(rightImages[reps])
        i.setPos([0,offset])
        i.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
        
        
        w = myClock.getTime() + duration

                
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    trialDuration = myClock.getTime()-t
    return trialDuration
    
def pictureShuffle(n,regType):
    iList = [] # It is essential to have 0 in this box to begin with
    for r in range(n):
        p = '%.0f' %(r+1)
        n= "%s%s%s" %(regType,p,'.png')
        iList.append(n)
    #print iList
    shuffle(iList)
    return iList 
    #print iList
#    
#randList=pictureShuffle(1200,'RAND')
#a = randList[1200]
#print a
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
   
    trials=data.TrialHandler(nReps=Reps, method='sequential', trialList=data.importConditions(trialbook))
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
        #print trialDuration
        trialDuration =repeaterTrial(T1,T2,T3,leftImage1,leftImage2,leftImage3,rightImage1,rightImage2,rightImage3)
        #print trialDuration
#
#runBlock('trialbook Left and Right.xlsx',1)
#myWin.saveMovieFrames('Stim Illustrator/j.png')
#core.wait(2)


baseline.setPos([0,-offset])
baseline.draw()
baseline.setPos([0,offset])
baseline.draw()
fixation1.draw()
fixation2.draw()
myWin.flip()
myWin.getMovieFrame()
myWin.saveMovieFrames('Stim Illustrator/baseline.png')
core.wait(2)
myWin.close
core.quit()