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

radius = 90  # pixels These values are actually coming from the trialbook and overwritten
angle = 10  # degree
jigger = 30  # pixels
form = 'angular'
orientation = 0

#these lines are very powerful, they create all stimuli using the special functions of psychopy
dot = visual.Circle(myWin, radius=6, lineColor='red', edges=12)
stim1 = visual.ShapeStim(myWin, lineWidth=2, lineColor=[0.,0.,0.], vertices=[[0,0],[0,0]], fillColor=None, closeShape=True, interpolate=True, autoLog=False)
stim2 = visual.ShapeStim(myWin, lineWidth=2, lineColor=[0.,0.,0.], vertices=[[0,0],[0,0]], fillColor=None, closeShape=True, interpolate=True, autoLog=False)
marker = visual.Rect(myWin, units='height', width=.003, height=.003, fillColor='red', lineColor=None)
marker2 = visual.Rect(myWin, units='height', width=.004, height=.004, fillColor='green', lineColor=None)
linea=visual.Line(myWin,  start=[-150,0], end=[150,0])

frame = visual.Rect(myWin, width = 250, height=250,lineWidth = 1,lineColor=[-1,-1,-1], fillColor=None)

def fillColour(ver= [], colour =[]):
    
    s =  visual.ShapeStim(myWin, lineColor=None, fillColor=colour, closeShape=True, autoLog=False)
    
    v = []
    for i in range(0, len(ver)-1):   # this is to fill in the shape with a solid colour
        v=ver[i:i+2]
        v.append([0,0])
        s.setVertices(v)
        s.draw()

#def pick_coord_random():
#    
#    area =0
#    convexn =0
#    nsteps = int(360 /angle)  # 36
#    naxes =2  # debug
#    maxArea = (radius + jigger)**2 * math.pi
#    minArea = (radius -jigger)**2 * math.pi
#
#    # this check at present accepts any area because it only checks that the value is within the absolute min and the absolute max 
#    while area <minArea or area>maxArea or (convexn != 20):
#        ver =[]
#        a = -90
#                
#        for i in range(nsteps):
#            newradius = radius + randint(-jigger,jigger)
#            x = newradius * cos( radians(a))
#            y = newradius * sin( radians(a))
#            ver.append([x,y])
#            a = a + angle
#                        
#        peri =visualExtra.computePerimeter(ver)
#        convex, concave =visualExtra.computeAngles(ver)
#        area =visualExtra.gaussarea(ver)
#        convexn =len(convex)
#        print(peri, convexn, area)
#
#    return ver
    
def pick_coords(naxes):
    area =0
    convexn =0
    nsteps = int(360 /angle)  # 36
    noise =[]
    for i in range(nsteps):
        noise.append(randint(-3,3))
    maxArea = (radius + jigger)**2 * math.pi
    minArea = (radius -jigger)**2 * math.pi

    # this check at present accepts any area because it only checks that the value is within the absolute min and the absolute max 
    while area <minArea or area>maxArea or (convexn != 20):
        ver =[]
        a = -90
        
        for i in range(nsteps):
            newradius = radius + randint(-jigger,jigger)
            x = newradius * cos( radians(a))
            y = newradius * sin( radians(a))
            ver.append([x,y])
            a = a + angle

        ver.append(ver[0])  # add location 36


#        
        if naxes ==2:
            nstepsQuad =int(nsteps /(naxes*2))  # 9  
            for i,j in zip(range(nstepsQuad+1), range(36, 26, -1)):
                ver[ j][0] = -ver[i][0]
                ver[ j][1] = ver[i][1]

            for i,j in zip(range(nstepsQuad+1), range(18, 9, -1)):
                ver[ j][0] = ver[i][0]
                ver[ j][1] = -ver[i][1]
                
            for i,j in zip(range(nstepsQuad+1), range(18, 27, 1)):
                ver[ j][0] = -ver[i][0]
                ver[ j][1] = -ver[i][1]
                
#            for i in range(nstepsQuad *2 , nstepsQuad,  -1):
#                ver[ i -1][0] = -ver[i - nstepsQuad *2][0]
#                ver[ i  -1][1] = ver[i - nstepsQuad *2][1]
#                       
#            for i in range(nstepsQuad +1):
#                ver[ nstepsQuad*2 +i][0] = -ver[i][0]
#                ver[ nstepsQuad*2 +i][1] = -ver[i][1]
                
        elif naxes ==1:
            nstepsQuad =int(nsteps/(naxes*2))  # 18
            for i in range(1, nstepsQuad +1):
                ver[i-1][0] = - ver[ -i][0]  #+ noise[counter]#+ randint(-2,2)
                ver[i-1][1] = ver[ -i][1] #+ randint(-2,2)

        peri =visualExtra.computePerimeter(ver)
        convex, concave =visualExtra.computeAngles(ver)
        area =visualExtra.computeArea(ver)
        convexn =len(convex)
    print(peri, convexn, area)  # peri, len(convex), len(concave), area
    return ver

def drawStim(position, form, colour):

    stim2.setPos([0,0])
    v =ndarray.tolist(stim2.vertices)
    centre = visualExtra.analysecentroid(v)

    s1 =[]
    stim =visual.ShapeStim(myWin, pos=position, fillColor=[-0.2,-0.2,-0.2], lineColor =None, closeShape=True, interpolate=True)
    for i in range(0, len(v)-5, 5):
        s1 =[]
        s1.append(v[i])
        s1.append(v[i+5])
        s1.append(centre)

        stim.setVertices(s1)
        stim.draw()

    s1 =[v[-20]]
    s1.append(v[-1])
    s1.append(centre)
    stim.setVertices(s1)
    frame.draw()
    stim.draw()

#    stim1.setLineColor([.9,-.9,-.9]) # red
    stim1.setSize(1.0)
#    stim2.setLineColor([.9,-.9,-.9])
    stim2.setSize(1.0)
    
    if form =='smooth':
        stim2.draw()
    else:
        stim1.draw()    
    
    if colour == 'c':
        for i in [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1]:
            if i in [0.9,0.5,0.1]:
                stim2.setLineColor([-.9,.9,-.9])  #green
            elif i in [0.8,0.4]:
                stim2.setLineColor([-.9,-.9,.9]) # blue
            elif i in [0.7,0.3]:
                stim2.setLineColor([.9,.9,-.9]) # yellow
            elif i in [0.6,0.2]:
                stim2.setLineColor([.9,-.9,-.9]) # red
            stim2.setSize(i)
            scale = 1 - i
            stim2.setPos([x *scale for x in centre])
            stim2.draw()
    elif colour =='bw':
        for i in [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1]:
            stim2.setSize(i)
            scale = 1 - i
            stim2.setPos([x *scale for x in centre])
            stim2.draw()

    stim.setLineColor([0,0,0]) 
    stim1.setLineColor([0,0,0]) 
    stim2.setLineColor([0,0,0]) 
    

def prepareCondition(form, orientation): 

    shape_v = stim1.vertices.tolist()    # for psychopy v1.81
#    shape_v = stim1.vertices
    shape_v.append(shape_v[-1])   # inelegant but needed not to miss out the last position

    if form=='angular':
        newshape_v  =visualExtra.spline(vertices=shape_v, smooth=0.5, resolution=3120, order=1)
    elif form=='smooth':
        newshape_v  =visualExtra.spline(vertices=shape_v, smooth=0.5, resolution=3120)

    stim1.setOri(orientation)
    shape_v.append(shape_v[0])
    stim1.setVertices(shape_v)
    stim2.setVertices(newshape_v)
    stim2.setOri(orientation)

    

# here we go with trials

Reg = 'Rand'
Color = 'Black'
viewAngleX = 60
viewAngleY = -15
repeats = 16
duration = 0.1



    

for p in range(repeats):
    shape_v =[[0,0],[0,0]]
    newshape_v =[[0,0],[0,0]]
    n = p+1
    if Reg=='Rand':
        v1 =pick_coords(0)
    elif Reg=='Ref':
        v1 =pick_coords(2)
        
    stim1.setVertices(list(v1))
    stim1.setOri(orientation)
#        prepareCondition(form, orientation) #set up stim1 and stim2
#        drawStim([0, 0], form, colour)
    if Color == 'Black':
        c = [-1,-1,-1]
    elif Color == 'White':
        c = [0.5, 0.5,0.5]
    fillColour(ver =v1, colour=c)
    frame.draw()
    stim1.draw()
    myWin.flip()   # show stimulus

    myWin.getMovieFrame()
        
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

