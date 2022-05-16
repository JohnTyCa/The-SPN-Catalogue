from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui, sound
from pyglet.gl import *


#participant should be 140 cm from the screen if we are using this
noDots = 11 # how many dots do you want on each side of the shape?
jitter = 80 # how much do you want the dots to deviate (at the most) from their wide position
wide = 120#average offet
hi = 50 # pixels between dot centres
duration = 3 # how many seconds do you want each shape to be presented?
radius = 60 # default pixels radius of individual dots
screenWidth = 1280# how wide is your screen
screenHeight = 1024# how high is your screen
ITI = 1 #how long is the ITI in seconds?
minDotSize = 30# how big do you want the smallest dot to be?
maxDotSize = 60 # how big do you want the largest dot to be?
envelopeHeight = 800 # how tall do you want the envelope to be?
envelopeWidth = 800 # how wide do you want the envelope to be?
oddballScreenLimit = 3 # how many seconds do you want the oddball screen to be on?
colors = False # do you want color? 
greyscale = True # do you want grey?
minCol = -1 # whats the lowest intensity? -1 to 1
maxCol = 0.5# whats the highest intensity? -1 to 1
screenLag = 0.5
blockDuration = 3 # How many trials per blockDuration



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


myWin = visual.Window([screenWidth,screenHeight], allowGUI=False, fullscr= True)
#myWin = visual.Window([600,600], allowGUI=True, fullscr= False)
myPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(radius,radius), units='pix', interpolate=True, color = [-1, -1, -1], colorSpace = 'rgb')
fixation=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=60, color='Black', colorSpace='rgb', units= 'pix')
Oddballs=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
backgroundPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeHeight,envelopeWidth), mask ='circle', units='pix', interpolate=True, color= 'white')
restScreen=visual.TextStim(myWin, ori=0, text='break   Press any key to continue', pos=[0, 0], height=60, color='Black', colorSpace='rgb', units= 'pix')

trials=data.TrialHandler(nReps=1, method='sequential', trialList=data.importConditions('practiceManipulationCheck_Trialbook.xlsx'))
thisTrial=trials.trialList[0]#so we can initialise stimuli with some values
trialCounter = 0
noBlocks = len(trials.trialList)/blockDuration
blockCounter = 0
# This long loop runs through the block
for thisTrial in trials:
    
    if trialCounter > blockDuration-1:
            blockCounter = blockCounter + 1
            block = noBlocks-(blockCounter)
           
            blockString= "%d blocks to go:     Press any key to continue" %(block)
            restScreen.setText(blockString)
            restScreen.draw()
            myWin.flip(clearBuffer = True)
            rest = event.waitKeys()
            trialCounter = 0
            

    screenLagClock = core.Clock()
    t = 0
    while t < screenLag:
        t=screenLagClock.getTime()
        
    backgroundPatch.draw()
    fixation.draw()
    myWin.flip(clearBuffer = True) # There are two things. The buffer and the screen. Win Flip dumps the contents of the buffer onto the screen. The buffer is blank after this operation. 
    backgroundPatch.draw()
    fixation.draw()
    ITIClock = core.Clock()
    t = 0
    while t < ITI:
        t=ITIClock.getTime()
    
    
    
    # Once the fixation screen has been drawn and flipped into place, we wait for the duration of the ITI. 
    if colors == True or greyscale:
        r = uniform(minCol,maxCol)
        g = uniform(minCol, maxCol)
        b = uniform(minCol, maxCol)
        sequential =0
        
    if thisTrial!=None:
        for paramName in thisTrial.keys():
            exec(paramName+'=thisTrial.'+paramName)
    
    if Oddball ==1:
        oddballIteration = randint(0, noDots-1)# e.g. 0-19
    else:
        oddballIteration = 0
    #backgroundPatch.draw()

            
    for n in range(noDots): #Draw the stimuli
        
        myPatch.setMask('circle')
        if n == oddballIteration and Oddball == 1:
            myPatch.setMask('None')
        
        sizeJitter = uniform(minDotSize, maxDotSize)
        myPatch.setSize(sizeJitter)
        deviation = uniform(-jitter,jitter)
        xPos = wide+deviation
        yPos = (n-(noDots/2))*hi
        myPatch.setPos([xPos,yPos])
            
        if colors == True or greyscale == True:
                    r = uniform(minCol,maxCol)
                    g = uniform(minCol,maxCol)
                    b = uniform(minCol,maxCol)
                    if greyscale == True:
                        myPatch.setColor([r,r,r])
                    elif colors == True:
                        myPatch.setColor([r,g,b])
                    
                    
        myPatch.draw()
                    
        if (Type == 1): #reflection
            myPatch.setPos([-xPos,yPos])   # here is the reflected dot
         
        elif (Type == 2): # rotation
            myPatch.setPos([-xPos,-yPos]) # here is the rotated dot
            
        elif (Type == 3): # random
            if colors == True or greyscale == True:
                    r = uniform(minCol,maxCol)
                    g = uniform(minCol,maxCol)
                    b = uniform(minCol,maxCol)
                    if greyscale == True:
                        myPatch.setColor([r,r,r])
                    elif colors == True:
                        myPatch.setColor([r,g,b])
                    
            sizeJitter = uniform(minDotSize, maxDotSize)
            myPatch.setSize(sizeJitter)
            deviation = uniform(-jitter,jitter)
            xPos = wide+deviation
            yPos = (n-(noDots/2))*hi
            myPatch.setPos([-xPos,yPos]) 
            
        elif (Type == 4): # translation
            myPatch.setPos([xPos-(wide*2),yPos]) # here is the rotated dot
            
            
        myPatch.draw()
    
        
    myWin.flip(clearBuffer = True)# draw the stimuli


    if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close

    respClock=core.Clock()

    
    
    responseKey = event.waitKeys(keyList=['a', 'l'], maxWait = duration)
    respRT = respClock.getTime()
    #print respRT
#    print correctKey
    if correctKey == 'a':
         if responseKey == ['a']: 
                respCorr=1
         else: 
                respCorr = 0
            
                warn = sound.Sound(800,secs=0.4,sampleRate=44100, bits=8)
                warn.play()
    if correctKey == 'l':
         if responseKey == ['l']:
                respCorr=1
         else: 
                respCorr=0
                warn = sound.Sound(800,secs=0.4,sampleRate=44100, bits=8)
                warn.play()
#    print respCorr
    if  respRT < oddballScreenLimit:#we had a response
        trials.addData('responseKey', responseKey)
        trials.addData('respRt', respRT)
        trials.addData('respCorr', respCorr)
    trialCounter = trialCounter+1


trials.saveAsExcel(filename+'.xlsx', sheetName='trials',
    stimOut=['Type','correctKey','Label', 'Oddball', 'Prompt'],
    dataOut=['all_raw'])

myWin.close()
core.wait(screenLag)
core.quit()


