from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui,tools#, parallel
from pyglet.gl import * #a graphic library
import visualExtra, math, copy
import sys
import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
from OpenGL import GLUT


backgroundColor = [0.071,0.071,0.071]

myWin = visual.Window(size = [4292,4292],monitor = 'slantTestMonitor', allowGUI=False, units = 'pix', fullscr= False, color = backgroundColor)  # [1280,1024])#creates a window using pixels as units
frame = visual.Rect(myWin, width = 250, height=250,lineWidth = 1,lineColor=[-1,-1,-1], fillColor=None)

# here we go with trials

viewAngleX = 0
viewAngleY = 0



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


x,y,z = eyeCoords(viewAngleX,viewAngleY)

eyePos = [x*eyePosScale,y*eyePosScale,z*eyePosScale] # this is in units of Windows
print(eyePos)
myWin.viewMatrix = tools.viewtools.lookAt(eyePos, screenPos, eyeUp)
if eyeTransform == 1:
    myWin.applyEyeTransform()
frame.draw()
myWin.flip()
myWin.getMovieFrame()
n = 'Tframe.png'
myWin.saveMovieFrames(n)
myWin.close()

# here we go with cropping
myWin = visual.Window(size = [500,500],monitor = 'slantTestMonitor', allowGUI=False, units = 'pix', fullscr= False, color = backgroundColor)
s = visual.ImageStim(myWin, size = [4292, 4292], image = 'Tframe.png', mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128)
s.draw()
myWin.flip()
myWin.getMovieFrame()
n= "%s%s%s" %(viewAngleX,viewAngleY,'frame.png')
myWin.saveMovieFrames(n)
myWin.close()
core.quit()



