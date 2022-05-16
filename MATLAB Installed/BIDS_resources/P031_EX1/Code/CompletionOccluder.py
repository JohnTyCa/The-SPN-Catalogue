
#this is OSCAR'S EXPERIMENT

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core,data, event,gui,sound#,parallel #these are the psychopy libraries
import psychopy.logging #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *
import math
import visualExtra
import sys
import numpy

# need this library
#import serial
#ser = serial.Serial('COM3', 115200, timeout=100)
#ser.write(chr(0))
#

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010) 
#parallel.setData(chr(0))
#


w=[1,1,1]
b=[-1,-1,-1]
r= [1,0,0]
dr=[0.,-1.,-1.]
dgy= [-.5,-.5,-.5]
lgy= [.5,.5,.5]
#
occludercolor= [.8,.8,.8]
myWinColor= [-.3,-.3,-.3]
#
#occludercolor= [.7,.7,.7]
#myWinColor= w

expName='CompletionOccluder'#from the Builder filename that created this script
expInfo={'N':0,'order':1}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)

if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filenamexlsx= 'data/%s_%s_%s' %(expInfo['N'],expInfo['order'],expInfo['date'])
filenametxt= expName 
seed(expInfo['N'])

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  
#

myWin = visual.Window(allowGUI=False, units='pix', allowStencil=True, color= myWinColor, fullscr= True, viewScale=1,size= (1920,1080)) #size=(1280,1024)) # monitor = 'EEG lab participant')#creates a window using pixels as units
myClock = core.Clock()
#
size=40
ndots =80
sizeE= 80
maxheight= 180 
insideH= 170
maxwidth= 100
insideW= 70
height = 180 #140
width = 120  #90
nstepsy= 10
nstepsx= 3
jump= 10

#shape x= 320,y= 360
#mask height 520, width 360
e=  visual.Circle(myWin,interpolate=True,radius = sizeE/5,lineColor=lgy, fillColor= lgy)
#
fix=visual.Circle(myWin, pos=[0, 0], radius=6, lineColor=r, fillColor=r, units= 'pix')
#
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0,90], height=30, color=w, units= 'pix',font='Times New Roman')
line=visual.Line(myWin, units='pix', lineColor= dgy, start= (0,500), end = (0, -500))#,lineWidth=4)
# #
feedback = visual.TextStim(myWin, ori=0,text = 'x', pos=[0,70], height=30,  color=w, units= 'pix',font='Times New Roman')
imagename= os.path.join('images\AA.png')
myImage = visual.ImageStim(win=myWin, image= imagename , pos=[0,0])
# #
##vertex = (((-maxwidth -(sizeE/2) ), (-maxheight)), ((maxwidth +(sizeE/2)), (-maxheight)),((maxwidth +(sizeE/2)), (maxheight)), ((-maxwidth-(sizeE/2)), (maxheight))) # WHAT'S THIS???
x= maxwidth +(sizeE)
y= maxheight +(sizeE)
##SmallvertOccl= ((x,-y), (0,-y), (0,y), (x,y))
LargevertOccl= ((x,-y), (-x,-y), (-x,y), (x,y))
#Occl= visual.ShapeStim(myWin, lineColor=occludercolor, fillColor=occludercolor, pos=(0,0))#[0.,-1.,-1.]#
#Occl.setVertices(LargevertOccl)

noiseTexture = numpy.random.rand(1024, 1024) * 2.0 - 1
OcclR = visual.GratingStim(myWin, tex=noiseTexture,
    size=(360, 750), units='pix',
    interpolate=False, autoLog=False, pos= [361,0])
OcclL = visual.GratingStim(myWin, tex=noiseTexture,
    size=(360, 750), units='pix',
    interpolate=False, autoLog=False, pos= [-361,0])
    

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment.'
                    'In each trial you will see one unfamiliar abstract shape in the center of the screen. '
                    'This is presented for a very short time. Please try to concentrate and memorise the shape.'
                    'one of the rectangle bars will cover the shape for a short interval.'
                    'After that, the bar will slide back towards the original position and stop halfway, so that half of the shape underneath will be shown'
                    'your task is to report whether the shape is the SAME as before or a NOVEL (new) shape. '
                    'Try not to blink, and keep your eyes on the central fixation point'
                    'Please wait for the experimenter to start the experiment')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer.' 
                    'Try not to blink, and keep your eyes on the central fixation point. Please wait for the experimenter to start the experiment')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'repeat':
        message = ('if you want to repeat the practice press "A" - otherwise press "L" to continue to the experiment') 
    elif Type == 'Break':
        message = '%d Blocks to go: Take a break and Wait for experimenter to check electrodes! If everything is ok, the experiment can continue' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix',font='Times New Roman')
    Instructions.draw()
    myWin.flip()
    
def Occluder_start():
#    OcclR.setPos((361,0))
#    OcclL.setPos((-361,0))
    OcclR.draw()
    OcclL.draw()
def moveOccluder_Mask(shiftPos, speedOccl,visible):
    OcclClock = core.Clock()
    yPos = 0
    if visible == 'left':
        xPos = -361
##        OcclClock.reset(); t = 0
##        ck = OcclClock.getTime()
        while xPos < shiftPos:
            xPos = xPos + speedOccl
            OcclR.setPos((xPos,yPos),"")
            myImage.draw()
            OcclR.draw()
            OcclL.draw()
            fix.draw()
            myWin.flip()
##        ck=  OcclClock.getTime() - ck
##        print ck
    elif visible == 'right':
        xPos = 361
##        OcclClock.reset(); t = 0
##        ck = OcclClock.getTime()
        while xPos > 0:
            xPos = xPos - speedOccl
            OcclL.setPos((xPos,yPos),"")
            myImage.draw()
            OcclR.draw()
            OcclL.draw()
            fix.draw()
            myWin.flip()
##        ck=  OcclClock.getTime() - ck
##        print ck
def Occluder_mask(visible):
    if visible == 'left':
        OcclR.setPos((0,0))
        OcclR.draw()
        OcclL.draw()
    if visible == 'right':
        OcclL.setPos((0,0))
        OcclL.draw()
        OcclR.draw()
    
def Occluder_finish(visible):
    if visible == 'left':
        OcclR.setPos((181,0))
        OcclR.draw()
        OcclL.draw()
    if visible == 'right':
        OcclL.setPos((-181,0))
        OcclL.draw()
        OcclR.draw()
    

def responseCollect(SecondPoly,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Same             Novel')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'same'
            if SecondPoly== 'novel':
                respCorr = 0
            elif SecondPoly== 'same':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'novel'
            if SecondPoly== 'novel':
                respCorr = 1
            elif SecondPoly== 'same':
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Novel             Same')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'same'
            if SecondPoly== 'novel':
                respCorr = 0
            elif SecondPoly== 'same':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'novel'
            if SecondPoly== 'novel':
                respCorr = 1
            elif SecondPoly== 'same':
                respCorr = 0
    return respCorr, choice
    
def responseCollect_Practice(SecondPoly,ResponseScreenVersion):
    s1= sound.Sound(200,secs=0.5,sampleRate=44100,bits=16)
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Same             Novel')
        responseScreen.draw() 
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'same'
            if SecondPoly== 'novel':
                s1.play()
                respCorr = 0
            elif SecondPoly== 'same':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'novel'
            if SecondPoly== 'novel':
                respCorr = 1
            elif SecondPoly== 'same':
                s1.play()
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Novel             Same')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'same'
            if SecondPoly== 'novel':
                s1.play()
                respCorr = 0
            elif SecondPoly== 'same':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'novel'
            if SecondPoly== 'novel':
                respCorr = 1
            elif SecondPoly== 'same':
                s1.play()
                respCorr = 0
    return respCorr, choice

#

def RunBlock(trialbook,sessionName,Reps):
    myClock= core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='fullRandom', trialList=data.importConditions(trialbook))
    trialCounter = 0
    blockCounter = 0
    
    shiftPos=0
    speedOccl=361
    
    fixduration = uniform(.2,.5)
    baselineduration= 1.5
    polyAduration = .25
    Maskduration= .25 
    polyBduration= 1
   
    nBlocksToGo = 16
    blockDuration = 20

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
                #exec(paramName+'=thisTrial.'+paramName)
        
        if sessionName == 'experiment':
            if blockCounter == blockDuration:
                    nBlocksToGo = nBlocksToGo - 1
                    message('Break',nBlocksToGo = nBlocksToGo)
                    event.waitKeys(keyList = ['g'])
                    blockCounter = 0
                
        blockCounter= blockCounter+1
        trialCounter= trialCounter+1
         
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
        
                
        Regularity = 'ref'
#        SecondPoly= 'novel'
#        visible= 'right'

#        imageNo=trialCounter
        imageA= '%s.png'%(imageID_1)#
        imageB= '%s.png'%(imageID_2)#
        
        Occluder_start()
        fix.draw()
        myWin.flip()
        
        
        Occluder_start()
        #imagename= os.path.join(path, imageA)
        myImage.setImage('images/' + imageA)
        myImage.draw()
        fix.draw()
        

        t = myClock.getTime() + (baselineduration + fixduration)    
        while myClock.getTime() < t:
            pass #do nothing

        #POLYGON A ONSET
        ##parallel.setData(trigger)
#        ser.write(chr(trigger))
        myWin.flip()
#        ser.write(chr(0))
        ##parallel.setData(0)
##        event.waitKeys(keyList = ['g'])
##        pA= myClock.getTime()

        ## 
        t =   myClock.getTime() + polyAduration
        while myClock.getTime() < t:
            pass #do nothing
##        pA= myClock.getTime() - pA
##        print 'pA', pA

        #Occluder_mask(visible)
        moveOccluder_Mask(shiftPos, speedOccl,visible)
        
        Occluder_mask(visible)
        fix.draw()
        #MASK ONSET
        myWin.flip()
        ##event.waitKeys(keyList = ['g'])
        
##        ma= myClock.getTime()
        
        myImage.setImage('images/'+imageB)
        myImage.draw()
        Occluder_finish(visible)
        fix.draw()

        t =   myClock.getTime() + Maskduration
        while myClock.getTime() < t:
            pass #do nothing
##        ma= myClock.getTime() - ma
        print 'ma', ma

        #POLYGON B ONSET
        ##parallel.setData(trigger+10)
#        ser.write(chr(trigger+10))
        myWin.flip()
#        ser.write(chr(0))
        ##parallel.setData(0)
        ##event.waitKeys(keyList = ['g'])
        
        ##pB = myClock.getTime() 
        t = myClock.getTime() + polyBduration
        while myClock.getTime() < t:
            pass #do nothing
        ##pB = myClock.getTime() - pB
        ##print 'pB', pB
        
         # POLYGON B OFFSET
##        wt= myClock.getTime() - pA
##        print 'whole thing', wt

        Occluder_start()
        fix.draw()
        myWin.flip()

        t = myClock.getTime() + fixduration   
        while myClock.getTime() < t:
            pass #do nothing
            
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        OcclR.setPos((361,0))
        OcclL.setPos((-361,0))
        Occluder_start()
        fix.draw()
        RT = myClock.getTime()
        respCorr, choice = responseCollect(SecondPoly, ResponseScreenVersion)
        RT= myClock.getTime() - RT
        
        
        if sessionName == 'practice':
            if respCorr == 0:
                feedback.setText('Incorrect :-(')
                Occluder_start()
                fix.draw()#draws fixation
                feedback.draw()
            elif respCorr == 1:
                feedback.setText('Correct :-)')
                Occluder_start()
                fix.draw()#draws fixation
                feedback.draw()
            myWin.flip()
            core.wait(0.5)
        
        
        
        
        trials.addData('choice', choice)
        trials.addData('respCorr', respCorr)
        trials.addData('respTime',RT)
        
    if sessionName == 'experiment':
        #save all data
        trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'experiment', dataOut=['all_raw'])
        #trials.extraInfo=expInfo 
        #trials.saveAsWideText('data/'+filenametxt+'.txt')    
            
#
if expInfo['order']== 1: 
    trialbook='CO_trialbook1.xlsx'
elif expInfo['order']== 2: 
    trialbook='CO_trialbook2.xlsx'
elif expInfo['order']== 3: 
    trialbook='CO_trialbook3.xlsx'
elif expInfo['order']== 4: 
    trialbook='CO_trialbook2.xlsx'
elif expInfo['order']== 5: 
    trialbook='CO_trialbook3.xlsx'
elif expInfo['order']== 6: 
    trialbook='CO_trialbook6.xlsx' 
elif expInfo['order']== 7: 
    trialbook='CO_trialbook7.xlsx'
elif expInfo['order']== 8: 
    trialbook='CO_trialbook8.xlsx'
    
#practrialbook = 'CO_Figures.xlsx'
practrialbook'CO_practice.xlsx'

message('HelloPractice')
event.waitKeys(keyList = ['g'])
RunBlock(practrialbook,'practice',1)

repeat=False #here we give possibility to repeat practice as many times as they wish
while repeat == False:
    message('repeat')
    responseKey = event.waitKeys(keyList=['a','l'])
    if responseKey == ['a']:#if they wish they can repeat the practice
        repeat = False
        message('HelloPractice')
        event.waitKeys(keyList = ['g'])
        RunBlock(practrialbook,'practice',1)
    elif responseKey == ['l']: #if they feel confident they can carry on with the experiment
        repeat = True
        message('HelloMain')
        event.waitKeys(keyList = ['g'])
        RunBlock(trialbook,'experiment', 1) # (320 trials: 4 conditions (8subconditions): 80reps per condition) . 

message('Goodbye')
event.waitKeys('Space')
myWin.close
core.quit()

ser.close()