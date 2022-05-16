from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import sys
from psychopy import core, data, event, visual, gui,parallel #these are the psychopy libraries
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions

import pygame, pygame.font, pygame.event, pygame.draw, string
from pygame.locals import *

rtri = 0.0  # Rotation angle for the triangle.
rquad = 0.0   # Rotation angle for the quadrilateral.
state ='start'

size=76
sizedot =24
ndots =10

w_width =1280
w_height =1024
#parallel.setData(0)

def drawStringScreenPause():

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)    # Clear The Screen And The Depth Buffer
    glLoadIdentity()                    # Reset The View 
    glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
    glDisable(GL_LIGHTING)
    glColor3f(.0,.0,.0)            # black     
    glRasterPos3f(- 0.4, 0, 0)
    string ='Pause. Wait for experiment to check the electrodes'

    for i in string:      
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, ord(i))
    
def drawStringScreen(stringL, stringR, xpos, ypos):

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)    # Clear The Screen And The Depth Buffer
    glLoadIdentity()                    # Reset The View 
    glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
    glDisable(GL_LIGHTING)
    glColor3f(.0,.0,.0)            # black     
    glRasterPos3f(-xpos - 0.2, ypos, 0)

    for i in stringL:      
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, ord(i))

    glRasterPos3f(xpos, ypos, 0)
    for i in stringR:      
        glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24, ord(i))


# draw the outside frame
def drawFrame():
    tx = 550/400.
    bx=-550/400.
    ty = -550/400.
    by= 550/400.
    d =0.05

    glColor3f(.3,.3,.3)            # black      
    glBegin(GL_POLYGON);
    glVertex2f(-tx, -ty)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(tx, -ty)
    glVertex2f(tx, -ty+d)
    glVertex2f(-tx, -ty+d)
    glEnd()    

#    glColor3f(1.0,0.0,0.0)            #    
    glBegin(GL_POLYGON);
    glVertex2f(-tx, ty)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(tx, ty)
    glVertex2f(tx, ty+d)
    glVertex2f(-tx, ty+d)
    glEnd()    

#    glColor3f(0.0,1.0,0.0)            #    
    glBegin(GL_POLYGON);
    glVertex2f(-tx, -ty)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(-tx +d, -ty)
    glVertex2f(-tx +d, ty)
    glVertex2f(-tx, ty)
    glEnd()   

#    glColor3f(0.0,0.0,1.0)            #       
    glBegin(GL_POLYGON);
    glVertex2f(tx, ty)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(tx -d, ty)
    glVertex2f(tx -d, -ty)
    glVertex2f(tx, -ty)
    glEnd()   

#    glColor3f(0.2,0.2,0.2)            # grey background
#    glBegin(GL_POLYGON);
#    glVertex3f(-tx, -tx, -0.05)  # we use vertex3f so we can give it some depth as well. 
#    glVertex3f(tx, -tx, -0.05)
#    glVertex3f(tx, tx, -0.05)
#    glVertex3f(-tx, tx, -0.05)
#    glVertex3f(-tx, -tx, -0.05)
#    glEnd()    
    
def drawFixation():
    glColor3f(0.2,0.2,0.2)            # grey      
    width = 8/400.
    height=8/400.
 
    glBegin(GL_POLYGON);
    glVertex2f(-width, -height)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(-width, height)
    glVertex2f(width, height)
    glVertex2f(width, -height)
    glEnd();    

    glBegin(GL_POLYGON);
    glVertex2f(-height, -width)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(-height, width)
    glVertex2f(height, width)
    glVertex2f(height, -width)
    glEnd();    


def drawMask():
    glColor3f(0.4,0.4,0.4)            # grey      
    width = 550/400.
    height=550/400.
    size = 10/400.
    
    for i in range (100):
        x = 2 * width * random() - width
        y = 2 * height * random() - height
        
        glBegin(GL_POLYGON);
        glVertex2f(x, y)  # we use vertex2f since we are  working in 2d. 
        glVertex2f(x+size, y)
        glVertex2f(x+size, y+size)
        glVertex2f(x, y+size)
        glEnd();    
    
    
def drawItem(x,y,s):
#    drawRect(x, y, s, s)
    drawSphere(x,y,s)
    
def drawSphere(x,y, s):
    glPushMatrix()
    glTranslatef(x/400., y/400. ,0.0) 
    glutSolidSphere(sizedot/400.,16,16)
    glPopMatrix()
    
def drawRect(x, y, width, height, filled=True):
    
    x =x/400.
    y =y/400.
    width = width/400.
    height=height/400.

    if filled==True:
        glBegin(GL_POLYGON);
    else: 
        glBegin(GL_LINE_LOOP);

    glVertex2f(x -width, y -height)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(x -width, y +height)
    glVertex2f(x +width, y +height)
    glVertex2f(x +width, y -height)
    glEnd();
# this is the function that draws a symmetrical pattern        

def pattern_v():

    a=[0]

    b=[1]

    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black

    shuffle(memory)

    i=0    

#    glColor3f(1.,0.,0.)
    
    for x in range(-(size*5), 0, size):

        for y in range(-(size*5), 0, size):

    #        if randint(1, 3)==1:

            if(memory[i] ==1):

                    drawItem(x+size/2, y+size/2, sizedot)

            i=i+1

                    

    i=0

#    glColor3f(0.,1.,0.)

    for x in range((size*5), 0, -size):

        for y in range(-(size*5), 0, size):

            if(memory[i] ==1):

                    drawItem(x-size/2, y+size/2, sizedot)

            i=i+1

            
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black

    shuffle(memory)
#    memory.reverse()

    i=0

#    glColor3f(0.,0.,1)

    for x in range(0, (size*5), size):

        for y in range(0,(size*5), size):        

            if(memory[i] ==1):

                    drawItem(x+size/2, y+size/2, sizedot)

            i=i+1

    

    i=0

#    glColor3f(-1.,-1.,-1.)

    for x in range(0,-(size*5), -size):

        for y in range(0,(size*5), size):

            if(memory[i] ==1):

                    drawItem(x-size/2, y+size/2, sizedot)

            i=i+1


# this is the function that draws a symmetrical pattern        
def pattern_hv():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)
    i=0    
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
    #        if randint(1, 3)==1:
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
    i=0
    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1
            
    memory.reverse()
    i=0
    #glColor3f(0.,0.,0)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    i=0
    #glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1

# this is the function that draws a random pattern        
def pattern_a():
    a=[0]
    b=[1]
    memory =(a*(25-ndots)*4)+(b*ndots*4)      # 25 cells of which 8 are black
    shuffle(memory)
    i=0    
    for x in range(-(size*5), size*5, size):
        for y in range(-(size*5), size*5, size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1

    
# A general OpenGL initialization function.  Sets all of the initial parameters.
def InitGL(Width, Height):                # We call this right after our OpenGL window is created.
    glClearColor(0.6, 0.6, 0.6, 0.6)    # This Will Clear The Background Color To Black
    glClearDepth(1.0)                    # Enables Clearing Of The Depth Buffer
    glDepthFunc(GL_LESS)                # The Type Of Depth Test To Do
    glEnable(GL_DEPTH_TEST)                # Enables Depth Testing
    glShadeModel(GL_SMOOTH)                # Enables Smooth Color Shading

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()                    # Reset The Projection Matrix
             # Calculate The Aspect Ratio Of The Window
    gluPerspective(45.0, float(Width)/float(Height), 0.1, 100.0) 
    glMatrixMode(GL_MODELVIEW)
    glutPostRedisplay()
#    glEnable(GL_LINE_SMOOTH)
#    glEnable(GL_BLEND)
#    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
#    glBlendFunc(GL_SRC_ALPHA_SATURATE, GL_ONE) 
#    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
#    glOrtho(-4, 4, -4, 4, -1, 1);   

# The main drawing function.
# This gets called after any glutPostRedisplay()
def DrawGLScene():
    global rtri, rquad, state

    if state =='start':
         angle  = 60.                    
         glutPostRedisplay()
        
    elif state =='fixation':
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)    # Clear The Screen And The Depth Buffer
        glLoadIdentity()                    # Reset The View 
        glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
        drawFixation()
        state ='stimulus'   
    #  since this is double buffered, swap the buffers to display what just got drawn.
        glutSwapBuffers()
#        print 'fixation'
        t = myclock.getTime() + 1.5 + random()/2.  # this is between 1.5 and 2 sec
        while myclock.getTime() < t:
            pass #do nothing 
        glutPostRedisplay()
        
    elif state =='stimulus':    
        glutKeyboardFunc(0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)    # Clear The Screen And The Depth Buffer
        glLoadIdentity()                    # Reset The View      
        glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
        drawFixation()
#        print thisTrial
        angle  = thisTrial.patternOri                 # Decrease The Rotation Variable For The Quad
        glRotatef(angle, 0.0,1.0,0.0)                # Rotate The Pyramid On It's Y Axis
        if thisTrial.color =='red':
            glColor3f(1.0,0.5,0.5)            # bright red        
        else:
            glColor3f(1.0,0.2,0.2)            # dark red          
        if thisTrial.type =='ref_V':
            pattern_v()
        else:
            pattern_a()
        
        glLoadIdentity()                    # Reset The View      
        glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
        angle  = thisTrial.frameOri                 # Decrease The Rotation Variable For The Quad
        glRotatef(angle, 0.0,1.0,0.0)                # Rotate The Pyramid On It's Y Axis       
        drawFrame()
        
        #  since this is double buffered, swap the buffers to display what just got drawn.
#        parallel.setData(0)
        glutSwapBuffers()
#        parallel.setData(thisTrial.trigger)        # after the swap buffer is better than before, as the swapping will wait to syncronise with the monitor

        t = myclock.getTime() + thisTrial.StimDuration
        core.wait(0.01)
#        parallel.setData(0)
        while myclock.getTime() < t:        
            pass #do nothing 
            
        state = 'mask'
        glutPostRedisplay()

    elif state =='mask':
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)    # Clear The Screen And The Depth Buffer
        glLoadIdentity()                    # Reset The View      
        glTranslatef(0.0,0.0,-6.0)                # Move Left And Into The Screen
        t = myclock.getTime() + 0.12    #thisTrial.MaskDuration 
        drawMask()   #drawMask()
        glutSwapBuffers()
        while myclock.getTime() < t:        
            pass #do nothing 
        state='response'
        glutPostRedisplay()
        
    elif state =='response':
        glutKeyboardFunc(keyPressed)
#        drawFixation()
#        drawStringScreen(thisTrial.promptL, -0.35, 0)
        drawStringScreen(thisTrial.promptL,  thisTrial.promptR, 0.45, 0)
        glutSwapBuffers()

    elif state =='pause':
        drawStringScreenPause()
        glutSwapBuffers()
#        t = myclock.getTime() + 2 
#        while myclock.getTime() < t:        
#            pass #do nothin
        
    elif state =='finished':
        filename= 'data/%s_.txt' %(data.getDateStr())
        trials.saveAsWideText(filename)
        sys.exit()
        

# The function called whenever a key is pressed. Note the use of Python tuples to pass in: (key, x, y)
def keyPressed(*args):
    global thisTrial, state

    responseKey = args[0]
    # If escape is pressed, kill everything.
    if args[0] ==  '\033':
        sys.exit()
    
    if state=='start':
        if args[0] == ' ':
             state ='fixation'
        
    elif state =='response':
        if responseKey in ('z','/'):
            try:
                trials.addData('responseKey', responseKey)
                trials.addData('responseCorrect', responseKey == thisTrial.correctKey)                
                thisTrial = trials.next()
                if (trials.thisN % 32 ==0):
                    state ='pause'  
                else:
                    state='fixation'
            except:
                state ='finished'
            glutPostRedisplay()

    elif state =='pause':
        if responseKey in ('a'):
            state ='fixation'
            glutPostRedisplay()

def main():
    global trials, thisTrial, myclock, state
    
    trials=data.TrialHandler(nReps=18, method='random', trialList=data.importConditions('perspective.xlsx')) # 18 reps
    thisTrial =trials.next()
    myclock =core.Clock()
    glutInit(sys.argv)

    # Select type of Display mode:
    #  Double buffer
    #  RGBA color
    # Alpha components supported
    # Depth buffer
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH)

    # get a window
    glutInitWindowSize(w_width, w_height)

    # the window starts at the upper left corner of the screen
    glutInitWindowPosition(0, 0)

    # Okay, like the C version we retain the window id to use when closing, but for those of you new
    # to Python (like myself), remember this assignment would make the variable local and not global
    # if it weren't for the global declaration at the start of main.
    window = glutCreateWindow("window")

       # Register the drawing function with glut, BUT in Python land, at least using PyOpenGL, we need to
    # set the function pointer and invoke a function to actually register the callback, otherwise it
    # would be very much like the C version of the code.
    glutDisplayFunc(DrawGLScene)

    # Uncomment this line to get full screen.
    glutFullScreen()

    # When we are doing nothing, redraw the scene.
   # glutIdleFunc(DrawGLScene)

    # Register the function called when the keyboard is pressed.
    glutKeyboardFunc(keyPressed)

    # Initialize our window.
    InitGL(w_width, w_height)

    # Start Event Processing Engine
    state ='start'
    glutMainLoop()

# Print message to console, and kick off the main to get it rolling.
print "Hit ESC key to quit."
main()