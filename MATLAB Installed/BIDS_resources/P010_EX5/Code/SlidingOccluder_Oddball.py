
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, gui,parallel #these are the psychopy libraries
import psychopy.logging #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *
import math
#import visualExtra
import sys
import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
from OpenGL import GLUT


parallel.setPortAddress(0x378)#address for parallel port on many machines
parallel.setData(0)
#
w=[1,1,1]
b=[-1,-1,-1]
r= [1,0,0]
dr=[0.,-1.,-1.]
dgy= [-.5,-.5,-.5]
lgy= [.5,.5,.5]
#

myClock = core.Clock()


expName='SlidingOccluder_Oddball'#from the Builder filename that created this script
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


#myWin = visual.Window(size=(800,800), monitor='testMonitor', units='pix')
myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True)


#
#size=40
#ndots =20
#sizeE= 40
#maxheight= 200
#maxwidth= 140
#

size=40
ndots =100
sizeE= 80
maxheight= 180
insideH=180
maxwidth= 100
insideW= 60
height = 140
width = 90
nstepsy= 12
nstepsx= 3
jump= 10
#

#vertex = (((-maxwidth -(sizeE/2) ), (-maxheight)), ((maxwidth +(sizeE/2)), (-maxheight)),((maxwidth +(sizeE/2)), (maxheight)), ((-maxwidth-(sizeE/2)), (maxheight))) 
#e= visual.Rect(myWin, width=sizeE, height=sizeE, lineColor=None, fillColor=[-1,-1,-1])
e=  visual.Circle(myWin,interpolate=True,radius = sizeE/5,lineColor=dgy, fillColor= dgy)
#basesquare= visual.ShapeStim(myWin, vertices = vertex, lineColor=b, fillColor=b, pos=(0,0))
fix=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=40, color=r, colorSpace='rgb', units= 'pix',font='Times New Roman')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0,90], height=30, color=w,  units= 'pix',font='Times New Roman')
#

#
x= -maxwidth -(sizeE)
y= maxheight +(sizeE)
vertOccl= ((x,-y), (0,-y), (0,y), (x,y))
#vertOccl= (((-maxwidth -(sizeE)), (-maxheight -(sizeE))), (0, (-maxheight -(sizeE))),(0, (maxheight + (sizeE))), (((-maxwidth -(sizeE))), (maxheight+ (sizeE)))) 
#Occl= visual.ShapeStim(myWin, vertices = vertOccl, lineColor=[1,-1.,-1.], fillColor=[0.,-1.,-1.], pos=(0,0))
Occl= visual.ShapeStim(myWin, lineColor=w, fillColor=w, pos=(0,0))#[0.,-1.,-1.]#
Occl.setVertices(vertOccl)
#Occluder= visual.ImageStim(myWin, image ='occluder.png', size= (180,520))
#

#
PolyL_IN=visual.ShapeStim(myWin, lineColor=None, fillColor=None)
PolyR_IN=visual.ShapeStim(myWin, lineColor=None, fillColor=None)
PolyL_OUT=visual.ShapeStim(myWin, lineColor=lgy, fillColor=None) # lineWidth=4
PolyR_OUT=visual.ShapeStim(myWin, lineColor=lgy, fillColor=None)
stim1 =visual.ShapeStim(myWin, lineColor=None, fillColor=None)
stim2 =visual.ShapeStim(myWin, lineColor=None, fillColor=None)
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
    #basesquare.draw()
    seed(seedNo)
    
    coords =[]
    coords.append([0,-height]) #1st coord
       
#    x= 0
#    stepx= width/nstepsx
#    for i in range(nstepsx-1):
#        x= x-stepx
#        y= -height + randint(-20,20)
#        coords.append([x,y]) 
        
    coords.append([-width, -height]) #2nd coord 
    
    y = -height
    stepy = (height*2)/nstepsy
    for i in range(nstepsy-1):
        y = y +stepy
        x = -width + randint(-40,40)
        coords.append([x,y]) #3rd to 11th coord
        
    coords.append([-width, height])#12th
    
#    x= -width
#    for i in range(nstepsx-1):
#        x= x+stepx
#        y= height + randint(-20,20)
#        coords.append([x,y])
        
    coords.append([0, height ])
    coords.append([0, -height])
    
    PolyL_IN.setVertices(coords)
    PolyL_OUT.setVertices(coords)


    if regularity=='ref':
        temp = []
        for i in range(len(coords)):
            temp.append([-coords[i][0],coords[i][1]])
        PolyR_IN.setVertices(temp)
        PolyR_OUT.setVertices(temp)
        
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
        
        PolyR_IN.setVertices(coords)
        PolyR_OUT.setVertices(coords)
    
    PolyL_OUT.size= PolyR_OUT.size= 1.1
#    PolyL_OUT.draw()
#    PolyR_OUT.draw()
#    PolyL_IN.draw()
#    PolyR_IN.draw()

def colorpolygon(color, OcclStartPos):
    left = PolyL_OUT.vertices
    right = PolyR_OUT.vertices
    
    color1= (0.5,0.5,0.5)   # grey
    color3 = (0.9,0.,0.)   # red
    color4 = (0.8,0.,0.)   # red
        
    flag = 0
    for i in range(nstepsy):
        s1= []
        s2= []
        s1.append(left[i+1])
        s1.append(left[i+2])
        s1.append([0,left[i+2][1]])
        s1.append([0,left[i+1][1]])
        stim1.vertices=s1
        stim1.size= 1.1
        if OcclStartPos == "right":
            stim1.setFillColor(color1)
#            if flag == 1:
#                stim1.setFillColor(color1)
#                #stim1.setLineColor(color1)
#                flag =0
#            else:
#                stim1.setFillColor(color1)
#                #stim1.setLineColor(color1)
#                flag =1
        elif OcclStartPos == "left":
            if color == 'gr': 
                stim1.setFillColor(color3)
#                if flag == 1:
#                    stim1.setFillColor(color3)
#                    #stim1.setLineColor(color3)
#                    flag =0
#                else:
#                    stim1.setFillColor(color4)
#                    #stim1.setLineColor(color4)
#                    flag =1
            elif color== 'gg':
                stim1.setFillColor(color1)
#                if flag == 1:
#                    stim1.setFillColor(color1)
#                    #stim1.setLineColor(color1)
#                    flag =0
#                else:
#                    stim1.setFillColor(color1)
#                    #stim1.setLineColor(color1)
#                    flag =1
        stim1.draw()
        
    flag = 0
    for i in range(nstepsy):
        s2= []
        s2.append(right[i+1])
        s2.append(right[i+2])
        s2.append([0,right[i+2][1]])
        s2.append([0,right[i+1][1]])
        stim1.vertices=s2
        stim1.size= 1.1
        if OcclStartPos == "left":
            stim1.setFillColor(color1)
#            if flag == 1:
#                stim1.setFillColor(color1)
#                flag =0
#            else:
#                stim1.setFillColor(color1)
#                flag =1
        elif OcclStartPos == "right":
            if color == 'gr':
                stim1.setFillColor(color3)
#                if flag == 1:
#                    stim1.setFillColor(color3)
#                    flag =0
#                else:
#                    stim1.setFillColor(color4)
#                    flag =1
            elif color== 'gg':
                stim1.setFillColor(color1)
#                if flag == 1:
#                    stim1.setFillColor(color1)
#                    flag =0
#                else:
#                    stim1.setFillColor(color1)
#                    flag =1
        stim1.draw()
        
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
            if PolyL_IN.contains(x,y) and PolyL_OUT.contains(x,y):
                if (memory[i]== 1): 
                    rad=randint(4,12)
                    ecoord.append([x,y])
                    erad.append([rad])
                    e.setPos([x,y])  
                    e.setRadius([rad])
                    e.draw()
                i= i+1
#
    if regularity=='ref':
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
                if PolyR_IN.contains(x,y):
                    if (memory[i]== 1): 
                        rad=randint(4,12)
                        e.setPos([x,y])  
                        e.setRadius([rad])
                        e.draw()
                    i= i+1
                    
def shapescreenshot(regularity,color, OcclStartPos, seedNo):
    global screenshot
    preparepolygon(regularity, seedNo)
    colorpolygon(color,OcclStartPos)
    insidepolygon(regularity, seedNo)
    screenshot = visual.BufferImageStim(myWin, rect=(-.6, .6, .6, -.6))

def drawOccluder(shiftPos, OcclStartPos):
    yPos= 0
    if OcclStartPos == 'left':
        xPos=0
        Occl.setPos((xPos,yPos),"")
    if OcclStartPos == 'right':
        Occl.setPos((shiftPos,yPos),"")
        
    Occl.draw()
    fix.draw()

def moveOccluder(shiftPos, speedOccl,OcclStartPos):
    OcclClock = core.Clock()
    yPos = 0
    if OcclStartPos == 'left':
        xPos = 0
        OcclClock.reset(); t = 0
#        ck = OcclClock.getTime()
        while xPos < shiftPos:
            xPos = xPos + speedOccl
            Occl.setPos((xPos,yPos),"")
            #shapescreenshot(regularity, seedNo)
            screenshot.draw()
            Occl.draw()
            fix.draw()
            myWin.flip()
#        ck=  OcclClock.getTime() - ck
#        print ck
        
    elif OcclStartPos == 'right':
        xPos = shiftPos
        OcclClock.reset(); t = 0
#        ck = OcclClock.getTime()
        while xPos > 0:
            xPos = xPos - speedOccl
            Occl.setPos((xPos,yPos),"")
            #shapescreenshot(regularity, seedNo)
            screenshot.draw()
            Occl.draw()
            fix.draw()
            myWin.flip()
#        ck=  OcclClock.getTime() - ck
#        print ck
def responseCollect(color,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Same      Different')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'Same'
            if color== 'gr':
                respCorr = 0
            elif color== 'gg':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'Different'
            if color== 'gr':
                respCorr = 1
            elif color== 'gg':
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Different      Same')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Same'
            if color== 'gr':
                respCorr = 0
            elif color== 'gg':
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'Different'
            if color== 'gr':
                respCorr = 1
            elif color== 'gg':
                respCorr = 0
    return respCorr, choice

def RunBlock(trialbook, Reps):
    parallel.setData(0)
    myClock= core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    trialCounter = 0
    blockCounter = 0
    fixduration = uniform(.2,.5)
    baselineduration= 1.5
    shiftPos= speedOccl= 181
    nBlocksToGo = 8
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
        
        shapescreenshot(regularity,color,OcclStartPos, seedNo)
        drawOccluder(shiftPos, OcclStartPos)
        
        t = myClock.getTime() + baselineduration    
        while myClock.getTime() < t:
            pass #do nothing
            
        #PATTERN ONSET
        
        parallel.setData(trigger)
        myWin.flip()
        parallel.setData(0)
        
#        wt= myClock.getTime() 
        t =   myClock.getTime() + FirstHalfduration
        while myClock.getTime() < t:
            pass #do nothing
#        f = myClock.getTime() - wt
#        print 'fh', f
        
        moveOccluder(shiftPos, speedOccl,OcclStartPos)
        
#        s = myClock.getTime()
        t = myClock.getTime() + SecondHalfduration
        while myClock.getTime() < t:
            pass #do nothing
#        s = myClock.getTime() - s
#        print 'sh', s

         # PATTERN OFFSET
         
#        wt= myClock.getTime() - wt
#        print 'whole thing', wt
        
        fixation()
        Occl.draw()
        #Occluder.draw()
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
        respCorr, choice = responseCollect(color, ResponseScreenVersion)
        RT= myClock.getTime() - RT
        
        trials.addData('respChoice',choice)
        trials.addData('respCorr',respCorr)
        trials.addData('respTime',RT)
    #save all data
    trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'filenamexlsx', dataOut=['all_raw'])
    trials.extraInfo =expInfo      
    trials.saveAsWideText('data/'+filenametxt+'.txt')  
        


trialbook1='SldgOccl_Oddball.xlsx' 
message('HelloPractice')
event.waitKeys('Space')
RunBlock(trialbook1, 1)
message('HelloMain')
event.waitKeys('Space')
RunBlock(trialbook1, 8) # (320 trials: 64 oddballs + 256 good ones). 
message('Goodbye')
event.waitKeys('Space')
