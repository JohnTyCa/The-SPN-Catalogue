from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, visual, data, event,  gui#these are the psychopy libraries
from pyglet.gl import * #a graphic library
import math


maxIncrement = 50
minIncrement = 10

xDim = 20 # number of cells on the grid
yDim = 22 #  number of y cells on the grid

elementSize = 10# size of each dot
color1 = 'black'
color2 = 'white'

myWin = visual.Window(size = [800,800], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color='grey')
fixation = visual.TextStim(myWin, ori=0,text = '+', pos=[0, 1], height=30, color='red', units= 'pix')
centerLineV = visual.Line(myWin, start=(0, -500), end=(0, 500))
centerLineH = visual.Line(myWin, start=(-1000, 0), end=(1000,0))
#e =  visual.GratingStim(myWin, tex='sin', mask='gauss', size = [elementSize,elementSize], units = 'pix')
e = visual.Circle(myWin,interpolate=True,radius = elementSize/2,lineColor = 'grey')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', units= 'pix')

def scaling(control, minIncrement,maxIncrement,nPerHalf): # This scales the size of the cells, the number of cells never changes (i.e. 400)
    if control == 'sizeFixed':
        increment = sqrt(minIncrement*maxIncrement) 
    elif control == 'densityFixed':
        increment = sqrt(minIncrement*nPerHalf) # This is the key formula. It means cell size is linked to the number of dots
    xIncrement = increment # size of each cell
    yIncrement = increment # size of each cell
    return xIncrement,yIncrement
    

def Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf): # Lets build the right hand side
    nPlaces = xDim/2*yDim
    a = zeros([nPlaces-nPerHalf,1])
    b = ones([nPerHalf,1])
    c = append(a,b)
    shuffle(c)
    template = zeros([nPlaces,4])
    p = 0
    cCount = 0
    #xPos = (xIncrement/2)+xIncrement
    xPos = xIncrement# There are to be no dots on the midline
    for x in range (xDim/2):
        yPos = -((yDim/2)*yIncrement)+(yIncrement/2)
        for y in range (yDim):
            template [p,0] = xPos
            template [p,1] = yPos
            template[p,2] = c[p]
            if c[p] == 1: # This gambit fixes it so every other dot is white
                if (cCount% 2 == 0):
                    template[p,3] = 1
                cCount = cCount+1
            p = p+1
            yPos = yPos+yIncrement
        xPos = xPos + xIncrement
    #print template
    return template
    

def patternDraw(type,xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf):
    if type == 'translation':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        translate = ((xDim/2)*xIncrement)+xIncrement
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                xPos = xPos-translate
                e.setPos([xPos,yPos])
                e.draw()
    elif type == 'reflection':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
                e.setPos([-xPos,yPos])
                e.draw()
    elif type == 'random':
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
        template = Segment(xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        translate = ((xDim/2)*xIncrement)+xIncrement
        for p in range (len(template)):
            if template[p,2] == 1:
                e.setFillColor(color1)
                if template[p,3] == 1:
                      e.setFillColor(color2)
                xPos = template[p,0]-translate
                yPos = template[p,1]
                e.setPos([xPos,yPos])
                e.draw()
#    centerLineV.draw()
#    centerLineH.draw()

    

def runBlock(trialbook,Reps):

    trialCounter = 0
    myClock = core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='sequential', trialList=data.importConditions(trialbook))

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting
        xIncrement,yIncrement = scaling(control, minIncrement,maxIncrement,nPerHalf)
        patternDraw(Type,xDim, yDim, xIncrement, yIncrement, elementSize,nPerHalf)
        myWin.flip()
        myWin.getMovieFrame()
        core.wait(0.3)
        myWin.flip()

event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1)
myWin.saveMovieFrames('image.png')
myWin.close
core.quit()
