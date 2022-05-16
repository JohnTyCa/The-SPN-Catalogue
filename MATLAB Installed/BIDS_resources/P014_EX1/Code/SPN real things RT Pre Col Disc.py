

  # THIS IS Elena's first experiment

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui,sound#, parallel
from pyglet.gl import * #a graphic library
import math

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

expName='SPN real things'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'dataRTPreColDisc/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('dataRTPreColDisc'):
    os.makedirs('dataRTPreColDisc')#if this fails (e.g. permissions) we will get error  

myClock = core.Clock()
baselineDuration = 1.5
Duration = 1.5
fixationSize = 40
punishmentSoundDuration = 1
myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'pix', fullscr= True, color='black')
i = visual.ImageStim(myWin, mask=None, units='', pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=False, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, text = 'Symmetry        Asymmetry', pos=[0, 300], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'blue')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'blue')
punishmentSoundDuration = 1
s1 = sound.Sound(200,secs=punishmentSoundDuration,sampleRate=44100, bits=16)


def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of images. Your task is to decide whether they are symmetrical or asymmetrical')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try too keep your eyes and the central cross and not to blink!')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()


def runBlock(trialbook,Reps): 
    blockDuration = 24
    nBlocksToGo = 10
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
#        print n
        i.setImage(n)
        i.draw()
        fixation1.draw()
        fixation2.draw()
        responseScreen.draw()
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        

        w = myClock.getTime() 
        #parallel.setData(trigger)
        myWin.flip()
        #parallel.setData(0)
        
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        respCorr =1
        RT = myClock.getTime() -w
        if trialType == 'Symmetrical':
            if responseKey == ['a']:
                respCorr = 1
                myWin.flip()
            elif responseKey == ['l']:
                respCorr = 0
                s1.play()
                core.wait(punishmentSoundDuration)
                myWin.flip()
        elif trialType == 'Asymmetrical':
            if responseKey == ['l']:
                respCorr = 1
                myWin.flip()
            elif responseKey == ['a']:
                respCorr = 0
                s1.play()
                core.wait(punishmentSoundDuration)
                myWin.flip()

        trials.addData('respCorr',respCorr)
        trials.addData('choice',responseKey)
        trials.addData('RT',RT)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbookPractice.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1) # change to trialbook2 for alternative response screen to image mapping (not very important)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()