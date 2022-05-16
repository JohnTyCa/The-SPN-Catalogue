
# black to white priming
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core,visual, data, event, gui, parallel
from pyglet.gl import * #a graphic library
import math
import visualExtra


#expName='Black to White Adaptation'#from the Builder filename that created this script
#expInfo={'participant':''}
#dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
#if dlg.OK==False: core.quit() #user pressed cancel
#expInfo['date']=data.getDateStr()#add a simple timestamp
#expInfo['expName']=expName
#filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
#if not os.path.isdir('data'):
#    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(size = [850,850], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color= (-0.25, -0.25, -0.25))
myClock = core.Clock()
fixationSize = 0.5



# global parameters for symmetry
axes = 2
ndots = 160
dotSize = 24
orientation = 0
radius = 200
minimumDist =10.6
gap = 3


line1 =visual.Line(myWin, start=[-340,0], end=[340,0], lineWidth=1, lineColor='black')

myTexture = zeros([4,4])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
myTexture = zeros([4,4])+1
gaborWhite = visual.GratingStim(myWin, tex=myTexture, mask="gauss",color=(1,1,1), units='pix', size=[dotSize,dotSize])
gaborRed = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(.8,-1,-1), units='pix', size=[dotSize,dotSize])
gaborPink = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(0.4,-0.6,-0.6), units='pix', size=[dotSize,dotSize])
gaborLightGreen= visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,0.5,-1), units='pix', size=[dotSize,dotSize])
gaborDarkGreen = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-0.2,-1), units='pix', size=[dotSize,dotSize])
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-1,-1), units='pix', size=[dotSize,dotSize])

circularRegion =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=(-0, -0 ,-0), lineColor=(-0,-0,-0), units= 'pix')


def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether there is any regularity present')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()


def generateOriPhases(n=10, symmetry='r'):
    orientations =[]
    phases =[]
    for i in range(n):
            orientations.append(random.randint(0,180))
            phases.append(0.25)
    return orientations, phases
    
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
    elif colour == 'white':
            for i in v:
                gaborWhite.setPos(i)
                gaborWhite.draw()


#circularRegion.draw()
#myWin.flip()
#myWin.getMovieFrame()
#n= 'baseline.png'
#myWin.saveMovieFrames(n)
#core.wait(1)
#myWin.close()
#core.quit()

#circularRegion.draw()
#myWin.flip()
#myWin.getMovieFrame()
#n= 'Oddball.png'
#myWin.saveMovieFrames(n)
#core.wait(1)
#myWin.close()
#core.quit()

p = 0
repeats = 360
duration = 0.1
patternType = 'symmetry'
col='black'
for x in range(repeats):
    if patternType == 'random':
        symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 1
    elif patternType == 'symmetry':
        symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random
        propNoise = 0
    stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
    circularRegion.draw()
    drawingShape(stimulus, orientation,col,0,0)  
    myWin.flip()
    core.wait(duration)
    myWin.getMovieFrame()
    myWin.flip()
    p = '%.0f' %(x+1)
    n= "%s%s%s" %('ReflectionBlack',p,'.png')
    myWin.saveMovieFrames(n)
myWin.close()
core.quit()