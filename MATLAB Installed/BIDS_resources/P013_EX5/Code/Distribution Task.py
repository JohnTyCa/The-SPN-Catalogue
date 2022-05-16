# THIS IS AMIEs EXPERIMENT 
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui,sound#, parallel
from pyglet.gl import * #a graphic library
import math


#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)
fixationSize = 40
expName='Psymm Distribution Task'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  


myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color=(-1 -1 -1)) # change for new monitor
baseline = visual.ImageStim(myWin, image='baseline.png', mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
s = visual.ImageStim(myWin, mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'black')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'black')
myClock = core.Clock()

baselineDuration = 1.5
duration = 1.5
# Dry run Debug
#baselineDuration = 0.1
#duration = 0.1
s1 = sound.Sound(100,secs=duration,sampleRate=44100, bits=16)
s2 = sound.Sound(800,secs=duration,sampleRate=44100, bits=16)

def message(Type, nBlocksToGo = 1):
    
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns and hear beeps. Your task is to decide whether the the dots are uniformly spread, or attracted to the outside:')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
    



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

def responseCollect(Distribution,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('uniform          outside')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'uniform'
            if Distribution == 'uniform':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['l']:
            choice = 'outside'
            if Distribution == 'outside':
                respCorr = 1
            else:
                respCorr = 0
                
                
    elif responseScreenVersion == 2:
        responseScreen.setText('outside          uniform')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'outside'
            if Distribution == 'outside':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['l']:
            choice = 'uniform'
            if Distribution == 'uniform':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice
    
def runBlock(trialbook,Reps):
    LightUniformList100 = pictureShuffle(15,'100UniformLight')  # this is a shuffled list of Reflection image names
    LightUniformList80 = pictureShuffle(15,'80UniformLight')
    LightUniformList60 = pictureShuffle(15,'60UniformLight')
    LightUniformList40 = pictureShuffle(15,'40UniformLight')
    LightUniformList20 = pictureShuffle(15,'20UniformLight')
    LightUniformList0 = pictureShuffle(75,'0UniformLight')
    DarkUniformList100 = pictureShuffle(15,'100UniformDark')  # this is a shuffled list of Reflection image names
    DarkUniformList80 = pictureShuffle(15,'80UniformDark')
    DarkUniformList60 = pictureShuffle(15,'60UniformDark')
    DarkUniformList40 = pictureShuffle(15,'40UniformDark')
    DarkUniformList20 = pictureShuffle(15,'20UniformDark')
    DarkUniformList0 = pictureShuffle(75,'0UniformDark')
    
    LightOutsideList100 = pictureShuffle(15,'100OutsideLight')  # this is a shuffled list of Reflection image names
    LightOutsideList80 = pictureShuffle(15,'80OutsideLight')
    LightOutsideList60 = pictureShuffle(15,'60OutsideLight')
    LightOutsideList40 = pictureShuffle(15,'40OutsideLight')
    LightOutsideList20 = pictureShuffle(15,'20OutsideLight')
    LightOutsideList0 = pictureShuffle(75,'0OutsideLight')
    DarkOutsideList100 = pictureShuffle(15,'100OutsideDark')  # this is a shuffled list of Reflection image names
    DarkOutsideList80 = pictureShuffle(15,'80OutsideDark')
    DarkOutsideList60 = pictureShuffle(15,'60OutsideDark')
    DarkOutsideList40 = pictureShuffle(15,'40OutsideDark')
    DarkOutsideList20 = pictureShuffle(15,'20OutsideDark')
    DarkOutsideList0 = pictureShuffle(75,'0OutsideDark')
    
    
    
    
    LightUniformCounter100 = -1
    LightUniformCounter80 = -1
    LightUniformCounter60 = -1
    LightUniformCounter40 = -1
    LightUniformCounter20 = -1
    LightUniformCounter0 = -1
    DarkUniformCounter100 = -1
    DarkUniformCounter80 = -1
    DarkUniformCounter60 = -1
    DarkUniformCounter40 = -1
    DarkUniformCounter20 = -1
    DarkUniformCounter0 = -1
    
    
    LightOutsideCounter100 = -1
    LightOutsideCounter80 = -1
    LightOutsideCounter60 = -1
    LightOutsideCounter40 = -1
    LightOutsideCounter20 = -1
    LightOutsideCounter0 = -1
    DarkOutsideCounter100 = -1
    DarkOutsideCounter80 = -1
    DarkOutsideCounter60 = -1
    DarkOutsideCounter40 = -1
    DarkOutsideCounter20 = -1
    DarkOutsideCounter0 = -1
    
    # Debug Dry Run
    blockDuration = 20
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
       
        
        baseline.draw()
        fixation1.draw()
        fixation2.draw()
        w = myClock.getTime() + duration
        myWin.flip()

        i = 'crashit'
        if Stim == 'LightUniform100':
            LightUniformCounter100 = LightUniformCounter100+1
            i =  LightUniformList100[LightUniformCounter100]
        elif Stim == 'LightUniform80':
            LightUniformCounter80 = LightUniformCounter80+1
            i =  LightUniformList80[LightUniformCounter80]
        elif Stim == 'LightUniform60':
            LightUniformCounter60 = LightUniformCounter60+1
            i =  LightUniformList60[LightUniformCounter60]
        elif Stim == 'LightUniform40':
            LightUniformCounter40 = LightUniformCounter40+1
            i =  LightUniformList40[LightUniformCounter40]
        elif Stim == 'LightUniform20':
            LightUniformCounter20 = LightUniformCounter20+1
            i =  LightUniformList20[LightUniformCounter20]
        elif Stim == 'LightUniform0':
            LightUniformCounter0 = LightUniformCounter0+1
            i =  LightUniformList0[LightUniformCounter0]
        
        
        elif Stim == 'DarkUniform100':
           DarkUniformCounter100 = DarkUniformCounter100+1
           i =  DarkUniformList100[DarkUniformCounter100]
        elif Stim == 'DarkUniform80':
            DarkUniformCounter80 = DarkUniformCounter80+1
            i =  DarkUniformList80[DarkUniformCounter80]
        elif Stim == 'DarkUniform60':
            DarkUniformCounter60 = DarkUniformCounter60+1
            i =  DarkUniformList60[DarkUniformCounter60]
        elif Stim == 'DarkUniform40':
            DarkUniformCounter40 = DarkUniformCounter40+1
            i =  DarkUniformList40[DarkUniformCounter40]
        elif Stim == 'DarkUniform20':
            DarkUniformCounter20 = DarkUniformCounter20+1
            i =  DarkUniformList20[DarkUniformCounter20]
        elif Stim == 'DarkUniform0':
            DarkUniformCounter0 = DarkUniformCounter0+1
            i =  DarkUniformList0[DarkUniformCounter0]
        
        if Stim == 'LightOutside100':
            LightOutsideCounter100 = LightOutsideCounter100+1
            i =  LightOutsideList100[LightOutsideCounter100]
        elif Stim == 'LightOutside80':
            LightOutsideCounter80 = LightOutsideCounter80+1
            i =  LightOutsideList80[LightOutsideCounter80]
        elif Stim == 'LightOutside60':
            LightOutsideCounter60 = LightOutsideCounter60+1
            i =  LightOutsideList60[LightOutsideCounter60]
        elif Stim == 'LightOutside40':
            LightOutsideCounter40 = LightOutsideCounter40+1
            i =  LightOutsideList40[LightOutsideCounter40]
        elif Stim == 'LightOutside20':
            LightOutsideCounter20 = LightOutsideCounter20+1
            i =  LightOutsideList20[LightOutsideCounter20]
        elif Stim == 'LightOutside0':
            LightOutsideCounter0 = LightOutsideCounter0+1
            i =  LightOutsideList0[LightOutsideCounter0]
        
        
        elif Stim == 'DarkOutside100':
           DarkOutsideCounter100 = DarkOutsideCounter100+1
           i =  DarkOutsideList100[DarkOutsideCounter100]
        elif Stim == 'DarkOutside80':
            DarkOutsideCounter80 = DarkOutsideCounter80+1
            i =  DarkOutsideList80[DarkOutsideCounter80]
        elif Stim == 'DarkOutside60':
            DarkOutsideCounter60 = DarkOutsideCounter60+1
            i =  DarkOutsideList60[DarkOutsideCounter60]
        elif Stim == 'DarkOutside40':
            DarkOutsideCounter40 = DarkOutsideCounter40+1
            i =  DarkOutsideList40[DarkOutsideCounter40]
        elif Stim == 'DarkOutside20':
            DarkOutsideCounter20 = DarkOutsideCounter20+1
            i =  DarkOutsideList20[DarkOutsideCounter20]
        elif Stim == 'DarkOutside0':
            DarkOutsideCounter0 = DarkOutsideCounter0+1
            i =  DarkOutsideList0[DarkOutsideCounter0]
        
        s.setImage(i)
        s.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
 
        w = myClock.getTime() + duration
        myWin.flip() 
        #parallel.setData(trigger). # THIS IS Better after the win flip
        core.wait(0.01)
        #parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        
        
        respCorr, choice = responseCollect(Distribution, responseScreenVersion)
        
#        # Dry run
#        respCorr = 0
#        choice = 0
#       
        trials.addData('image',i)
#        
        trials.addData('LightUniformCounter100',LightUniformCounter100)
        trials.addData('LightUniformCounter80',LightUniformCounter80)
        trials.addData('LightUniformCounter60',LightUniformCounter60)
        trials.addData('LightUniformCounter40',LightUniformCounter40)
        trials.addData('LightUniformCounter20',LightUniformCounter20)
        trials.addData('LightUniformCounter0',LightUniformCounter0)
        trials.addData('DarkUniformCounter100',DarkUniformCounter100)
        trials.addData('DarkUniformCounter80', DarkUniformCounter80)
        trials.addData('DarkUniformCounter60', DarkUniformCounter60)
        trials.addData('DarkUniformCounter40', DarkUniformCounter40)
        trials.addData('DarkUniformCounter20', DarkUniformCounter20)
        trials.addData('DarkUniformCounter0', DarkUniformCounter0)
        
        trials.addData('LightOutsideCounter100',LightOutsideCounter100)
        trials.addData('LightOutsideCounter80',LightOutsideCounter80)
        trials.addData('LightOutsideCounter60',LightOutsideCounter60)
        trials.addData('LightOutsideCounter40',LightOutsideCounter40)
        trials.addData('LightOutsideCounter20',LightOutsideCounter20)
        trials.addData('LightOutsideCounter0',LightOutsideCounter0)
        trials.addData('DarkOutsideCounter100',DarkOutsideCounter100)
        trials.addData('DarkOutsideCounter80', DarkOutsideCounter80)
        trials.addData('DarkOutsideCounter60', DarkOutsideCounter60)
        trials.addData('DarkOutsideCounter40', DarkOutsideCounter40)
        trials.addData('DarkOutsideCounter20', DarkOutsideCounter20)
        trials.addData('DarkOutsideCounter0', DarkOutsideCounter0)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
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
