# THIS IS AMIEs EXPERIMENT 
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui#, parallel
from pyglet.gl import * #a graphic library
import math


#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)
fixationSize = 40
expName='Psymm Col Task'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'COLdata/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('COLdata'):
    os.makedirs('COLdata')#if this fails (e.g. permissions) we will get error  


myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color=(-1 -1 -1))
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

def responseCollect(colour,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('Dark          Light')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'Dark'
            if colour == 'Light':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'Light'
            if colour == 'Light':
                respCorr = 1
            else:
                respCorr = 0
    elif responseScreenVersion == 2:
        responseScreen.setText('Light          Dark')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Dark'
            if colour == 'Light':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'Light'
            if colour == 'Light':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice
    
def runBlock(trialbook,Reps):
    LightList100 = pictureShuffle(30,'100Light')  # this is a shuffled list of Reflection image names
    LightList80 = pictureShuffle(30,'80Light')
    LightList60 = pictureShuffle(30,'60Light')
    LightList40 = pictureShuffle(30,'40Light')
    LightList20 = pictureShuffle(30,'20Light')
    LightList0 = pictureShuffle(150,'0Light')
    
    DarkList100 = pictureShuffle(30,'100Dark')  # this is a shuffled list of Reflection image names
    DarkList80 = pictureShuffle(30,'80Dark')
    DarkList60 = pictureShuffle(30,'60Dark')
    DarkList40 = pictureShuffle(30,'40Dark')
    DarkList20 = pictureShuffle(30,'20Dark')
    DarkList0 = pictureShuffle(150,'0Dark')
    
    LightCounter100 = -1
    LightCounter80 = -1
    LightCounter60 = -1
    LightCounter40 = -1
    LightCounter20 = -1
    LightCounter0 = -1
    DarkCounter100 = -1
    DarkCounter80 = -1
    DarkCounter60 = -1
    DarkCounter40 = -1
    DarkCounter20 = -1
    DarkCounter0 = -1
    
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
        if Stim == 'Light100':
            LightCounter100 = LightCounter100+1
            i =  LightList100[LightCounter100]
        elif Stim == 'Light80':
            LightCounter80 = LightCounter80+1
            i =  LightList80[LightCounter80]
        elif Stim == 'Light60':
            LightCounter60 = LightCounter60+1
            i =  LightList60[LightCounter60]
        elif Stim == 'Light40':
            LightCounter40 = LightCounter40+1
            i =  LightList40[LightCounter40]
        elif Stim == 'Light20':
            LightCounter20 = LightCounter20+1
            i =  LightList20[LightCounter20]
        elif Stim == 'Light0':
            LightCounter0 = LightCounter0+1
            i =  LightList0[LightCounter0]
        
        
        elif Stim == 'Dark100':
           DarkCounter100 = DarkCounter100+1
           i =  DarkList100[DarkCounter100]
        elif Stim == 'Dark80':
            DarkCounter80 = DarkCounter80+1
            i =  DarkList80[DarkCounter80]
        elif Stim == 'Dark60':
            DarkCounter60 = DarkCounter60+1
            i =  DarkList60[DarkCounter60]
        elif Stim == 'Dark40':
            DarkCounter40 = DarkCounter40+1
            i =  DarkList40[DarkCounter40]
        elif Stim == 'Dark20':
            DarkCounter20 = DarkCounter20+1
            i =  DarkList20[DarkCounter20]
        elif Stim == 'Dark0':
            DarkCounter0 = DarkCounter0+1
            i =  DarkList0[DarkCounter0]
        
        
        s.setImage(i)
        s.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
        w = myClock.getTime() + duration
        #parallel.setData(triggers[reps])
        myWin.flip()   # THIS IS THE CRITICAL WIN FLIP
        #parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        
        
        respCorr, choice = responseCollect(colour, responseScreenVersion)
        
#        # Dry run
#        respCorr = 0
#        choice = 0
#       
        trials.addData('image',i)
#        
        trials.addData('LightCounter100',LightCounter100)
        trials.addData('LightCounter80',LightCounter80)
        trials.addData('LightCounter60',LightCounter60)
        trials.addData('LightCounter40',LightCounter40)
        trials.addData('LightCounter20',LightCounter20)
        trials.addData('LightCounter0',LightCounter0)
        trials.addData('DarkCounter100',DarkCounter100)
        trials.addData('DarkCounter80', DarkCounter80)
        trials.addData('DarkCounter60', DarkCounter60)
        trials.addData('DarkCounter40', DarkCounter40)
        trials.addData('DarkCounter20', DarkCounter20)
        trials.addData('DarkCounter0', DarkCounter0)
        
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('COLtrialbook.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('COLtrialbook.xlsx',30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()
