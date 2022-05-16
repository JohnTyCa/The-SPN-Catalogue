from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui #, parallel
from pyglet.gl import * #a graphic library
import math

myWin = visual.Window(size = [600,600], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color=(0.5, 0.5, 0.5))
baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin,  mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')

myClock = core.Clock()
baselineDuration = 0.1
duration = 0.1
ISI = 0.1
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
    myWin.flip()
    core.wait(baselineDuration)
    images = [image1,image2,image3]
    triggers = [T1,T2,T3]
    t = myClock.getTime()
    for reps in range (3):
        w = myClock.getTime() + ISI
        baseline.draw()
        myWin.flip()
        i.setImage(images[reps])
        i.draw()
        while myClock.getTime() < w:
            pass
        
        
        
        w = myClock.getTime() + duration
        #parallel.setData(triggers[reps])
        myWin.flip()
        myWin.getMovieFrame()
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
    
    refBlackList = refWhiteList = pictureShuffle(120,'Reflection')  # this is a shuffled list of Reflection image names
    randBlackList = randWhiteList=pictureShuffle(180,'Random') # this is a shuffled list of Random image names.

    blockDuration = 36
    nBlocksToGo = Reps
    trialCounter = 0
    refCounter = -1
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
            image1 = 'Oddball.png'
        if S2 == 'Oddball':
            image2 = 'Oddball.png'
        if S3 == 'Oddball':
            image3 = 'Oddball.png'
        
        if S1 == 'RandomBlack' or S1 == 'RandomWhite':
            randCounter =   randCounter+1
        if S1 == 'ReflectionBlack' or S1 == 'ReflectionWhite':
            refCounter =   refCounter+1
            
        if S1 == 'RandomBlack':
            n = randBlackList[randCounter]
            n= "%s%s" %('Black',n)
            image1 = n
        if S2 == 'RandomBlack':
            if identical < 1:
                randCounter = randCounter+1
            n = randBlackList[randCounter]
            n= "%s%s" %('Black',n)
            image2 = n
        if S3 == 'RandomBlack':
            if identical < 1:
                randCounter = randCounter+1
            n = randBlackList[randCounter]
            n= "%s%s" %('Black',n)
            image3 = n

        if S1 == 'RandomWhite':
            n = randWhiteList[randCounter]
            n= "%s%s" %('White',n)
            image1 = n
        if S2 == 'RandomWhite':
            if identical < 1:
                randCounter = randCounter+1
            n = randWhiteList[randCounter]
            n= "%s%s" %('White',n)
            image2 = n
        if S3 == 'RandomWhite':
            if identical < 1:
                randCounter = randCounter+1
            n = randWhiteList[randCounter]
            n= "%s%s" %('White',n)
            image3 = n
            
        if S1 == 'ReflectionBlack':
            n = refBlackList[refCounter]
            n= "%s%s" %('Black',n)
            image1 = n
        if S2 == 'ReflectionBlack':
            if identical < 1:
                refCounter = refCounter+1
            n = refBlackList[refCounter]
            n= "%s%s" %('Black',n)
            image2 = n
        if S3 == 'ReflectionBlack':
            if identical < 1:
                refCounter = refCounter+1
            n = refBlackList[refCounter]
            n= "%s%s" %('Black',n)
            image3 = n


        if S1 == 'ReflectionWhite':
            n = refWhiteList[refCounter]
            n= "%s%s" %('White',n)
            image1 = n
        if S2 == 'ReflectionWhite':
            if identical < 1:
                refCounter = refCounter+1
            n = refWhiteList[refCounter]
            n= "%s%s" %('White',n)
            image2 = n
        if S3 == 'ReflectionWhite':
            if identical < 1:
                refCounter = refCounter+1
            n = refWhiteList[refCounter]
            n= "%s%s" %('White',n)
            image3 = n
        

#        print refCounter
#        print randCounter
        trialDuration =repeaterTrial(T1,T2,T3,image1,image2,image3)
        #print trialDuration

runBlock('trialbook Black to White Ident.xlsx',1)
myWin.saveMovieFrames('Stim Illustrator/j.png')
core.wait(2)
myWin.close
core.quit()
