
########## DONT FORGET TO PUT THE TRIGGERS BACK IN ############

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, gui, parallel #these are the psychopy libraries
import math
import visualExtra

ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3

parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)#address for parallel port on many machines
parallel.setData(0)


#store info about the experiment
expName='GerbinoEEG_PNG3'#from the Builder filename that created this script
expInfo={'participant':'', 'subjNumber':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)

if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
seed(expInfo['subjNumber'])

if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, units='pix', allowStencil=True, size=(1280,1024), fullscr=True, monitor = 'EEG lab participant')#creates a window using pixels as units
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='white')#this is for the fixation
instruction=visual.TextStim(myWin, ori=0, text='text', height=34, color='white', units= 'pix')
ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=34, color='white', units= 'pix')
stim1=visual.ImageStim(myWin, image = None)


def message(Type):
    if Type == 'HelloExperiment':
        instruction.setText('Welcome to the Experiment. Press space to start with the practice.')
    elif Type == 'HelloTask':
        instruction.setText('This is the end of the practice.')
    elif Type == 'Goodbye':
        instruction.setText('End of experiment')
    instruction.draw()
    instruction.setPos((0,0))
    myWin.flip()

def responseCollect(ResponseScreenLimit,PromptT,correctKey,screenLag):
    global responseKey
    global respRT
    global respCorr

    ResponseScreen.setText(PromptT)
    ResponseScreen.draw()
    myWin.flip()
    respClock=core.Clock()
    responseKey = event.waitKeys(keyList=['a','l'], maxWait = ResponseScreenLimit)
    respRT = respClock.getTime()
    respCorr = 0
    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
    elif correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
    elif correctKey == 's':
        if responseKey == ['s']:
            respCorr=1
    elif correctKey == 'k':
        if responseKey == ['k']:
            respCorr=1
    core.wait(screenLag) # here the words are still on the screen. 

def runBlock(filename):

    #set up handler to look after randomisation of trials etc
    restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    if filename == 'data/practice3':
        numrep =1
        trials=data.TrialHandler(nReps=numrep, method='random', trialList=data.importConditions('trialbook1practice.xlsx')) #
        trials.extraInfo =expInfo  #so we store all relevant info into trials

    elif filename =='data/experiment3':
        numrep=1
        trials=data.TrialHandler(nReps=numrep, method='random', trialList=data.importConditions('trialbook1.xlsx')) #
        trials.extraInfo =expInfo  #so we store all relevant info into trials

    myClock = core.Clock()#this creates and starts a clock which we can later read  
    trialCounter = 0
    blockCounter = 0
    blockDuration = 32   
    noBlocks = 10
    
    # This long loop runs through the trials
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName) #this lines seem strange but it is just mkes the variables more readable

#        symmetry ='refConvex'  # debug
#        orientation =-1 #debug
#        colore = 'color1'#debug        
        
        if trialCounter == blockDuration:
            blockCounter = blockCounter+1
            trialCounter = 0
            block = noBlocks-(blockCounter)
            blockString= "%d blocks to go:     Wait for the experimenter to check electrodes" %(block)
            restScreen.setText(blockString)
            restScreen.draw()
            myWin.flip()
            event.waitKeys(keyList = 'g')
        trialCounter = trialCounter + 1
        
        fixation.draw()#draws fixation

        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible
#        event.waitKeys(keyList=["a"])
        
        t = myClock.getTime() + 1.5     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing


        if filename=='data/practice3':
            stim1.setImage('images3/'+'p%s' % (TrialNumberT) +symmetryT + coloreT+str(orientationT)+'.png')
        elif filename=='data/experiment3':
            stim1.setImage('images3/'+'%s' % (TrialNumberT) +symmetryT + coloreT+str(orientationT)+'.png')
        stim1.draw()


        parallel.setData(triggerT)
        myWin.flip()
        parallel.setData(0)


        if event.getKeys(keyList=["escape"]):
            core.quit()    # to close  and exit
            event.clearEvents()
            myWin.close

        presentation = myClock.getTime() +1.5
        while myClock.getTime()<presentation:
            pass

#        print symmetryT, orientationT, coloreT
        
        responseCollect(ResponseScreenLimit,PromptT,correctKeyT,screenLag)
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)
        trials.addData('respCorr',respCorr)

    #save all data
    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'sheet', dataOut=['all_raw'])
    
message('HelloExperiment')
event.waitKeys(keyList=['space'])
runBlock('data/practice3')
message('HelloTask')
event.waitKeys(keyList=['space'])
runBlock('data/experiment3')
message('Goodbye')
myWin.close()
core.quit()


