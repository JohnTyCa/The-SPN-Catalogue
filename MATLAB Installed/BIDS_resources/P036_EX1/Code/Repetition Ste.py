from __future__ import division
from psychopy import visual, sound, core, data, event,  gui,parallel #these are the psychopy libraries
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
import sys
import psychopy.logging #import like this so it doesn't interfere with numpy.log
import math
import sys
from psychopy import logging, prefs
logging.console.setLevel(logging.DEBUG)#get messages about the sound lib as it loads

#store info about the experiment
expName='Repetition S'#from the Builder filename that created this script
expInfo={'participant':'','order':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window([1280,1024], allowGUI=False, fullscr= True, monitor = 'EEG lab participant', units = 'deg')

def responseCollect(Regularity,screenLag):

    global prompt
    global correctKey
    global respRT
    global responseKey
    global respCorr
    ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=1, color='white')
    
    promptLeftOrRight = randint(2)

    if promptLeftOrRight == 1:
        prompt = 'symm            not'
        if Regularity == 'Rand':
            correctKey = 'l'
        else:
           correctKey = 'a'
           
    if promptLeftOrRight == 0:
        prompt = 'not            symm'
        if Regularity == 'Rand':
            correctKey = 'a'
        else:
           correctKey = 'l'
           
#    print correctKey    

    
    ResponseScreen.setText(prompt)
    ResponseScreen.draw()
    myWin.flip()
    respClock=core.Clock()
    respCorr = 0
    respClock.reset()
    responseKey = event.waitKeys(keyList=['a','l'])
    respRT = respClock.getTime()

    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
        else:
            respCorr=0
    if correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
        else:
            respCorr=0

    core.wait(screenLag) # here the words are still on the screen. 
#    print respCorr
def runBlock(trialbook,order):
    screenLag = 0.3
    minBase = 1.5
    maxBase = 2.0
    duration  = 1.5
    stimSize = 12
    trialCounter = 0
    blockCounter = 0
    blockDuration = 40
    noBlocks = 12
    
    restScreen =visual.TextStim(myWin, pos=[0, 0], height=1, color='white')
    i = visual.ImageStim(myWin, image = '1.jpg', pos=[0, 0],size = [stimSize,stimSize])
    fixation = visual.TextStim(myWin, text='+', pos=[0, 0], height=1, color='red')
    trials=data.TrialHandler(nReps=1, method=order, trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        if trialCounter == blockDuration:
            blockCounter = blockCounter+1
            block = noBlocks-(blockCounter)
            blockString= "%d blocks to go:     Wait for the experimenter to check electrodes" %(block)
            restScreen.setText(blockString)
            restScreen.draw()
            myWin.flip()
            event.waitKeys(keyList = 'g')
            trialCounter = 0
        
        trialCounter = trialCounter+ 1
        
        fixation.draw()
        myWin.flip()
        core.wait(uniform(minBase,maxBase))
        imagename ="%s.jpg"%Jpeg
        i.setImage(imagename)
        i.draw()
        fixation.draw()
        psychopy.parallel.setData(Trigger)
        myWin.flip()
        psychopy.parallel.setData(0)
        core.wait(duration)
        myWin.flip()
        responseCollect(Regularity,screenLag)
        trials.addData('prompt',prompt)
        trials.addData('respCorr',respCorr)
        trials.addData('correctKey',correctKey)
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)

    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])
    trials.extraInfo =expInfo
    trials.saveAsWideText(filename+'.txt')
    
Hello=visual.TextStim(myWin, text='Welcome to the Experiment. Your task is to disciminate symmetry from random', pos=[0, 0], height=1, color='white')
realExp=visual.TextStim(myWin, text='Now for the real experiment. Remember to keep your eyes on the fixation cross', pos=[0, 0], height=1, color='white')
Hello.draw()
myWin.flip()
event.waitKeys(keyList = 'space')
if expInfo['order'] == '1':
    runBlock('practice.xlsx','sequential')
    realExp.draw()
    myWin.flip()
    event.waitKeys(keyList = 'space')
    runBlock('P1.xlsx','sequential')
    
elif expInfo['order'] == '2':
    runBlock('practice.xlsx','sequential')
    realExp.draw()
    myWin.flip()
    event.waitKeys(keyList = 'space')
    runBlock('P2.xlsx','sequential')
    
elif expInfo['order'] == '3':
    runBlock('practice.xlsx','sequential')
    realExp.draw()
    myWin.flip()
    event.waitKeys(keyList = 'space')
    runBlock('P3.xlsx','sequential')
    
elif expInfo['order'] == '4':
    
    runBlock('practice.xlsx','sequential')
    realExp.draw()
    myWin.flip()
    event.waitKeys(keyList = 'space')
    runBlock('P4.xlsx','sequential')

    
Goodbye =visual.TextStim(myWin, text='Thank you for taking part in the experiment', pos=[0, 0], height=1, color='white')
Goodbye.draw()
myWin.flip()
core.wait(2)
myWin.flip()
myWin.close()
core.quit()
        
        
        
       