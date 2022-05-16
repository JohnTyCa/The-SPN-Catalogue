from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui#, parallel
from pyglet.gl import * #a graphic library
import math

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

expName='Ref and Ident'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

fixationSize = 40
myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color=(0.5, 0.5, 0.5))
baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin, mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
myClock = core.Clock()
baselineDuration = 1.5
duration = 0.5
ISI = 0.2
repOriBoundary = 10

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
    
def repeaterTrial(T1,T2,T3,image1,image2,image3,trialType):
    baseline.draw()
    myWin.flip()
    core.wait(baselineDuration)
    images = [image1,image2,image3]
    triggers = [T1,T2,T3]
    
    ori1 = randint(90)
    ori2 = ori1
    ori3 = ori1
    
    if trialType== 'Unpredictable' or trialType == 'RandRandRand':
        ori2 = randint(90)
        while ori2 > ori1-repOriBoundary and ori2 < ori1 +repOriBoundary:
            ori2 = randint(90)
        ori3 = randint(90)
        while ori3 > ori2-repOriBoundary and ori3 < ori2+repOriBoundary:
            ori3 = randint(90)
    oris =[ori1,ori2,ori3]
    print oris
    t = myClock.getTime()
    for reps in range (3):
        w = myClock.getTime() + ISI
        baseline.draw()
        myWin.flip()
        i.setImage(images[reps])
        i.setOri(oris[reps])
        i.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        w = myClock.getTime() + duration
        #parallel.setData(triggers[reps])
        myWin.flip()
        #parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    trialDuration = myClock.getTime()-t
    return trialDuration,ori1,ori2,ori3

#repeaterTrial(1,2,3,'Random1.png','Random2.png','Random3.png','unpredictable')
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
    
    VList = pictureShuffle(360,'Vertical')  # this is a shuffled list of Reflection image names
    randList = pictureShuffle(420,'Random') # this is a shuffled list of Random image names.
    blockDuration = 18
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
        
        if S1 == 'Vertical':
            VCounter = VCounter+1
            image1 =  VList[VCounter]
            
        if S2 == 'Vertical':
            if identical < 1:
                VCounter = VCounter+1
            image2 =  VList[VCounter]
        if S3 == 'Vertical':
            if identical < 1:
                VCounter = VCounter+1
            image3 =  VList[VCounter]
       
        
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



        trialDuration,ori1,ori2,ori3 =repeaterTrial(T1,T2,T3,image1,image2,image3,trialType)
        #print trialDuration
        respCorr, choice = responseCollect(trialType, responseScreenVersion)
        
        trials.addData('overallDuration',trialDuration)
        trials.addData('VCounter',VCounter)
        trials.addData('HCounter',HCounter)
        trials.addData('randCounter',randCounter)
        trials.addData('image1',image1)
        trials.addData('image2',image2)
        trials.addData('image3',image3)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
        trials.addData('ori1',ori1)
        trials.addData('ori2',ori2)
        trials.addData('ori3',ori3)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',15)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()
