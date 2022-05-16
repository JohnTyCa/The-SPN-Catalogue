from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui #, parallel
from pyglet.gl import * #a graphic library
import math

fixationSize = 20
myWin = visual.Window(size = [300,300], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color='grey')
#baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin, mask=None, units='pix', size =[300,300], pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')


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
    fixation1.draw()
    fixation2.draw()
    myWin.flip()
    myWin.getMovieFrame()
    core.wait(baselineDuration)
    images = [image1,image2,image3]
    triggers = [T1,T2,T3]
    t = myClock.getTime()
    for reps in range (3):
        w = myClock.getTime() + ISI
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
        

        myWin.flip()
        myWin.getMovieFrame()
#        ser.write(chr(triggers[reps]))
#        core.wait(0.01)
#        ser.write(chr(0))
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    trialDuration = myClock.getTime()-t
    return trialDuration

#repeaterTrial(1,2,3,'image01.png','image02.png','image03.png')
#core.quit()


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
    
    glassList = pictureShuffle(480,'Glass')  # this is a shuffled list of Reflection image names
    refList = pictureShuffle(480,'Ref')  # this is a shuffled list of Reflection image names
    randList = pictureShuffle(840,'Rand') # this is a shuffled list of Random image names.
    
    blockDuration = 36
    nBlocksToGo = Reps
    
    trialCounter = 0
    glassCounter = -1
    refCounter = -1
    randCounter = -1
   
    trials=data.TrialHandler(nReps=Reps, method='sequential', trialList=data.importConditions(trialbook))
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
        
        if S1 == 'Oddball':
            image1 = 'Oddball.png'
        if S2 == 'Oddball':
            image2 = 'Oddball.png'
        if S3 == 'Oddball':
            image3 = 'Oddball.png'
        
        if S1 == 'Glass':
            glassCounter = glassCounter+1
            image1 =  glassList[glassCounter]
        if S2 == 'Glass':
            if identical < 1:
                glassCounter = glassCounter+1
            image2 =  glassList[glassCounter]
        if S3 == 'Glass':
            if identical < 1:
                glassCounter = glassCounter+1
            image3 =  glassList[glassCounter]
        
        if S1 == 'Reflection':
            refCounter = refCounter+1
            image1 = refList[refCounter]
        if S2 == 'Reflection':
            if identical < 1:
                refCounter = refCounter+1
            image2 = refList[refCounter]
        if S3 == 'Reflection':
            if identical < 1:
                refCounter = refCounter+1
            image3 = refList[refCounter]
        
        if S1 == 'Random':
            randCounter =   randCounter+1
            image1 =   randList[randCounter]
        if S2 == 'Random':
            if identical < 1:
                randCounter = randCounter+1
            image2 = randList[randCounter]
        if S3 == 'Random':
            if identical < 1:
                randCounter = randCounter+1
            image3 = randList[randCounter]
        

#        print refCounter
#        print randCounter
        trialDuration =repeaterTrial(T1,T2,T3,image1,image2,image3)
        #print trialDuration

runBlock('trialbook Glass and Ref.xlsx',1)
myWin.saveMovieFrames('Stim Illustrator/j.png')
core.wait(2)
myWin.close
core.quit()
