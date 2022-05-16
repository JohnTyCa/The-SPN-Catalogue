# this is Haya and Jess and Adie experiment
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual,core,data, event,  gui, parallel
from pyglet.gl import * #a graphic library
import math
parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)


expName='Ref and Rot Ndeg'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  


imageSize = 15

myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'pix', fullscr= True, color=(0.5, 0.5, 0.5))
baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='deg', size = imageSize, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
#i = visual.ImageStim(myWin, mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
i = visual.ImageStim(myWin, mask=None, units = 'deg',size = imageSize, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)


responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=20, color='blue', colorSpace='rgb', units= 'pix')

myClock = core.Clock()
baselineDuration = 1.5
duration = 0.5
ISI = 0.2

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
        parallel.setData(triggers[reps])
        myWin.flip()
        parallel.setData(0)
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
    return iList 
    #print iList
#    
#randList=pictureShuffle(1200,'RAND')
#a = randList[1200]
#print a
#core.quit()
def responseCollect(trialType,responseScreenVersion):
    respCorr = 0
    event.clearEvents()
    if responseScreenVersion == 1:
        responseScreen.setText('All Patterns          Blank in Middle')
        responseScreen.draw()
        myWin.flip()
        respCorr = 0
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
    
    refList = pictureShuffle(360,'Ref1F')  # this is a shuffled list of Reflection image names
    rand1FList = pictureShuffle(420,'Rand1F') # this is a shuffled list of Random image names.
    rand4FList = pictureShuffle(420,'Rand4F') # this is a shuffled list of Random image names.
    rotList = pictureShuffle(360,'Rot') # this is a shuffled list of Random image names.
    
    blockDuration = 18
    nBlocksToGo = Reps
    
    trialCounter = 0
    refCounter = -1
    rotCounter = -1
    rand1FCounter = -1
    rand4FCounter = -1
   
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
        
        if S1 == 'Reflection':
            refCounter = refCounter+1
            image1 =  refList[refCounter]
        if S2 == 'Reflection':
            if identical < 1:
                refCounter = refCounter+1
            image2 =  refList[refCounter]
        if S3 == 'Reflection':
            if identical < 1:
                refCounter = refCounter+1
            image3 =  refList[refCounter]
        
        if S1 == 'Rotation':
            rotCounter = rotCounter+1
            image1 = rotList[rotCounter]
        if S2 == 'Rotation':
            if identical < 1:
                rotCounter = rotCounter+1
            image2 = rotList[rotCounter]
        if S3 == 'Rotation':
            if identical < 1:
                rotCounter = rotCounter+1
            image3 = rotList[rotCounter]
        
        if S1 == 'Random1F':
            rand1FCounter =   rand1FCounter+1
            image1 =   rand1FList[rand1FCounter]
        if S2 == 'Random1F':
            if identical < 1:
                rand1FCounter =   rand1FCounter+1
            image2 = rand1FList[rand1FCounter]
        if S3 == 'Random1F':
            if identical < 1:
                rand1FCounter =   rand1FCounter+1
            image3 = rand1FList[rand1FCounter]


        if S1 == 'Random4F':
            rand4FCounter =   rand4FCounter+1
            image1 =   rand4FList[rand4FCounter]
        if S2 == 'Random4F':
            if identical < 1:
                rand4FCounter =   rand4FCounter+1
            image2 = rand4FList[rand4FCounter]
        if S3 == 'Random4F':
            if identical < 1:
                rand4FCounter =   rand4FCounter+1
            image3 = rand4FList[rand4FCounter]


        trialDuration = repeaterTrial(T1,T2,T3,image1,image2,image3)
        #print trialDuration
        respCorr, choice = responseCollect(trialType, responseScreenVersion)
        
        trials.addData('overallDuration',trialDuration)
        trials.addData('refCounter',refCounter)
        trials.addData('rotCounter',rotCounter)
        trials.addData('rand1FCounter',rand1FCounter)
        trials.addData('rand4FCounter',rand4FCounter)
        trials.addData('image1',image1)
        trials.addData('image2',image2)
        trials.addData('image3',image3)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)


    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook ref and rot.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook ref and rot.xlsx',30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()