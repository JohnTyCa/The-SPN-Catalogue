from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui  # parallel
from pyglet.gl import *

#store info about the experiment
expName='Horizontal and Vertical'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
#setup files for saving

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

noDots = 11 # how many dots do you want on each side of the shape?
jitter = 80 # how much do you want the dots to deviate (at the most) from their wide position
wide = 120#average offet
hi = 50 # pixels between dot centres
duration = 2 # how many seconds do you want each shape to be presented? This is less than in the Psychophysiology paper, because we never explore the last second anyway. 
radius = 60 # default pixels radius of individual dots
screenWidth = 1280# how wide is your screen
screenHeight = 1024# how high is your screen
minDotSize = 30# how big do you want the smallest dot to be?
maxDotSize = 60 # how big do you want the largest dot to be?
envelopeHeight = 800 # how tall do you want the envelope to be?
envelopeWidth = 800 # how wide do you want the envelope to be?
ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
colors = False # do you want color? 
greyscale = True # do you want grey?
minCol = -1 # whats the lowest intensity? -1 to 1
maxCol = 0.5# whats the highest intensity? -1 to 1
screenLag = 0.3
baseline = 1.2

    #psychopy.parallel.setData(0)

myWin = visual.Window([screenWidth,screenHeight], allowGUI=False, fullscr= True)
background = visual.Circle(myWin, edges = 256, size=(envelopeHeight,envelopeWidth), units='pix', interpolate=True, fillColor= 'white')


def responseCollect(ResponseScreenLimit,Prompt,correctKey,screenLag):
    global responseKey
    global respRT
    global respCorr
    ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=20, color='Black', colorSpace='rgb', units= 'pix')
    background.draw()
    ResponseScreen.setText(Prompt)
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

#responseCollect(10, 'Reflection, Rotation, Random, Translation','s')
#myWin.close()


def drawRegularity(Type, orientation, minDotSize, maxDotSize, jitter, wide, hi, baseline):
    myPatch = visual.Circle(myWin, edges = 256,  units='pix', interpolate=True)
    fixation=visual.TextStim(myWin, ori=0, text='+', pos=[-1, 3], height=60, color='Black', colorSpace='rgb', units= 'pix')
    if orientation == 'vertical':
      axis = visual.Line(myWin, start = [0,envelopeHeight/2], end = [0,-envelopeHeight/2],lineColor = 'black')
      background.draw()
      axis.draw()
      fixation.draw()
      myWin.flip()
      core.wait(baseline)
      background.draw()
      
      for n in range(noDots): #Draw the stimuli
          sizeJitter = uniform(minDotSize, maxDotSize)
          myPatch.setSize(sizeJitter)
          deviation = uniform(-jitter,jitter)
          xPos = wide+deviation
          yPos = (n-(noDots/2))*hi
          myPatch.setPos([xPos,yPos])
          
          if colors == True or greyscale:
              r = uniform(minCol,maxCol)
              g = uniform(minCol, maxCol)
              b = uniform(minCol, maxCol)
          if colors == True or greyscale == True:
                      r = uniform(minCol,maxCol)
                      g = uniform(minCol,maxCol)
                      b = uniform(minCol,maxCol)
                      if greyscale == True:
                          myPatch.setFillColor([r,r,r])
                      elif colors == True:
                          myPatch.setFillColor([r,g,b])
                  
          myPatch.draw()
          
          if Type == 1 or Type == 5: # Reflection
              myPatch.setPos([-xPos,yPos])   # here is the reflected dot
           
          elif Type == 2 or Type == 6:# Rotation 
              myPatch.setPos([-xPos,-yPos]) # here is the rotated dot
              
          elif Type == 3 or Type == 7: # random
              if colors == True or greyscale == True:

                      r = uniform(minCol,maxCol)
                      g = uniform(minCol,maxCol)
                      b = uniform(minCol,maxCol)
                      if greyscale == True:
                          myPatch.setFillColor([r,r,r])
                      elif colors == True:
                          myPatch.setFillColor([r,g,b])
              
              sizeJitter = uniform(minDotSize, maxDotSize)
              deviation = uniform(-jitter,jitter)
              myPatch.setSize(sizeJitter)
              xPos = wide+deviation
              yPos = (n-(noDots/2))*hi
              myPatch.setPos([-xPos,yPos]) # here is the rotated dot
              
          elif Type == 4 or Type == 8: # translation
              myPatch.setPos([xPos-(wide*2),yPos]) # here is the rotated dot
          myPatch.draw()
            
            
    elif orientation == 'horizontal':
        axis = visual.Line(myWin, start = [envelopeHeight/2,0], end = [-envelopeHeight/2,0],lineColor = 'black')
        background.draw()
        axis.draw()
        fixation.draw()
        myWin.flip()
        core.wait(baseline)
        background.draw()
        for n in range(noDots): #Draw the stimuli
            sizeJitter = uniform(minDotSize, maxDotSize)
            myPatch.setSize(sizeJitter)
            deviation = uniform(-jitter,jitter)
            yPos = wide+deviation
            xPos = (n-(noDots/2))*hi
            myPatch.setPos([xPos,yPos])
            
            if colors == True or greyscale:
                r = uniform(minCol,maxCol)
                g = uniform(minCol, maxCol)
                b = uniform(minCol, maxCol)
            if colors == True or greyscale == True:
                        r = uniform(minCol,maxCol)
                        g = uniform(minCol,maxCol)
                        b = uniform(minCol,maxCol)
                        if greyscale == True:
                            myPatch.setFillColor([r,r,r])
                        elif colors == True:
                            myPatch.setFillColor([r,g,b])
                    
            myPatch.draw()
            
            if Type == 1 or Type == 5: # Reflection
                myPatch.setPos([xPos,-yPos])   # here is the reflected dot
             
            elif Type == 2 or Type == 6:# Rotation 
                myPatch.setPos([-xPos,-yPos]) # here is the rotated dot
                
            elif Type == 3 or Type == 7: # random
                if colors == True or greyscale == True:

                        r = uniform(minCol,maxCol)
                        g = uniform(minCol,maxCol)
                        b = uniform(minCol,maxCol)
                        if greyscale == True:
                            myPatch.setFillColor([r,r,r])
                        elif colors == True:
                            myPatch.setFillColor([r,g,b])
                
                sizeJitter = uniform(minDotSize, maxDotSize)
                deviation = uniform(-jitter,jitter)
                myPatch.setSize(sizeJitter)
                yPos = wide+deviation
                xPos = (n-(noDots/2))*hi
                myPatch.setPos([xPos,-yPos]) # here is the rotated dot
                
            elif Type == 4 or Type == 8: # translation
                myPatch.setPos([xPos,yPos-(wide*2)]) # here is the rotated dot
            myPatch.draw()

    
    axis.draw()
    fixation.draw()
    #psychopy.parallel.setData(Type)
    myWin.flip()# draw the stimuli
    #psychopy.parallel.setData(0)
drawRegularity(8,'horizontal', minDotSize, maxDotSize, jitter, wide, hi,1)
core.wait(3)
myWin.close()
core.quit()
def runBlock(trialbook):
    restScreen=visual.TextStim(myWin, text='break, press g to continue', pos=[0, 0], height=1, color='white') # change this to calibration screen
    myClock = core.Clock()
    trials=data.TrialHandler(nReps=1, method='random', trialList=data.importConditions(trialbook))
    
    trialCounter = 0
    blockDuration = 36
    noBlocks = 8
    
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
           
        drawRegularity(Type,orientation, minDotSize, maxDotSize, jitter, wide, hi,baseline)
        core.wait(duration)
        responseCollect(ResponseScreenLimit,Prompt,correctKey,screenLag)
            
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)
        trials.addData('respCorr',respCorr)
        
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials',
        dataOut=['all_raw'])


Hello=visual.TextStim(myWin, text='Welcome to the Experiment. Your task is to disciminate reflection from translation', pos=[0, 0], height=30, color='white')
Hello.draw()
myWin.flip()
event.waitKeys(keyList = 'space')

runBlock('practice.xlsx')

Real=visual.TextStim(myWin, text='Practice is over, time for the real experiment! It is exactly the same but much longer.', pos=[0, 0], height=30, color='white')
Real.draw()
myWin.flip()
event.waitKeys(keyList = 'space')

runBlock('trialbook.xlsx')

goodbye=visual.TextStim(myWin, ori=0, text='Experiment Over. Thank you', pos=[0, 0], height=30, color='white')
goodbye.draw()
myWin.flip()
core.wait(2)
myWin.flip()
myWin.close 