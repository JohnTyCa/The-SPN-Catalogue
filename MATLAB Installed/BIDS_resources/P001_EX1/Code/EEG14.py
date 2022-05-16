from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui
import psychopy.log #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *import math
# how many dots do you want on each side of the shape?
duration = 3 # how many seconds do you want each shape to be presented?
screenWidth = 1280# how wide is your screen
screenHeight = 1024# how high is your screen
ITI = 1 #how long is the ITI in seconds?
envelopeHeight = 400 
envelopeTwoHeight = envelopeHeight# how tall do you want the envelope to be?
QuestionScreenLimit = 3 # how many seconds do you want the oddball screen to be on?
screenLag = 0.5
blockDuration = 30 # How many trials per block 
minDotSize = 20
maxDotSize = 80

#store info about the experiment
expName='EEG-Symmetry'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
#setup files for saving


if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
logFile=open(filename+'.log', 'w')
psychopy.log.console.setLevel(psychopy.log.WARNING)#this outputs to the screen, not a file

trialCounter = 0
(envelopeHeight*envelopeHeight)*2
envelopeHeight = math.sqrt((envelopeHeight*envelopeHeight)*2)
dotSize = envelopeTwoHeight/8
noDots = 9
Xpos = zeros(noDots)
Ypos = zeros(noDots)

myWin = visual.Window([screenWidth,screenHeight], allowGUI=False, fullscr= True)
#myWin = visual.Window([600,600], allowGUI=True, fullscr= False)
myPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(dotSize,dotSize), units='pix', interpolate=True, color = 'black')
fixation=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=60, color='Grey', colorSpace='rgb', units= 'pix')
Question=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
backgroundPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeHeight,envelopeHeight), mask ='circle', units='pix', interpolate=True, color= 'black')
backgroundPatch2 = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeTwoHeight, envelopeTwoHeight), mask ='none', units='pix', interpolate=True, color= 'white', ori = 45)
restScreen=visual.TextStim(myWin, ori=0, text='break   Press any key to continue', pos=[0, 0], height=60, color='Black', colorSpace='rgb', units= 'pix')

#set up handler to look after randomisation of trials etc
trials=data.TrialHandler(nReps=1, method='random', trialList=data.importTrialList('EEGTrialbook.xlsx'))
thisTrial=trials.trialList[0]#so we can initialise stimuli with some values

# This sets out the template for one quadrant
Xpos[0] = (dotSize+(dotSize/2))
Ypos[0] = (dotSize/2)
            
Xpos[1] = (dotSize*2)+(dotSize/2)
Ypos[1] = (dotSize/2)
            
Xpos[2] = (dotSize*3)+(dotSize/2)
Ypos[2] = (dotSize/2)
            
Xpos[3] = (dotSize/2)
Ypos[3] = (dotSize+(dotSize/2))
            
Xpos[4] = (dotSize+(dotSize/2))
Ypos[4] = (dotSize+(dotSize/2))
            
Xpos[5] =(dotSize*2)+(dotSize/2)
Ypos[5] = (dotSize+(dotSize/2))
            
Xpos[6] = (dotSize/2)
Ypos[6] = (dotSize*2)+(dotSize/2)
            
Xpos[7] = (dotSize+(dotSize/2))
Ypos[7] = (dotSize*2)+(dotSize/2)
            
Xpos[8] = (dotSize/2)
Ypos[8] = (dotSize*3)+(dotSize/2)

myClock = core.Clock()


# This long loop runs through the block
for thisTrial in trials:
    trialCounter = trialCounter + 1
    if trialCounter > blockDuration:
            restScreen.draw()
            myWin.flip(clearBuffer = True)
            rest = event.waitKeys()
            trialCounter = 0    
    
    t = myClock.getTime() + screenLag
    while myClock.getTime() < t:
        pass
    backgroundPatch.draw()    backgroundPatch2.draw()
    fixation.draw()
    myWin.flip(clearBuffer = True) 
    backgroundPatch.draw()
    backgroundPatch2.draw()
    fixation.draw()
        t = myClock.getTime() + ITI
    while myClock.getTime() < t:
        pass
    
    
    
    
    if thisTrial!=None:
        for paramName in thisTrial.keys():
            exec(paramName+'=thisTrial.'+paramName)

    if Oddball ==1:
        oddballIteration = randint(0, noDots-1)
    else:
        oddballIteration = -1

    Qpoints = [0,0,0,0,1,1,1,1,1]
    shuffle(Qpoints)
    for n in range(noDots):
            
            X = Xpos[n] #from the vector constructed above
            Y = Ypos[n] # from the vector constructed above
            if n == oddballIteration:
                myPatch.setMask('circle')
            else:
                myPatch.setMask('none')
                        
            if Qpoints[n] == 1:
                myPatch.setColor('black')
            elif Qpoints[n] == 0:
                myPatch.setColor('white')
            
            Orientation = randint(1, 3)
            if Orientation== 1:
                myPatch.setOri(45)
            elif Orientation == 2:
                myPatch.setOri(0)
                
            Size = uniform(minDotSize, maxDotSize)
            myPatch.setSize(Size)
                
            myPatch.setPos([X, Y])
            myPatch.draw()
            
            if Type == 1: # Reflection
                myPatch.setPos([-X, - Y])
                myPatch.draw()
                myPatch.setPos([-X, Y])
                myPatch.draw()
                myPatch.setPos([X, -Y])
                myPatch.draw()
           
            if Type == 3: # Random
                
#                if randint(1, 3) == 1:
#                        myPatch.setColor('white')
#                else:
#                        myPatch.setColor('black')
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myPatch.setOri(45)
                elif Orientation == 2:
                        myPatch.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myPatch.setSize(Size)
                myPatch.setPos([-X, - Y])
                myPatch.draw()

#                if randint(1, 3) == 1:
#                        myPatch.setColor('white')
#                else:
#                        myPatch.setColor('black')
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myPatch.setOri(45)
                elif Orientation == 2:
                        myPatch.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myPatch.setSize(Size)
                myPatch.setPos([-X, Y])
                myPatch.draw()
                
            
#                if randint(1, 3) == 1:
#                        myPatch.setColor('white')
#                else:
#                        myPatch.setColor('black')
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myPatch.setOri(45)
                elif Orientation == 2:
                        myPatch.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myPatch.setSize(Size)
                myPatch.setPos([X, - Y])
                myPatch.draw()
                
                
                
    #psychopy.parallel.setData(Type)
    myWin.flip(clearBuffer = True)# draw the stimuli

    t = myClock.getTime() + duration
    while myClock.getTime() < t:
        if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
    #psychopy.parallel.setData(0)

    backgroundPatch.draw()
    backgroundPatch2.draw()
    Question.setText(Prompt)
    Question.draw()
    myWin.flip(clearBuffer = True)
    
    # get the response
    t = myClock.getTime()
    responseKey = event.waitKeys(keyList=['a', 'l'], maxWait = QuestionScreenLimit)
#    print responseKey
    respRT = myClock.getTime()-t
    #print respRT
#    print correctKey
    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
        else: respCorr = 0
        
    if correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
        else: respCorr=0
#    print respCorr
    if  respRT < QuestionScreenLimit:#we had a response
        trials.addData('responseKey', responseKey)
        trials.addData('respRt', respRT)
        trials.addData('respCorr', respCorr)
        

trials.saveAsPickle(filename+'trials')
trials.saveAsExcel(filename+'.xlsx', sheetName='trials',
    stimOut=['Type','correctKey','Label', 'Oddball', 'Prompt'],
    dataOut=['all_raw'])
psychopy.log.info('saved data to '+filename+'.dlm')
logFile.close()
myWin.close()
core.wait(screenLag)
core.quit()


