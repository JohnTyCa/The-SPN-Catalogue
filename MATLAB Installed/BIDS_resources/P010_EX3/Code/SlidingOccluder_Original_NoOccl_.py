from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, sound, gui,parallel #these are the psychopy libraries
import psychopy.logging #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *
import math
#import visualExtra
import sys
#import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
#from OpenGL import GLUT

#these three lines are slightly different since we moved to the new computer
#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)
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
myWin = visual.Window(allowGUI=False, units='pix', allowStencil=True, color= myWinColor, size=(1280,1024)) #size=(800,600)) # , monitor = 'EEG lab participant')#creates a window using pixels as units
myClock = core.Clock()


expName='SlidingOccluder'#from the Builder filename that created this script
expInfo={'N':00}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)

if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filenamexlsx= 'data/%s_%s' %(expInfo['N'], expInfo['date'])
filenametxt= expName 


expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName 

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

#
#size=40
#ndots =20
#sizeE= 40
#maxheight= 200
#maxwidth= 140
#
#
s1 = sound.Sound(200,secs=0.5,sampleRate=44100, bits=16)
#
size=40
ndots =100
sizeE= 80
maxheight= 180
insideH= 180
maxwidth= 100
insideW= 60
height = 140
width = 90
nstepsy= 12
nstepsx= 3
jump= 10

#
vertex = (((-maxwidth -(sizeE/2) ), (-maxheight)), ((maxwidth +(sizeE/2)), (-maxheight)),((maxwidth +(sizeE/2)), (maxheight)), ((-maxwidth-(sizeE/2)), (maxheight))) 
#e= visual.Rect(myWin, width=sizeE, height=sizeE, lineColor=None, fillColor=[-1,-1,-1])
e=  visual.Circle(myWin,interpolate=True,radius = sizeE/5,lineColor=dgy, fillColor= dgy)
basesquare= visual.ShapeStim(myWin, vertices = vertex, lineColor=b, fillColor=b, pos=(0,0))
#fix=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=40, color=r, bold= True, colorSpace='rgb', units= 'pix',font='Times New Roman')
fix=visual.Circle(myWin, pos=[0, 0], radius=6, lineColor=None, fillColor=r, units= 'pix')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0,90], height=30, color=w, units= 'pix',font='Times New Roman')
#

#
x= -maxwidth -(sizeE)
y= maxheight +(sizeE)
vertOccl= ((x,-y), (0,-y), (0,y), (x,y))
#vertOccl= (((-maxwidth -(sizeE)), (-maxheight -(sizeE))), (0, (-maxheight -(sizeE))),(0, (maxheight + (sizeE))), (((-maxwidth -(sizeE))), (maxheight+ (sizeE)))) 
#Occl= visual.ShapeStim(myWin, vertices = vertOccl, lineColor=[1,-1.,-1.], fillColor=[0.,-1.,-1.], pos=(0,0))

Occl= visual.ShapeStim(myWin, lineColor=None, fillColor=None, pos=(0,0))#[0.,-1.,-1.]#
Occl.setVertices(vertOccl)

#Occluder= visual.ImageStim(myWin, image ='occluder.png', size= (180,520))
#

#
PolyL=visual.ShapeStim(myWin, lineColor=None, fillColor=None)
PolyR=visual.ShapeStim(myWin, lineColor=None, fillColor=None)
stimL =visual.ShapeStim(myWin, lineColor=None, fillColor=lgy)
stimR =visual.ShapeStim(myWin, lineColor=None, fillColor=lgy)
#

linea =visual.Rect(myWin, width=100, height=1.5, lineColor=(-1,-1,-1), fillColor=None)
marginL =visual.Line(myWin)
marginR =visual.Line(myWin)
#
#
def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether they are reflection or random')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
def fixation():
    #basesquare.draw()
    fix.draw()
#
def preparepolygon(regularity, seedNo):
    seed(seedNo)
    coords =[]
    coords.append([0,-height])
    
#    x= 0
#    stepx= width/nstepsx
#    for i in range(nstepsx-1):
#        x= x-stepx
#        y= -height + randint(-20,20)
#        coords.append([x,y])
        
    coords.append([-width, -height])
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = -width + randint(-40,40)
        coords.append([x,y])
        
    coords.append([-width, height])
    
#    x= -width
#    for i in range(nstepsx-1):
#        x= x+stepx
#        y= height + randint(-20,20)
#        coords.append([x,y])
        
    coords.append([0, height ])
    coords.append([0, -height])
    
    PolyL.setVertices(coords)


    if regularity=='ref':
        temp = []
        for i in range(len(coords)):
            temp.append([-coords[i][0],coords[i][1]])
            
        PolyR.setVertices(temp)
        
    if regularity == 'ran':
        # the left side
        coords =[]
        
        coords.append([0,-height])
        
#        x= 0
#        stepx= width/nstepsx
#        for i in range(nstepsx-1):
#            x= x+stepx
#            y= -height + randint(-20,20)
#            coords.append([x,y])

        coords.append([width, -height])
        
        y = -height
        stepy = (height*2)/nstepsy
        for i in range(nstepsy-1):
            y = y +stepy
            x = width + randint(-40,40)
            coords.append([x,y])
            
        coords.append([width, height])
        
#        x= width
#        for i in range(nstepsx-1):
#            x= x-stepx
#            y= height + randint(-20,20)
#            coords.append([x,y])
            
        coords.append([ 0, height ])
        coords.append([0, -height])
        
        PolyR.setVertices(coords)

#    PolyL.draw()
#    PolyR.draw()

def colorpolygon():
    
    left = PolyL.vertices
    right = PolyR.vertices
        
    flag = 0
    for i in range(nstepsy):
        s1= []
        s2= []
        s1.append(left[i+1])
        s1.append(left[i+2])
        s1.append([0,left[i+2][1]])
        s1.append([0,left[i+1][1]])
        
        s2.append(right[i+1])
        s2.append(right[i+2])
        s2.append([0,right[i+2][1]])
        s2.append([0,right[i+1][1]])
        
        stimL.vertices= s1
        stimR.vertices= s2
        
        stimL.size= stimR.size= 1.3
        
        stimL.draw()
        stimR.draw()
    
def insidepolygon(regularity, seedNo):
    seed(seedNo)
    ecoord = []
    erad=[]
    ecolor=[]
    a=[0]
    b=[1]
    memory =(a*(400-ndots))+(b*ndots)  
    shuffle(memory)
#    PolyL.enabled=True

    i= 0
    for x in range (-insideW,0,jump):
        for y in range(-insideH, insideH, jump): 
            if PolyL.contains(x,y):
                if (memory[i]== 1): 
                    rad=randint(4,12)
                    ecoord.append([x,y])
                    erad.append([rad])
                    e.setPos([x,y])  
                    e.setRadius([rad])
                    e.draw()
                i= i+1
#
    if regularity == 'ref':
        i = 0
        for i in range (len(ecoord)):
            e.setPos([-ecoord[i][0],ecoord[i][1]])
            e.setRadius(erad[i])
            e.draw()
            i= i+1
    elif regularity == 'ran':
        shuffle(memory)
        i= 0
        for x in range (insideW,0,-jump):
            for y in range(-insideH, insideH, jump):
                if PolyR.contains(x,y):
                    if (memory[i]== 1): 
                        rad=randint(4,12)
                        e.setPos([x,y])  
                        e.setRadius([rad])
                        e.draw()
                    i= i+1
                    


def shapescreenshot(regularity, seedNo):
    global screenshot
    preparepolygon(regularity, seedNo)
    colorpolygon()
    insidepolygon(regularity, seedNo)
    #screenshot = visual.BufferImageStim(myWin,  rect=(-.5, .5, .5, -.5))
    screenshot = visual.BufferImageStim(myWin, rect=(-.6, .6, .6, -.6))

#   
def drawOccluder(shiftPos, OcclStartPos):
    yPos= 0
    if OcclStartPos == 'left':
        xPos=0
        Occl.setPos((xPos,yPos),"")
    if OcclStartPos == 'right':
        Occl.setPos((shiftPos,yPos),"")

    Occl.setFillColor(myWinColor)
    Occl.setLineColor(myWinColor)
    Occl.draw()
    fix.draw()
    
def moveOccluder(shiftPos, speedOccl,regularity, seedNo, OcclStartPos, Pduration):
    OcclClock = core.Clock()
    yPos = 0
    if OcclStartPos == 'left':
        xPos = 0
        #OcclClock.reset(); t = 0
        
#        ck = OcclClock.getTime()
        while xPos < shiftPos:
            xPos = xPos + speedOccl
            Occl.setPos((xPos,yPos),"")
            screenshot.draw()
            Occl.draw()
            fix.draw()
            myWin.flip()
#        ck=  OcclClock.getTime() - ck
#        print ck
        
    elif OcclStartPos == 'right':
        xPos = shiftPos
        #OcclClock.reset(); t = 0
        
#        ck = OcclClock.getTime()
        while xPos > 0:
            xPos = xPos - speedOccl
            Occl.setPos((xPos,yPos),"")
            screenshot.draw()
            Occl.draw()
            fix.draw()
            myWin.flip()
#        ck=  OcclClock.getTime() - ck
#        print ck
def responseCollect(regularity,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Reflection    Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if regularity== 'ran':
                respCorr = 0
            elif regularity== 'ref':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'ran'
            if regularity== 'ran':
                respCorr = 1
            elif regularity== 'ref':
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random    Reflection')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if regularity== 'ran':
                respCorr = 0
            elif regularity== 'ref':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'ran'
            if regularity== 'ran':
                respCorr = 1
            elif regularity== 'ref':
                respCorr = 0
    return respCorr, choice
    
def responseCollect_Practice(regularity,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Reflection    Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if regularity== 'ran':
                s1.play()
                respCorr = 0
            elif regularity== 'ref':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'ran'
            if regularity== 'ran':
                respCorr = 1
            elif regularity== 'ref':
                s1.play()
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random    Reflection')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if regularity== 'ran':
                s1.play()
                respCorr = 0
            elif regularity== 'ref':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'ran'
            if regularity== 'ran':
                respCorr = 1
            elif regularity== 'ref':
                s1.play()
                respCorr = 0
    return respCorr, choice

def RunBlock(trialbook,fileName,Reps):
    
#    parallel.setData(0)
    
    myClock= core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    trialCounter = 0
    blockCounter = 0
    fixduration = uniform(.2,.5)
    baselineduration= 1.5
    
    FirstHalfduration=0.5
    SecondHalfduration = 1
    shiftPos= 181
    speedOccl= 181
    
    nBlocksToGo = 6
    blockDuration = 40

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
                
        if blockCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                blockCounter = 0
                
        #setOccluderType(OcclType)
        
        blockCounter= blockCounter+1
        trialCounter= trialCounter+1
        seedNo= trialCounter 
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            

        fixation()
        myWin.flip()
        t = myClock.getTime() + fixduration    
        while myClock.getTime() < t:
            pass #do nothing
            
        fixation()
        drawOccluder(shiftPos, OcclStartPos)
        myWin.flip()
        
        shapescreenshot(regularity, seedNo)
        drawOccluder(shiftPos, OcclStartPos)
        
        t = myClock.getTime() + baselineduration    
        while myClock.getTime() < t:
            pass #do nothing
            
        #PATTERN ONSET
        
#        parallel.setData(trigger)
        myWin.flip()
#        parallel.setData(0)
        
##        w= myClock.getTime() 
        t =   myClock.getTime() + FirstHalfduration
        while myClock.getTime() < t:
            pass #do nothing
##        fh = myClock.getTime() - w
##        print 'fh', fh
        
        
        moveOccluder(shiftPos, speedOccl,regularity, seedNo, OcclStartPos, SecondHalfduration)
        
        
##        sh = myClock.getTime() 
        t = myClock.getTime() + SecondHalfduration
        while myClock.getTime() < t:
            pass #do nothing
##        sh = myClock.getTime() - sh
##        print 'sh', sh

         # PATTERN OFFSET
         
##        wt= myClock.getTime() - w
##        print 'whole thing', wt
        
        fixation()
        Occl.draw()
        fix.draw()
        myWin.flip()
        
        t = myClock.getTime() + fixduration   
        while myClock.getTime() < t:
            pass #do nothing
            
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        fixation()
        RT = myClock.getTime()
        
        if fileName == 'practice':
            respCorr, choice = responseCollect_Practice(regularity, ResponseScreenVersion)
        elif fileName == 'experiment':
            respCorr, choice = responseCollect(regularity, ResponseScreenVersion)
            
        RT= myClock.getTime() - RT
        
        
        trials.addData('choice', choice)
        trials.addData('respCorr', respCorr)
        trials.addData('respTime',RT)
        
        
    #save all data
    trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'filenamexlsx', dataOut=['all_raw'])
    trials.extraInfo =expInfo      
    trials.saveAsWideText('data/'+filenametxt+'.txt')  
        
 


trialbook='trialbook.xlsx' 
message('HelloPractice')
event.waitKeys('Space')
RunBlock(trialbook,'practice',4)
message('HelloMain')
event.waitKeys('Space')
RunBlock(trialbook,'experiment', 30) # (240 trials: 2 conditions (4subconditions): 120 reps) . 
message('Goodbye')
event.waitKeys('Space')
myWin.close
core.quit()