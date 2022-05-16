from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functios
import os #handy system and path functions
from psychopy import core, data, event, visual, gui # parallel
import psychopy.logging #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *
duration = 2

def ObjectDraw(pattern, nofObjects):
    maxx = 80
    maxy =220
    n = 12
    vx = zeros([n,1])
    vy = zeros([n,1])
    a=30
    b=20



    if pattern == 'reflection': #vertical reflection
        glBegin(GL_LINE_STRIP)
        
        for i in range (n): # for loop does the first contour
            vx[i] = randint(a, maxx+a)
            vy[i] = -(maxy/2) + i*b     # y goes from -110 to 110
            glVertex2f(vx[i], vy[i])
            
        if nofObjects =='1':  # This does conjoining lines
            glEnd()
            glBegin(GL_LINE_STRIP)
            glVertex2f(vx[0], vy[0])
        elif nofObjects == '2':
            glVertex2f(200, vy[n-1])
            glVertex2f(200, vy[0])
            glVertex2f(vx[0], vy[0])
            glEnd()
            glBegin(GL_LINE_STRIP)


        for i in range (n): # for loop does the second contour
            glVertex2f(-vx[i], vy[i])
       
        if nofObjects == '1': # This does conjoining lines
            glVertex2f(vx[n-1], vy[n-1])
            glEnd

        elif nofObjects == '2':
            glVertex2f(-200, vy[n-1])
            glVertex2f(-200, vy[0])
            glVertex2f(-vx[0], vy[0])
        glEnd()

#    glBegin(GL_LINE_STRIP)
#    glVertex2f(-200, vy[n-1])
#    glVertex2f(-200, vy[0])
#    glEnd
#    glBegin(GL_LINE_STRIP)
#    glVertex2f(200, vy[n-1])
#    glVertex2f(200, vy[0])
#    glEnd

    if pattern == 'translation': 
        glBegin(GL_LINE_STRIP)
        for i in range (n):
            vx[i] = randint(a, maxx+a)
            vy[i] = -(maxy/2) + i*b     # y goes from -110 to 110
            glVertex2f(vx[i], vy[i])
   
        if nofObjects =='1':
            glEnd()
            glBegin(GL_LINE_STRIP)
            glVertex2f(vx[0], vy[0]); 
        elif nofObjects == '2':
            glVertex2f(200, vy[n-1])
            glVertex2f(200, vy[0])
            glVertex2f(vx[0], vy[0])
            glEnd()
            glBegin(GL_LINE_STRIP)
            
        for i in range (n):
            glVertex2f(vx[i] -maxx -2*a, vy[i]);
            
        if nofObjects == '1':
            glVertex2f(vx[n-1], vy[n-1])
        elif nofObjects == '2':
            glVertex2f(-200, vy[n-1])
            glVertex2f(-200, vy[0])
            glVertex2f(vx[0] -maxx -2*a, vy[0]);
        glEnd()



    if pattern == 'random': #random
        vx = zeros([n+1,1])
        vy = zeros([n+1,1])
        glBegin(GL_LINE_STRIP)
        for i in range (n):
            vx[i] = randint(a, maxx+a)
            vy[i] = -(maxy/2) + i*b     # y goes from -110 to 110
            glVertex2f(vx[i], vy[i])
        vx[n]= vx[n-1]
        vy[n]= vy[n-1]
        
        if nofObjects =='1':
            glEnd()
            glBegin(GL_LINE_STRIP)
            glVertex2f(vx[0], vy[0])

        elif nofObjects == '2':
            glVertex2f(200, vy[n-1])
            glVertex2f(200, vy[0])
            glVertex2f(vx[0], vy[0])
            glEnd()
            glBegin(GL_LINE_STRIP)

        for i in range (n):
            vx[i] = randint(a, maxx+a)
            glVertex2f(-vx[i], vy[i])

        if nofObjects == '1':
            glVertex2f(vx[n], vy[n])
        elif nofObjects == '2':
            glVertex2f(-200, vy[n-1])
            glVertex2f(-200, vy[0])
            glVertex2f(-vx[0], vy[0])
        glEnd()
    glFinish()
    
#    glBegin(GL_LINE_STRIP)
#    glVertex2f(-200, -maxy)
#    glVertex2f(-200, +maxy)
#    glEnd
#    
#    glBegin(GL_LINE_STRIP)
#    glVertex2f(200, -maxy)
#    glVertex2f(200, +maxy)
#    glEnd
#    
#    glFinish()

#store info about the experiment
expName='ObjecthoodEEG'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

#setup files for saving
#if not os.path.isdir('data'):
#    os.makedirs('data')#if this fails (e.g. permissions) we will get error
#filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, size=[1280,1024], units='pix', fullscr= True)


myWin.setScale(units='pix')# important to deal with bug in GL 
glColor3d(1.0,1.0,1.0)
glEnable(GL_LINE_SMOOTH)
glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
glLineWidth(1.5)



ObjectDraw('reflection', '1')

myWin.flip()
core.wait(5)
myWin.flip()



