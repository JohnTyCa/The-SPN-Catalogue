from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui, sound
import psychopy.log #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *

noDots = 11 # how many dots do you want on each side of the shape?
jitter = 80 # how much do you want the dots to deviate (at the most) from their wide position
wide = 120#average offet
hi = 50 # pixels between dot centres
duration = 5 # how many seconds do you want each shape to be presented?
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
colorRepeats = 3 # how many dots in row row do you want to be a matched color?
minCol = -1 # whats the lowest intensity? -1 to 1
maxCol = 0.5# whats the highest intensity? -1 to 1
screenLag = 0.5
blockDuration = 3# How many trials per blockDuration


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

myWin = visual.Window([screenWidth,screenHeight], allowGUI=False, fullscr= True)
myPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(radius,radius), units='pix', interpolate=True, color = [-1, -1, -1], colorSpace = 'rgb')
fixation=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=60, color='Black', colorSpace='rgb', units= 'pix')
Oddballs=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
backgroundPatch = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeHeight,envelopeWidth), mask ='circle', units='pix', interpolate=True, color= 'white')
restScreen=visual.TextStim(myWin, ori=0, text='Break   Press any key to continue', pos=[0, 0], height=60, color='Black', colorSpace='rgb', units= 'pix')
#wrongScreen=visual.TextStim(myWin, ori=0, text='incorrect', pos=[0, -200], height=30, color='Black', colorSpace='rgb', units= 'pix')

#set up handler to look after randomisation of trials etc
trials=data.TrialHandler(nReps=1, method='sequential', trialList=data.importTrialList('PracticemanipulationCheck_Trialbook.xlsx'))
thisTrial=trials.trialList[0]#so we can initialise stimuli with some values
trialCounter = 0
noBlocks = len(trials.trialList)/blockDuration
blockCounter = 0
xPosR =zeros(noDots)
yPosR =zeros(noDots)
xPosL =zeros(noDots)
yPosL =zeros(noDots)
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
        oddballIteration = randint(0, noDots-1)
    else:
        oddballIteration = -1
    #backgroundPatch.draw()
            
    for n in range(noDots): #Draw the stimuli

        if n == oddballIteration:
            myPatch.setMask('None')
        else:
            myPatch.setMask('circle')

        if Type not in (3,7):
            sizeJitter = uniform(minDotSize, maxDotSize)
            myPatch.setSize(sizeJitter)
            deviation = uniform(-jitter,jitter)
            xPos1 = wide+deviation
            yPos1 = (n-(noDots/2))*hi
            myPatch.setPos([xPos1,yPos1])
        
        else:
            done = False
            sizeJitter = uniform(minDotSize, maxDotSize)
            myPatch.setSize(sizeJitter)
            while done ==False:
                deviation = uniform(-jitter,jitter)
                xPosR[n] = -wide+deviation
                yPosR[n] = uniform(-hi*(noDots/2), hi*(noDots/2))
                done=True
                if n>0:
                    for i in range(0,n):
                        differencex = abs(xPosR[n] - xPosR[i])
                        differencey = abs(yPosR[n] - yPosR[i])
                        if (differencex <sizeJitter/2) and (differencey <sizeJitter/2):
                            done=False
            myPatch.setPos((xPosR[n],yPosR[n]))
        


        if colors == True or greyscale == True:
            r = uniform(minCol,maxCol)
            g = uniform(minCol,maxCol)
            b = uniform(minCol,maxCol)
            if greyscale == True:
                        myPatch.setColor([r,r,r])
            elif colors == True:
                        myPatch.setColor([r,g,b])
                        
        myPatch.draw()
                    
        if Type in (1,5): #reflection
            myPatch.setPos([-xPos1,yPos1])   # here is the reflected dot

        elif Type in (2,6): # rotation
            myPatch.setPos([-xPos1,-yPos1]) # here is the rotated dot
            
        elif Type in (3,7): # random

                if colors == True or greyscale == True:
                    r = uniform(minCol,maxCol)
                    g = uniform(minCol,maxCol)
                    b = uniform(minCol,maxCol)
                    if greyscale == True:
                        myPatch.setColor([r,r,r])
                    elif colors == True:
                        myPatch.setColor([r,g,b])

                done = False
                sizeJitter = uniform(minDotSize, maxDotSize)
                myPatch.setSize(sizeJitter)
                while done ==False:
                    deviation = uniform(-jitter,jitter)
                    xPosL[n] = wide+deviation
                    yPosL[n] = uniform(-hi*(noDots/2), hi*(noDots/2))
                    done=True
                    if n>0:
                        for i in range(0,n):
                            differencex = abs(xPosL[n] - xPosL[i])
                            differencey = abs(yPosL[n] - yPosL[i])
                            if (differencex <sizeJitter/2) and (differencey <sizeJitter/2):
                                done=False
                    
                myPatch.setPos((xPosL[n],yPosL[n]))

        elif Type in (4,8): # translation
            myPatch.setPos([xPos1-(wide*2),yPos1]) # here is the rotated dot

        myPatch.draw()
    
        

    myWin.flip(clearBuffer = True)# draw the stimuli


    if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close

    respClock=core.Clock()

    
    
    responseKey = event.waitKeys(keyList=['a', 'l'], maxWait = duration)
#    print responseKey
    respRT = respClock.getTime()
    #print respRT
#    print correctKey
    if correctKey == 'a':
         if responseKey == ['a']: 
                respCorr=1
         else: 
                respCorr = 0
                warn = sound.Sound(800,secs=1,sampleRate=44100, bits=8)
                warn.play()
                core.wait(2)
    if correctKey == 'l':
         if responseKey == ['l']:
                respCorr=1
         else: 
                respCorr=0
                warn = sound.Sound(800,secs=1,sampleRate=44100, bits=8)
                warn.play()
                core.wait(2)
#    print respCorr
    if  respRT < oddballScreenLimit:#we had a response
        trials.addData('responseKey', responseKey)
        trials.addData('respRt', respRT)
        trials.addData('respCorr', respCorr)
    trialCounter = trialCounter+1

trials.saveAsPickle(filename+'trials')
trials.saveAsExcel(filename+'.xlsx', sheetName='trials',
    stimOut=['Type','correctKey','Label', 'Oddball', 'Prompt'],
    dataOut=['all_raw'])
psychopy.log.info('saved data to '+filename+'.dlm')
logFile.close()
myWin.close()
core.wait(screenLag)
core.quit()


