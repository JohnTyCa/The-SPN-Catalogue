from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui,tools#, parallel
from pyglet.gl import * #a graphic library
import visualExtra, math, copy
import sys
import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
from OpenGL import GLUT
# 1920 = 51 cm screen
# 2146 = how many pixels back the participant is at 57 cm.
# 4292 is twice this 
#
backgroundColor = [0.071,0.071,0.071]
myWin = visual.Window(size = [4292,4292],monitor = 'slantTestMonitor', allowGUI=False, units = 'pix', fullscr= False, color = backgroundColor)

# objects for gabor stim

# parameters for gabor patterns
centralEx = 0 # how many cells on the left and right of the axis do we want to exclude elements from?
unitSize = 12.5
gridSize = 20
dotSize = 12.5
pOcc = 0.5
jitter = 0

# global gabor parameters derived
nCells=gridSize*gridSize
stimSize = unitSize*gridSize
nOcc = int(nCells*pOcc)
nEmpty = int(nCells-nOcc)
cellOcc = []
whichEmpty = zeros(nEmpty)
whichOcc =ones(nOcc)
cellOcc = append(whichEmpty,whichOcc)
frame = visual.Rect(myWin, width = 250, height=250,lineWidth = 1,lineColor=[-1,-1,-1], fillColor=None)

cell = visual.Rect(myWin, width=unitSize, height=unitSize, lineColor=[-1,-1,-1], fillColor=None,interpolate = True)
myTexture = zeros([4,4])+1
gabor= visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize],color = [-1,-1,-1])
fixation = visual.Circle(myWin, radius = 2.5, interpolate=True, fillColor= 'red', lineColor = 'red')

# draw 2D dot patterns
def rot90Gabors(jitter,grid,color):
    frame.draw()
    gabor.setColor(color)
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([xPos,-yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,-yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
                gabor.setPos([ePosY,-ePosX])
                gabor.draw()
                gabor.setPos([-ePosX,-ePosY])
                gabor.draw()
                gabor.setPos([-ePosY,ePosX])
                gabor.draw()
            c=c+1
        
    xPos = (maxx/2)+(unitSize/2)
    c = 0

def rot180Gabors(jitter,grid,color):  
    frame.draw()
    gabor.setColor(color)
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setPos([ePosX,-ePosY])
                gabor.draw()
                gabor.setPos([-ePosX,ePosY])
                gabor.draw()
            c=c+1

    gabor.setColor(color)
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([xPos,-yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,-yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                ePosX,ePosY=rotateCoords(ePosX, ePosY, radians(angle))
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
#                gabor.setPos([-ePosX,ePosY])
#                gabor.draw()
                gabor.setPos([ePosX,-ePosY])
                gabor.draw()
#                gabor.setPos([-ePosX,-ePosY])
#                gabor.draw()
            c=c+1

def refHGabors(jitter,grid,color):
    frame.draw()
    gabor.setColor(color)
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(gridSize):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
                gabor.setPos([ePosX,-ePosY])
                gabor.draw()
            c=c+1

def refVGabors(jitter,grid,color):
    frame.draw()
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:

                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
                gabor.setPos([-ePosX,ePosY])
                gabor.draw()
            c=c+1

def repetitionGabors(jitter,grid,color):
    frame.draw()
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
            c=c+1


    xPos = -unitSize/2 + centralEx*unitSize
    
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
            c=c+1

def randGabors(jitter,grid,color):
    frame.draw()
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
            c=c+1


    xPos = -unitSize/2 + centralEx*unitSize
    shuffle(cellOcc)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(gridSize-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
            c=c+1
            
            
            
            

def randHVgabors(jitter,grid,color):

    frame.draw()
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
            c=c+1

    c = 0
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([-ePosX,ePosY])
                gabor.draw()
            c=c+1

    c = 0
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,-yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([ePosX,-ePosY])
                gabor.draw()
            c=c+1
    c = 0
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([-xPos,-yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setColor(color)
                gabor.setPos([-ePosX,-ePosY])
                gabor.draw()
            c=c+1
#randHVgabors(jitter,'off',(1,1,1))
#myWin.flip()
#core.wait(3)
#myWin.close()
#core.quit()

def refHVgabors(jitter,grid,color):
    frame.draw()
    gabor.setColor(color)
    maxx =unitSize*gridSize
    maxy =unitSize*gridSize
    shuffle(cellOcc)
    xPos = -(maxx/2)-(unitSize/2)
    c = 0
    for x in range(int(gridSize/2)-centralEx):
        xPos = xPos+unitSize
        yPos = -(maxy/2)-(unitSize/2)
        for y in range(int(gridSize/2)-centralEx):
            yPos = yPos+unitSize
            if grid == 'on':
                cell.setPos([xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([xPos,-yPos]) # if we want the grid on
                cell.draw()
                cell.setPos([-xPos,-yPos]) # if we want the grid on
                cell.draw()
            ePosX = xPos+uniform(-jitter,jitter)
            ePosY = yPos+uniform(-jitter,jitter)
            if cellOcc[c] == 1:
                gabor.setPos([ePosX,ePosY])
                gabor.draw()
                gabor.setPos([-ePosX,ePosY])
                gabor.draw()
                gabor.setPos([ePosX,-ePosY])
                gabor.draw()
                gabor.setPos([-ePosX,-ePosY])
                gabor.draw()
            c=c+1
            



# here we go with trials

Reg = 'Ref'
Color = 'Black'
viewAngleX = 60
viewAngleY = 15
repeats = 16
duration = 0.1

for p in range(repeats):
    n = p+1
    if Color == 'Black':
        gC = -1
    elif Color == 'White':
        gC = 0.5
    #ref1F([0,0],'low')
    #rot90(jitter,'on',(-1,-1,-1))
    if Reg == 'Rand':
        randHVgabors(jitter,'off',(gC,gC,gC))
    elif Reg == 'Ref':
        refHVgabors(jitter,'off',(gC,gC,gC))
    myWin.flip()
    core.wait(duration)
    myWin.getMovieFrame()
    myWin.flip()
    n= "%s%s%s%s" %(Reg,Color,n,'.png')
    myWin.saveMovieFrames(n)



myWin.close()

# here we go with slanting
 #size parameters set her overwhelm everything in the monitor center
myWin = visual.Window(size = [4292,4292],monitor = 'slantTestMonitor', allowGUI=False, units = 'pix', fullscr= False, color = backgroundColor)
s = visual.ImageStim(myWin, size = [4292, 4292], mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0),colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128)


 #global parameters to play with
eyeTransform = 1 # do we want to apply transform?

def eyeCoords(viewAngleX,viewAngleY):
    x1 = sin(radians(viewAngleX))  # longitude
    x2 = cos(radians(viewAngleY))  # latitude
    x = x1*x2
    y = sin(radians(viewAngleY)) # latitude
    z1 = cos(radians(viewAngleX))  # longitude
    z2 = cos(radians(viewAngleY))   # latitude
    z = z1*z2
    return(x,y,z)


# slant parameters

eyePosScale = 1 # how many half-windows back is the eye? Advantage of havign this at 1 is that 0 slant gives the same image as untransformed window. 
scrDist = 1.0
scrWidth = 2.0
scrAspect = 1.0 # the geometry is more intuitive when the screen is square
eyeOffset = (0.0, 0.0)  # +/- IOD / 2.0
screenPos = [0.0,0.0,0.0]
eyeUp = [0.0, 1.0, 0.0]  # this means 'y' is up (default)
frustum = tools.viewtools.computeFrustum(scrWidth,scrAspect,scrDist)
myWin.projectionMatrix = tools.viewtools.perspectiveProjectionMatrix(*frustum)

# here we go with trials
for p in range(repeats):
    x,y,z = eyeCoords(viewAngleX,viewAngleY)

     #midline preservation
    eyePos = [x*eyePosScale,y*eyePosScale,z*eyePosScale] # this is in units of Windows
    print(eyePos)
    myWin.viewMatrix = tools.viewtools.lookAt(eyePos, screenPos, eyeUp)

    if eyeTransform == 1:
        myWin.applyEyeTransform()
    q = p+1
    n= "%s%s%s%s" %(Reg,Color,q,'.png')
    s.setImage(n)
    s.draw()
    myWin.flip()
    myWin.getMovieFrame()

    n= "%s%s%s%s%s%s%s" %('T',Reg,Color,viewAngleX,viewAngleY,q,'.png')
    myWin.saveMovieFrames(n)

# here we go with cropping
myWin.close()
myWin = visual.Window(size = [500,500],monitor = 'slantTestMonitor', allowGUI=False, units = 'pix', fullscr= False, color = backgroundColor)
s = visual.ImageStim(myWin, size = [4292, 4292], mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128)

for p in range(repeats):
    q = p+1
    n= "%s%s%s%s%s%s%s" %('T',Reg,Color,viewAngleX,viewAngleY,q,'.png')
    s.setImage(n)
    s.draw()
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s%s%s%s%s" %('TC',Reg,Color,viewAngleX,viewAngleY,q,'.png')
    myWin.saveMovieFrames(n)

myWin.close()
core.quit()

#
#
#
#
#
#
##