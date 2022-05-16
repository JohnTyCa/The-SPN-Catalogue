# this is Yiovi's memory SPN experiment
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui, parallel
from pyglet.gl import * #a graphic library
import math
import visualExtra

parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)
expName='Passive Shape'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'passiveShapeData/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('passiveShapeData'):
    os.makedirs('passiveShapeData')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'deg', fullscr= True, color=(-1, -1, -1))
myClock = core.Clock()
fixationSize = 0.5

axes = 4
ndots = 64
dotSize = 17
orientation = 0
radius = 63 # 1.75 raidus =  3.5 diameter degrees wide. This is very slightly different to the upstairs monitor. But I would rather preserve the proportions than match the size exactly
minimumDist = 5.3
gap = 3


# duration parameters
firstBaselineDuration = 1 # blank grey disk
standardDuration = 0.5 # standard shapes
secondBaselineDuration = 0.75 # grey before symm/rand
patternDuration = 0.75 # pattern
testDuration = 1


fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'red')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'red')
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=0.5, color='white', colorSpace='rgb')

# global parameters for memory
eSize = 0.5 # size does not work intuitively for a square
j = 0 # parameters of the jitter range. We don't want squares falling onto an obvious grid. 
gridWidth = 2
gridHeight = 2
cellSize=1.5
nColors = 7
#color1 = 'blue'
#color2 = 'purple'
#color3 = 'black'
#color4 = 'orange'
#color5 = 'cyan'
#color6 = 'white'
#color7 = 'green'


S1a = visual.Rect(myWin, height = eSize*1.5, width = eSize/1.5,fillColor= 'black', lineColor = 'black',lineWidth = 1) # cross
S1b = visual.Rect(myWin, height = eSize/1.5, width = eSize*1.5,fillColor= 'black', lineColor = 'black',lineWidth = 1) # cross
S2a = visual.Polygon(myWin, size = eSize*2, edges = 3,fillColor= 'black', lineColor = 'black',lineWidth = 1) # star
S2b = visual.Polygon(myWin, size = eSize*2, edges = 3,ori = 180,fillColor= 'black', lineColor = 'black',lineWidth = 1) # star

S3 = visual.Polygon(myWin, size = eSize*2, edges = 3,ori = 0,fillColor= 'black', lineColor = 'black',lineWidth = 1) # triangle
S4 = visual.Polygon(myWin, size = eSize*2, edges = 4,fillColor= 'black', lineColor = 'black',lineWidth = 1) # diamond
#S5 = visual.Polygon(myWin,size = eSize*2, edges = 5,fillColor= 'black', lineColor = 'black',lineWidth = 1) # pentagon
#S5 = visual.Polygon(myWin,size = eSize*1.8, edges = 6,fillColor= 'black', lineColor = 'black ',lineWidth = 1) # hexagon
S5a = visual.Circle(myWin, radius = eSize/1.2,fillColor= 'black', lineColor = 'black',lineWidth = 1) # moon
S5b = visual.Circle(myWin, radius = eSize/1.2,fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2],lineWidth = 1) # moon

S6a = visual.Circle(myWin, radius = eSize/2, pos =[0,eSize/2.5],fillColor= 'black', lineColor = 'black',lineWidth = 1) # cloud
S6b = visual.Circle(myWin, radius = eSize/2,pos =[eSize/2.5,-eSize/2],fillColor= 'black', lineColor = 'black',lineWidth = 1) # cloud
S6c = visual.Circle(myWin, radius = eSize/2,pos =[-eSize/2.5,-eSize/2],fillColor= 'black', lineColor = 'black',lineWidth = 1) # cloud
#S6d = visual.Circle(myWin, radius = eSize/5,pos =[0,0],fillColor= 'black', lineColor = 'black',lineWidth = 1) # disk
S7 = visual.Circle(myWin, radius = eSize/1.2,fillColor= 'black', lineColor = 'black',lineWidth = 1) # circle


border =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')
border2 =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')


nCells = gridWidth*gridHeight # how many positions?. This equals p and length(gridSetup)




line1 =visual.Line(myWin, start=[-340,0], end=[340,0], lineWidth=1, lineColor='black')
myTexture = zeros([4,4])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
myTexture = zeros([4,4])+1
gaborWhite = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
gaborRed = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(.8,-1,-1), units='pix', size=[dotSize,dotSize])
gaborPink = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(0.4,-0.6,-0.6), units='pix', size=[dotSize,dotSize])
gaborLightGreen= visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,0.5,-1), units='pix', size=[dotSize,dotSize])
gaborDarkGreen = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-0.2,-1), units='pix', size=[dotSize,dotSize])
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-1,-1), units='pix', size=[dotSize,dotSize])
circularRegion =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')




def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of shapes. Your task is to decide whether the shapes are the same in the first and second presentation. Please fixate on the red cross')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, it is the same, but much longer. Try not to blink and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(border2Color,responseScreenVersion):

    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('RED Border              BLUE Border')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'Red'

            if border2Color == 'blue':

                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['l']: 
            choice = 'Blue'

            if border2Color == 'blue':
                respCorr = 1

            else:
                respCorr = 0
           
    elif responseScreenVersion == 2:
        responseScreen.setText('BLUE Border          RED Border') 
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'Red'
            if border2Color == 'blue':
           
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'Blue'
            if border2Color == 'blue':
                respCorr = 1
            else:
                respCorr = 0
    return respCorr, choice
    
def eDrop(arraySize):
    a=zeros([nCells]) 
    for x  in range(arraySize):
        a[x] = 1
    shuffle(a)
    return a


def alloChange(arraySize):
    d = zeros([arraySize])
    d[0] = 1
    shuffle(d)
#    print d
    return d
    

def gridSetup(arraySize):
    gCoords = zeros([nCells,4])
    xPos = -(gridWidth*cellSize)/2-(cellSize/2)
    p = 0
    q = 0
    cn = 0
    a = eDrop(arraySize) # which cells are gonna be populated
#    c = colChoose(nColors)
    cOrder = [1,2,3,4,5,6,7] # This is a bit 'magic numbers'
    shuffle(cOrder)
    usedC = cOrder[0:arraySize]
    unusedC = cOrder[arraySize:nColors]
    for x in range(gridWidth):
        xPos = xPos+cellSize
        yPos = -(gridHeight*cellSize)/2-(cellSize/2)
        for y in range(gridHeight):
            yPos = yPos+cellSize
            gCoords[p,0] = a[p] # are we having an element at this location?
            jitter = uniform(-j,+j)
            gCoords[p,1] = xPos+jitter
            jitter = uniform(-j,+j)
            gCoords[p,2] = yPos+jitter
            gCoords[p,3] = randint(1,nColors+1)# if we are having an element, what color is it going to be?
            if a[p] == 1:
                gCoords[p,3] = usedC[cn]
                cn=cn+1
            p = p+1
            #    print gCoords
    return gCoords,unusedC
   
def standardDraw(gCoords):
    for i in range(nCells):
        if gCoords[i,0] == 1: # if we are having a square
            if gCoords[i,3] == 1:
                S1a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S1b.setPos([gCoords[i,1] ,gCoords[i,2]])
                S1a.draw()
                S1b.draw()
            elif gCoords[i,3] == 2:
                S2a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S2b.setPos([gCoords[i,1] ,gCoords[i,2]])
                S2a.draw()
                S2b.draw()
            elif gCoords[i,3] == 3:
                S3.setPos([gCoords[i,1] ,gCoords[i,2]-eSize/3])
                S3.draw()
            elif gCoords[i,3] == 4:
                S4.setPos([gCoords[i,1] ,gCoords[i,2]])
                S4.draw()
            elif gCoords[i,3] == 5:
                S5a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S5b.setPos([gCoords[i,1]+eSize ,gCoords[i,2]])
                S5a.draw()
                S5b.draw()
            elif gCoords[i,3] == 6:
#S6a = visual.Circle(myWin, radius = eSize/2, pos =[0,eSize/2.5],fillColor= 'black', lineColor = 'black',lineWidth = 1) # disk
#S6b = visual.Circle(myWin, radius = eSize/2,pos =[eSize/2.5,-eSize/2],fillColor= 'black', lineColor = 'black',lineWidth = 1) # disk
#S6c = visual.Circle(myWin, radius = eSize/2,pos =[-eSize/2.5,-eSize/2],fillColor= 'black', lineColor = 'black',lineWidth = 1) # disk
#S6d = visual.Circle(myWin, radius = eSize/5,pos =[0,0],fillColor= 'black', lineColor = 'black',lineWidth = 1) # disk
#
                S6a.setPos([gCoords[i,1], gCoords[i,2]+eSize/2.5])
                S6b.setPos([gCoords[i,1]+eSize/2.5, gCoords[i,2]-eSize/2])
                S6c.setPos([gCoords[i,1]-eSize/2.5, gCoords[i,2]-eSize/2])
                S6a.draw()
                S6b.draw()
                S6c.draw()
            elif gCoords[i,3] == 7:
                S7.setPos([gCoords[i,1] ,gCoords[i,2]])
                S7.draw()
#            e.setPos([gCoords[i,1] ,gCoords[i,2]])
#            e.draw()

def testDraw(gCoords,change,arraySize,unusedC):
    d = alloChange(arraySize) # choose a square which can potentially be changed
    q = 0
    for i in range(nCells):
        if gCoords[i,0] == 1: # if we are having a square
            
            if d[q] == 1 and change == 1:
#                oldColor = gCoords[i,3]
#                newColor = oldColor
#                while newColor == oldColor:
#                    newColor = randint(1,nColors+1) # choose an alternative color 
#                gCoords[i,3] = newColor
                gCoords[i,3] = unusedC[0]
            
            if gCoords[i,3] == 1:
                S1a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S1b.setPos([gCoords[i,1] ,gCoords[i,2]])
                S1a.draw()
                S1b.draw()
            elif gCoords[i,3] == 2:
                S2a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S2b.setPos([gCoords[i,1] ,gCoords[i,2]])
                S2a.draw()
                S2b.draw()
            elif gCoords[i,3] == 3:
                S3.setPos([gCoords[i,1] ,gCoords[i,2]-eSize/3])
                S3.draw()
            elif gCoords[i,3] == 4:
                S4.setPos([gCoords[i,1] ,gCoords[i,2]])
                S4.draw()
            elif gCoords[i,3] == 5:
                S5a.setPos([gCoords[i,1] ,gCoords[i,2]])
                S5b.setPos([gCoords[i,1]+eSize,gCoords[i,2]])
                S5a.draw()
                S5b.draw()
            elif gCoords[i,3] == 6:
                S6a.setPos([gCoords[i,1], gCoords[i,2]+eSize/2.5])
                S6b.setPos([gCoords[i,1]+eSize/2.5, gCoords[i,2]-eSize/2])
                S6c.setPos([gCoords[i,1]-eSize/2.5, gCoords[i,2]-eSize/2])
                S6a.draw()
                S6b.draw()
                S6c.draw()
            elif gCoords[i,3] == 7:
                S7.setPos([gCoords[i,1] ,gCoords[i,2]])
                S7.draw()
            q=q+1
            

def generateOriPhases(n=10, symmetry='r'):
    orientations =[]
    phases =[]
    for i in range(n):
            orientations.append(random.randint(0,180))
            phases.append(0.25)
    return orientations, phases


# draw the stimuli
def drawingShape(stimulus, orientation, colour, cx, cy):

    v1 = [visualExtra.polar2cartesian(i[0],i[1]) for i in stimulus]    # get cartesian coordinates
    v = [[x+cx,y+cy] for [x,y] in v1]
#    v2 = [visualExtra.rotateVertex(vertex=i, a=orientation) for i in v1]  
#    v = visualExtra.rotateVertices(vertices=v1, a=-orientation) # rotate the pattern
    
    if colour =='red':
        for i in v:
            gaborRed.setPos(i)
            gaborRed.draw()
    elif colour =='pink':
        for i in v:
            gaborPink.setPos(i)
            gaborPink.draw()
    elif colour == 'lightGreen':
            for i in v:
                gaborLightGreen.setPos(i)
                gaborLightGreen.draw()
    elif colour == 'darkGreen':
            for i in v:
                gaborDarkGreen.setPos(i)
                gaborDarkGreen.draw()
    elif colour == 'black':
            for i in v:
                gaborBlack.setPos(i)
                gaborBlack.draw()
                




def generateStimulus(symmetry, axes, n, minimumDist, gap, propNoise, radius):
    nyes =(n* (1.0-propNoise)) *1.0
    nno  =(n * propNoise) * 1.0
#    print symmetry, axes, n, minimumDist, gap, propNoise, radius, nyes, nno
    if symmetry =='no' or propNoise==0:
        fullStim =visualExtra.generateSymmetry(symmetry=symmetry, axes=int(axes), ndots=n, radius=radius, minDist=minimumDist, gapAxis=gap)
        return fullStim
    elif symmetry =='r':
        target = visualExtra.generateSymmetry(symmetry=symmetry, axes=axes, ndots=nyes, radius=radius, minDist=minimumDist, gapAxis=gap)
        asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)
        #this loop is necessary to make sure target and noise elements do not overlap
        overlap =visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)
        t = myClock.getTime()
        while  overlap == True:
             asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)
             overlap = visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)
#             if (myClock.getTime() - t) >15:
#                return target
#    print 'sizes:', len(target), len(asy)
    return target + asy
    

def runBlock(trialbook,Reps):
    blockDuration = 8
    nBlocksToGo = Reps
    trialCounter = 0
    
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1

        if patternType == 'random':
            symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
            propNoise = 1
        elif patternType == 'symmetry':
            symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random
            propNoise = 0
            
        border.draw()
        fixation1.draw()
        fixation2.draw()
        myWin.flip() # flip on first baseline (black square border)
        w = myClock.getTime() + firstBaselineDuration
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
        gCoords,unusedC= gridSetup(arraySize)
        memCoords =gCoords
        border.draw()
        standardDraw(gCoords)
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # background square border on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        myWin.flip()  # flip on the standard colored squares
        w = myClock.getTime() + standardDuration
        parallel.setData(trigger+100)
        core.wait(0.01)
        parallel.setData(0)
        circularRegion.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # standard colored squares on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        myWin.flip() # flip on the second baseline (white circle)
        w = myClock.getTime() + secondBaselineDuration
        circularRegion.draw()
        drawingShape(stimulus, orientation,'black',0,0)   # this is the first type of noise approach target+random
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # second baseline on (white circle)
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        myWin.flip() # flip on the actual pattern
        # symmetry/random trigger here
        w = myClock.getTime() + patternDuration
        parallel.setData(trigger)
        core.wait(0.01)
        parallel.setData(0)
        border2.setLineColor(border2Color)
        border2.draw()
        testDraw(memCoords,change,arraySize,unusedC)
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass # pattern on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        myWin.flip() # flip on test colored squares
        
        w = myClock.getTime() + testDuration
        parallel.setData(trigger+200)
        core.wait(0.01)
        parallel.setData(0)
        while myClock.getTime() < w:
            pass # test colored squares on
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        # get the response
        respCorr, choice = responseCollect(border2Color, responseScreenVersion)
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbookPassiveShape.xlsx',1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
runBlock('trialbookPassiveShape.xlsx',15) #15x8 = 120 trials
message('Goodbye')
core.wait(2)
myWin.close
core.quit()