

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event,  gui, sound, parallel #these are the psychopy libraries
import psychopy.logging #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *
import math
#import visualExtra
import sys
#import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
#from OpenGL import GLUT

#
#these three lines are slightly different since we moved to the new computer
#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)


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

myWin = visual.Window(allowGUI=False, units='pix', allowStencil=True, color= myWinColor, size=(800,800),fullscr = False) # , monitor = 'EEG lab participant')#creates a window using pixels as units
myClock = core.Clock()


#expName='SlidingOccluder2halves'#from the Builder filename that created this script
#expInfo={'N':0,'name':''}
#dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
#
#if dlg.OK==False: core.quit() #user pressed cancel
#expInfo['date']=data.getDateStr()#add a simple timestamp
#expInfo['expName']=expName
#filenamexlsx= 'data/%s_%s' %(expInfo['N'], expInfo['date'])
#filenametxt= expName 
#
#
#expInfo['date']=data.getDateStr()#add a simple timestamp
#expInfo['expName']=expName 
#
#if not os.path.isdir('data'):
#    os.makedirs('data')#if this fails (e.g. permissions) we will get error  
#
size=40
ndots =100
sizeE= 80
maxheight= 180
insideH= 170
maxwidth= 100
insideW= 70
height = 140
width = 90
nstepsy= 12
nstepsx= 3
jump= 10

#
arrowL= visual.ShapeStim(myWin, units='pix', lineColor=r, fillColor=r, vertices= ((-50,210),(-70,225),(-30,225)))
arrowR= visual.ShapeStim(myWin, units='pix', lineColor=r, fillColor=r, vertices= ((50,210),(70,225),(30,225)))
#e= visual.Rect(myWin, width=sizeE, height=sizeE, lineColor=None, fillColor=[-1,-1,-1])
e=  visual.Circle(myWin,interpolate=True,radius = sizeE/5,lineColor=dgy, fillColor= dgy)
#fix=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=40, color=r, bold= True, colorSpace='rgb', units= 'pix',font='Times New Roman')
fix=visual.Circle(myWin, pos=[0, 0], radius=6, lineColor=r, fillColor=r, units= 'pix')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0,90], height=30, color=w, units= 'pix',font='Times New Roman')
s1 = sound.Sound(200,secs=0.5,sampleRate=44100)
line=visual.Line(myWin, units='pix', lineColor= dgy, start= (0,500), end = (0, -500))#,lineWidth=4)
#
PolyAR= visual.ShapeStim(myWin, lineColor=lgy, fillColor=lgy)
PolyAL= visual.ShapeStim(myWin, lineColor=lgy, fillColor=lgy)
PolyBRs= visual.ShapeStim(myWin,  lineColor=lgy, fillColor=lgy)
PolyBLs= visual.ShapeStim(myWin,  lineColor=lgy, fillColor=lgy)
PolyBRr= visual.ShapeStim(myWin,  lineColor=lgy, fillColor=lgy)
PolyBLr= visual.ShapeStim(myWin,  lineColor=lgy, fillColor=lgy)
#
#
def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment.'
                    'In each trial you will see two unfamiliar abstract shapes, one after the other.'
                    'An arrow indicates which half of the shape you have to attend to.'
                    'Your task is to decide whether the second half is a reflection of the first attended half, or it is random.'
                    'Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer.' 
                    'Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix',font='Times New Roman')
    Instructions.draw()
    myWin.flip()
    
def cue(polygon,AttendFirst):
    if polygon == 'A':
        if AttendFirst== 'FirstLeft':
            arrowL.draw()
        if AttendFirst == 'FirstRight':
            arrowR.draw()
    if polygon == 'B':
        if AttendFirst== 'FirstLeft':
            arrowR.draw()
        if AttendFirst == 'FirstRight':
            arrowL.draw()
            
def PolygonA(seedNo):
    seed(seedNo)
    # prepare left half
    coords =[]
    coords.append([0,-height])
        
    coords.append([-width, -height])
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = -width + randint(-40,40)
        coords.append([x,y])
        
    coords.append([-width, height])
        
    coords.append([0, height ])
    coords.append([0, -height])
    
    PolyAL.setVertices(coords)
    
    
    #prepare right half
    coords =[]
    
    coords.append([0,-height])
    coords.append([width, -height])
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = width + randint(-40,40)
        coords.append([x,y])
        
    coords.append([width, height])
        
    coords.append([ 0, height ])
    coords.append([0, -height])
    
    PolyAR.setVertices(coords)
    PolyAL.size=PolyAR.size=1.3
    
def insidePolygonA(seedNo):
    global ALecoord, ALerad, ARecoord, ARerad
    seed(seedNo)
    ALecoord = []
    ALerad=[]
    ARecoord = []
    ARerad=[]
    a=[0]
    b=[1]
    memory =(a*(400-ndots))+(b*ndots)  
    shuffle(memory)
    i= 0
    for x in range (-insideW,0,jump):
        for y in range(-insideH, insideH, jump): 
            if PolyAL.contains(x,y):
                if (memory[i]== 1): 
                    rad=randint(4,12)
                    ALecoord.append([x,y])
                    ALerad.append([rad])
                    e.setPos([x,y])  
                    e.setRadius([rad])
                    e.draw()
                i= i+1

    shuffle(memory)
    i= 0
    for x in range (insideW,0,-jump):
        for y in range(-insideH, insideH, jump):
            if PolyAR.contains(x,y):
                if (memory[i]== 1): 
                    rad=randint(4,12)
                    ARecoord.append([x,y])
                    ARerad.append([rad])
                    e.setPos([x,y])  
                    e.setRadius([rad])
                    e.draw()
                i= i+1
def drawPolygonA(seedNo): #the first polygon is always a random novel shape 
    PolygonA(seedNo)
    PolyAL.draw()
    PolyAR.draw()
    insidePolygonA(seedNo)
#
def PolygonB(seedNo):
    seed(seedNo+1000)
    #prepare the symmetrical halves
    left = PolyAL.vertices
    right= PolyAR.vertices
    
    temp = []
    for i in range(len(left)):
        temp.append([-left[i][0],left[i][1]])
    PolyBRs.setVertices(temp)
    
    temp=[]
    for i in range(len(right)):
        temp.append([-right[i][0],right[i][1]])
    PolyBLs.setVertices(temp)
    
    #prepare the random halves
    coords =[]
    coords.append([0,-height])
        
    coords.append([-width, -height])
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = -width + randint(-40,40)
        coords.append([x,y])
        
    coords.append([-width, height])
        
    coords.append([0, height ])
    coords.append([0, -height])
    
    PolyBLr.setVertices(coords)
    
    coords =[]
    
    coords.append([0,-height])
    coords.append([width, -height])
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = width + randint(-40,40)
        coords.append([x,y])
        
    coords.append([width, height])
        
    coords.append([ 0, height ])
    coords.append([0, -height])
    
    PolyBRr.setVertices(coords)
    
    PolyBRs.size = PolyBLs.size = PolyBLr.size= PolyBRr.size = 1.3
    
def insidepolygonB_V1(Regularity, AttendFirst, seedNo):
    seed(seedNo)
    ecoord = []
    erad=[]
    ecolor=[]
    a=[0]
    b=[1]
    memory =(a*(400-ndots))+(b*ndots)  
    shuffle(memory)
#    PolyL.enabled=True

    if Regularity == 'ref':
            i = 0
            for i in range (len(ALecoord)):
                e.setPos([-ALecoord[i][0],ALecoord[i][1]])
                e.setRadius(ALerad[i])
                e.draw()
                i= i+1
                
            i=0
            for i in range (len(ARecoord)):
                e.setPos([-ARecoord[i][0],ARecoord[i][1]])
                e.setRadius(ARerad[i])
                e.draw()
                i= i+1
                
    if Regularity == "ran":     
        if AttendFirst == 'FirstLeft':
            i = 0
            for i in range (len(ARecoord)):
                e.setPos([-ARecoord[i][0],ARecoord[i][1]])
                e.setRadius(ARerad[i])
                e.draw()
                i= i+1
                
            shuffle(memory)
            i= 0
            for x in range (insideW,0,-jump):
                for y in range(-insideH, insideH, jump):
                    if PolyBRr.contains(x,y):
                        if (memory[i]== 1): 
                            rad=randint(4,12)
                            ecoord.append([x,y])
                            erad.append([rad])
                            e.setPos([x,y])  
                            e.setRadius([rad])
                            e.draw()
                        i= i+1
            
        elif AttendFirst == 'FirstRight':
            i=0
            for i in range (len(ALecoord)):
                e.setPos([-ALecoord[i][0],ALecoord[i][1]])
                e.setRadius(ALerad[i])
                e.draw()
                i= i+1    
            
            shuffle(memory)
            i= 0
            for x in range (-insideW,0,jump):
                for y in range(-insideH, insideH, jump): 
                    if PolyBLr.contains(x,y):
                        if (memory[i]== 1): 
                            rad=randint(4,12)
                            ecoord.append([x,y])
                            erad.append([rad])
                            e.setPos([x,y])  
                            e.setRadius([rad])
                            e.draw()
                        i= i+1
def insidepolygonB_V2(Regularity, AttendFirst, seedNo):
    seed(seedNo+1000)
    ecoord = []
    erad=[]
    ecolor=[]
    a=[0]
    b=[1]
    memory =(a*(400-ndots))+(b*ndots)  

    if Regularity == 'ref':
        if AttendFirst == 'FirstLeft': #the right half is reflection of polyA's right half, and the left half is a novel random
            i = 0
            for i in range (len(ALecoord)):
                e.setPos([-ALecoord[i][0],ALecoord[i][1]])
                e.setRadius(ALerad[i])
                e.draw()
                i= i+1
                
            shuffle(memory)
            i= 0
            for x in range (-insideW,0,jump):
                for y in range(-insideH, insideH, jump): 
                    if PolyBLr.contains(x,y):
                        if (memory[i]== 1): 
                            rad=randint(4,12)
                            ecoord.append([x,y])
                            erad.append([rad])
                            e.setPos([x,y])  
                            e.setRadius([rad])
                            e.draw()
                        i= i+1
            
        if AttendFirst == 'FirstRight':#the left half is reflection of polyA's righ half, and the right half is a novel random
            i=0
            for i in range (len(ARecoord)):
                e.setPos([-ARecoord[i][0],ARecoord[i][1]])
                e.setRadius(ARerad[i])
                e.draw()
                i= i+1
                
            shuffle(memory)
            i= 0
            for x in range (insideW,0,-jump):
                for y in range(-insideH, insideH, jump):
                    if PolyBRr.contains(x,y):
                        if (memory[i]== 1): 
                            rad=randint(4,12)
                            ecoord.append([x,y])
                            erad.append([rad])
                            e.setPos([x,y])  
                            e.setRadius([rad])
                            e.draw()
                        i= i+1
                
    if Regularity == "ran": #it draws two random halves which are both different from polyA     
        shuffle(memory)
        i= 0
        for x in range (insideW,0,-jump):
            for y in range(-insideH, insideH, jump):
                if PolyBRr.contains(x,y):
                    if (memory[i]== 1): 
                        rad=randint(4,12)
                        ecoord.append([x,y])
                        erad.append([rad])
                        e.setPos([x,y])  
                        e.setRadius([rad])
                        e.draw()
                    i= i+1
        shuffle(memory)
        i= 0
        for x in range (-insideW,0,jump):
            for y in range(-insideH, insideH, jump): 
                if PolyBLr.contains(x,y):
                    if (memory[i]== 1): 
                        rad=randint(4,12)
                        ecoord.append([x,y])
                        erad.append([rad])
                        e.setPos([x,y])  
                        e.setRadius([rad])
                        e.draw()
                    i= i+1
                    
def drawPolygonB_V1(seedNo,Regularity,AttendFirst): #in this version, the unattended half is always a reflection (so 'mask' is kept the same, just mirrored)
    PolygonB(seedNo)
    if Regularity == 'ref':
            PolyBRs.draw()
            PolyBLs.draw()
    elif Regularity == 'ran':
        if AttendFirst == 'FirstLeft':
            PolyBRr.draw()
            PolyBLs.draw()
        elif AttendFirst == 'FirstRight':
            PolyBLr.draw()
            PolyBRs.draw()
    insidepolygonB_V1(Regularity, AttendFirst, seedNo)
def drawPolygonB_V2(seedNo,Regularity,AttendFirst): #in this version, the unattended half is always novel (so 'mask' changes between the two windows)
    PolygonB(seedNo)
    if Regularity == 'ref':
        if AttendFirst=='FirstLeft':
            PolyBRs.draw()
            PolyBLr.draw()
        elif AttendFirst == 'FirstRight':
            PolyBLs.draw()
            PolyBRr.draw()
    elif Regularity == 'ran':
            PolyBRr.draw()
            PolyBLr.draw()
    insidepolygonB_V2(Regularity, AttendFirst, seedNo)
    
def responseCollect(Regularity,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Reflection    Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if Regularity== 'ran':
                respCorr = 0
            elif Regularity== 'ref':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'ran'
            if Regularity== 'ran':
                respCorr = 1
            elif Regularity== 'ref':
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random    Reflection')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if Regularity== 'ran':
                respCorr = 0
            elif Regularity== 'ref':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'ran'
            if Regularity== 'ran':
                respCorr = 1
            elif Regularity== 'ref':
                respCorr = 0
    return respCorr, choice
    
def responseCollect_Practice(Regularity,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Reflection    Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if Regularity== 'ran':
                s1.play()
                respCorr = 0
            elif Regularity== 'ref':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'ran'
            if Regularity== 'ran':
                respCorr = 1
            elif Regularity== 'ref':
                s1.play()
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random    Reflection')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if Regularity== 'ran':
                s1.play()
                respCorr = 0
            elif Regularity== 'ref':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'ran'
            if Regularity== 'ran':
                respCorr = 1
            elif Regularity== 'ref':
                s1.play()
                respCorr = 0
    return respCorr, choice

def RunBlock(trialbook,fileName,Reps):
    
#    parallel.setData(0)
    
    myClock= core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='sequential', trialList=data.importConditions(trialbook))
    trialCounter = 0
    blockCounter = 0
    fixduration = uniform(.2,.5)
    baselineduration= 1.5
    polyAduration = .5
    polyBduration= 1
    
    nBlocksToGo = 6
    blockDuration = 40

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting
        
        if blockCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                blockCounter = 0
        
        #Regularity = 'ran'
        #AttendFirst = 'FirstRight'
        
        blockCounter= blockCounter+1
        trialCounter= trialCounter+1
        seedNo= trialCounter 
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        cue('A',AttendFirst)
        line.draw()
        fix.draw()
        myWin.flip()
        
        cue('A',AttendFirst)
        drawPolygonA(seedNo)
        line.draw()
        fix.draw()
        t = myClock.getTime() + (baselineduration + fixduration)    
        while myClock.getTime() < t:
            pass #do nothing
            
        #POLYGON A ONSET
#        parallel.setData(trigger)
        myWin.flip()
#        parallel.setData(0)
        myWin.getMovieFrame()
        n= "%s%s%s" %(Regularity,AttendFirst,'T1.png')
        myWin.saveMovieFrames(n)
        #event.waitKeys('Space')
        cue('B',AttendFirst)
        drawPolygonB_V2(seedNo,Regularity,AttendFirst)
        line.draw()
        fix.draw()
##        pA= myClock.getTime() 
        t =   myClock.getTime() + polyAduration
        while myClock.getTime() < t:
            pass #do nothing
##        pA= myClock.getTime() - pA
##        print 'pA', pA
        
        #POLYGON B ONSET
#        parallel.setData(trigger+10)
        myWin.flip()
#        parallel.setData(0)
        myWin.getMovieFrame()
        n= "%s%s%s" %(Regularity,AttendFirst,'T2.png')
        myWin.saveMovieFrames(n)
##        pB = myClock.getTime() 
        t = myClock.getTime() + polyBduration
        while myClock.getTime() < t:
            pass #do nothing
##        pB = myClock.getTime() - pB
##        print 'pB', pB

         # PATTERN OFFSET
         
##        wt= myClock.getTime() - pA
##        print 'whole thing', wt
        cue('B',AttendFirst)
        line.draw()
        fix.draw()
        myWin.flip()

        t = myClock.getTime() + fixduration   
        while myClock.getTime() < t:
            pass #do nothing
            
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        line.draw()
        fix.draw()
#        RT = myClock.getTime()
#        
#        if fileName == 'practice':
#            respCorr, choice = responseCollect_Practice(Regularity, ResponseScreenVersion)
#        elif fileName == 'experiment':
#            respCorr, choice = responseCollect(Regularity, ResponseScreenVersion)
#            
#        RT= myClock.getTime() - RT
#        
#        
#        trials.addData('choice', choice)
#        trials.addData('respCorr', respCorr)
#        trials.addData('respTime',RT)
#        
#        
#    #save all data
#    trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'filenamexlsx', dataOut=['all_raw'])
#    trials.extraInfo =expInfo      
#    trials.saveAsWideText('data/'+filenametxt+'.txt')  
        
 

#trialbook='SldgOccl_Orig_NoOccl.xlsx' 
trialbook='SlidingOccluder2halves.xlsx' 
#message('HelloPractice')
#event.waitKeys('Space')
RunBlock(trialbook,'practice',1)
#message('HelloMain')
#event.waitKeys('Space')
#RunBlock(trialbook,'experiment', 30) # (240 trials: 2 conditions (4subconditions): 120 reps) . 
#message('Goodbye')
#event.waitKeys('Space')
myWin.close()
core.quit()