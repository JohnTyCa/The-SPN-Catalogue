
# THIS IS CHANELLE'S and LEAH EXPERIMENT!!!!!!!!



from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui, parallel
from pyglet.gl import * #a graphic library
import math

parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)

expName='SPN real things'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myClock = core.Clock()
baselineDuration = 1.5
Duration = 1.5
fixationSize = 40

myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'pix', fullscr= True, color='black')
i = visual.ImageStim(myWin, mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'blue')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'blue')



def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of images. Your task is to decide if they are symmetrical or asymmetrical')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()


def responseCollect(trialType,responseScreenVersion):
    event.clearEvents()
    respCorr = 0
    if responseScreenVersion == 1:
        responseScreen.setText('Symmetrical          Asymmetrical')
        responseScreen.draw()
        myWin.flip()
        
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'Symmetrical'
            if trialType == 'Symmetrical':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['l']:
            choice = 'Asymmetrical'
            if trialType == 'Asymmetrical':
                respCorr = 1
            else:
                respCorr = 0
    elif responseScreenVersion == 2:
        responseScreen.setText('Asymmetrical          Symmetrical')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Symmetrical'
            if trialType == 'Symmetrical':
                respCorr = 1
            else:
                respCorr = 0
        elif responseKey == ['a']:
            choice = 'Asymmetrical'
            if trialType == 'Asymmetrical':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice
    
def runBlock(trialbook,Reps): 
    blockDuration = 24
    nBlocksToGo = 20
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
        fixation1.draw()
        fixation2.draw()
        myWin.flip()
        w = myClock.getTime() + baselineDuration
        
        #n= "%s%s%s%s" %(Code1,Code2,Code3,'.png')
        n = "stimPNGs/"+str(Code1) +str(Code2)+str(Code3)+".png"
        print n
        i.setImage(n)
        i.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        
        

        w = myClock.getTime() + Duration
        
        myWin.flip()
        parallel.setData(Trigger)
        core.wait(0.01) # better to have this after the winFlip
        parallel.setData(0)
        
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        respCorr, choice = responseCollect(trialType, responseScreenVersion)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbookPractice.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',2) 
message('Goodbye')
core.wait(2)
myWin.close()
core.quit()