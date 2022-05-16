#THIS IS John'S experiment

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import visual, core, data, event, sound, gui #these are the psychopy libraries
import math, scipy, random, os, copy
import visualExtra
import math

#import serial, time
#ser = serial.Serial('COM3', 115200, timeout=100)
#ser.write(chr(0).encode())

expName='JohnBW'
expInfo={'name':'','number':1,'task':'white'}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['number'], expInfo['date'])



if dlg.OK==False: 
    core.quit() #user pressed cancel

if not os.path.isdir('data'):      #folder data
    os.makedirs('data')            #if this fails (e.g. permissions) we will get error

seedN =expInfo['number']   #this way subject number to have unique stimuli peer subject instead
random.seed(seedN)
task = expInfo['task']


myWin = visual.Window(allowGUI=False, units='pix', monitor = 'testMonitor', size=(500,500), fullscr=False,gammaErrorPolicy = 'warn')#creates a window using pixels as units
myClock = core.Clock()

duration = 1 # this sets stimulus duration

instruction=visual.TextStim(myWin, text='', height=30, color='black')
respInstruction=visual.TextStim(myWin, text='', height=30, wrapWidth=900, color=(-.5,-.5,-.5))
respInstructionCue=visual.TextStim(myWin, text='', pos = [0,100],height=30, wrapWidth=900, color=(-.5,-.5,-.5))
fixationCircle = visual.Circle(myWin, radius=4, fillColor=(0.8,-0.5,-0.5), lineColor=None)

stim = visual.ImageStim(myWin)


print("psychopy object done")


# instructions for the practice and for the experiment
def message(Type, nBlocksToGo):
    if Type == 'Break':
        m = "{} Blocks to go. Wait for experimenter to check electrodes".format(nBlocksToGo)
        instruction.setText(m)
    elif Type == 'HelloExperiment':
        if task =='white':
            instruction.setText('Welcome to the Experiment. Look at the centre of the screen and pay attention to the WHITE pattern.')
        elif task =='black':
            instruction.setText('Welcome to the Experiment. Look at the centre of the screen and pay attention to the BLACK pattern.')
    elif Type == 'HelloTask':
        if task =='white':        
            instruction.setText('This is the end of the practice. Pay attention to the WHITE pattern. Start of the experiment.')
        elif task =='black':        
            instruction.setText('This is the end of the practice. Pay attention to the BLACK pattern. Start of the experiment.')

    elif Type == 'Goodbye':
        instruction.setText('End of experiment. Press space bar to quit.')

    instruction.draw()



# run the experiment
def runBlock(trialbook, repeats):

    trialCounter = 0
    blockDuration = 17
    nBlocksToGo = 16
    
    # This long loop runs through the trials
    trials=data.TrialHandler(nReps=repeats, seed=seedN, method='random', trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting
        
        
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                myWin.flip()
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1

        
        fixationCircle.draw()#draws fixation
        myWin.flip()
        myWin.getMovieFrame()
        myWin.saveMovieFrames('fixation.png')
        
        t = myClock.getTime() + rand()/2. + 0.75     # baseline
        if task =='white':
            s = 'ImagesW/' + condition + str(set) + '.png' # condition and set come from trialbook
            respInstructionCue.setText('white was:')
        elif task =='black':
            s = 'ImagesB/' + condition + str(set) + '.png' # condition and set come from trialbook
            respInstructionCue.setText('black was:')
        
        stim.setImage(s)
        stim.draw()
        fixationCircle.draw()#draws fixation
        while myClock.getTime() < t:
            pass #do nothing for the rest of baseline
        
#
        
        myWin.flip() #this is the critical winFlip
        myWin.getMovieFrame()
        myWin.saveMovieFrames('stim.png')
        t1 = myClock.getTime() + duration     

#        ser.write(chr(trigger).encode()) # for the trigger
#        core.wait(0.01)
#        ser.write(chr(0).encode())
        
        if keyMapping== 'right':
                respInstruction.setText('Symmetrical         Asymmetrical')
        elif keyMapping == 'left':
                respInstruction.setText('Asymmetrical         Symmetrical')
        respInstruction.draw()
        respInstructionCue.draw()
        while myClock.getTime() < t1:
            pass #do nothing


        


        myWin.flip() # this flips on the response screen
        myWin.getMovieFrame()
        myWin.saveMovieFrames('responseScreen.png')
        
        timenow = myClock.getTime()
        responseKey = event.waitKeys(keyList=['a', 'l','escape'])
        respRT = myClock.getTime()-timenow #time taken to respond
        
              
        if responseKey[0] == 'escape':
            core.quit()
            
        trials.addData('responseKey', responseKey[0])
        trials.addData('respRt', respRT)

        
    #save all data
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])


message('HelloExperiment',0)
myWin.flip()
event.waitKeys(keyList=['g'])
runBlock('trialbookPractice.xlsx', 1)
message('HelloTask',0)
myWin.flip()
event.waitKeys(keyList=['g'])
runBlock('trialbook.xlsx', 1)
message('Goodbye',0)
myWin.flip()
core.wait(4)
myWin.close()
core.quit()