from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import core, data, event, visual, gui #these are the psychopy libraries
import math, scipy, random, os, copy
import visualExtra

myWin = visual.Window(allowGUI=False, units='pix', size=(850,850), color=[-1, -1 ,-1], fullscr=False)#creates a window using pixels as units
myClock = core.Clock()

# only needed if stimuli have orientation (ignore for dots)
def generateOriPhases(n=10, symmetry='r'):
    orientations =[]
    phases =[]
    for i in range(n):
            orientations.append(random.randint(0,180))
            phases.append(0.25)
    return orientations, phases


# draw the stimuli
def drawingShape(shape, orientation, colour):
    v = [visualExtra.polar2cartesian(i[0],i[1]) for i in shape]    # get cartesian coordinates
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
def generateStimulus(sym, axes, n, minimumDist, gap, propNoise, radius):
    
    nyes =(n* (1.0-propNoise)) *1.0
    nno  =(n * propNoise) * 1.0

    if sym =='no' or propNoise==0:
        fullStim =visualExtra.generateSymmetry(symmetry=sym, axes=int(axes), ndots=n, radius=radius, minDist=minimumDist, gapAxis=gap)
        return fullStim
    elif sym =='r':
        target = visualExtra.generateSymmetry(symmetry=sym, axes=axes, ndots=nyes, radius=radius, minDist=minimumDist, gapAxis=gap)
        asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)

        #this loop is necessary to make sure target and noise elements do not overlap
        overlap =visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)

        t = myClock.getTime()
        while  overlap == True:
             asy = visualExtra.generateSymmetry(symmetry='no', axes=axes, ndots=nno, radius=radius, minDist=minimumDist, gapAxis=gap)
             overlap = visualExtra.overlapCoords(vertices1=target, vertices2=asy, minDist=minimumDist)

    return target + asy



p = 0 
axes = 4
ndots = 160
dotSize = 16
orientation = 0
radius = 200
minimumDist = 5.3
gap = 3
distribution = 'uniform'
colour = 'lightGreen'

propNoise = 0  # NOTE THIS IS P NOISE, NOT P SYMM
symmetry = 'r' # needs to be r if we want any symmety at all. but 'no' if we want random

repeats = 15

# fixed parameters
duration = 0.1

circularRegion =visual.Circle(myWin,  edges = 512, interpolate=True, fillColor=[-0, 0 ,0], lineColor='black')
line1 =visual.Line(myWin, start=[-340,0], end=[340,0], lineWidth=1, lineColor='black')
myTexture = zeros([4,4])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
myTexture = zeros([4,4])+1
gaborWhite = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[dotSize,dotSize])
gaborRed = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(.8,-1,-1), units='pix', size=[dotSize,dotSize])
gaborPink = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(0.4,-0.6,-0.6), units='pix', size=[dotSize,dotSize])
gaborLightGreen= visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,0.5,-1), units='pix', size=[dotSize,dotSize])
gaborDarkGreen = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-0.2,-1), units='pix', size=[dotSize,dotSize])

#circularRegion.setRadius(radius+dotSize)
#circularRegion.draw()
#myWin.flip()
#myWin.getMovieFrame()
#myWin.saveMovieFrames('baseline.png')
#
#myWin.close()
#core.quit()

for x in range(repeats):
    stimulus = []
    while stimulus==[]:
        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)

    circularRegion.setRadius(radius+dotSize)
    circularRegion.draw()
    circularRegion.setRadius(radius+dotSize)
    circularRegion.draw()
    if distribution == 'outside':
        ndotsOut =  128 # int(ndots / 4.)
        ndotsIn = 32 #int(ndots /4.) * 3
        radiusIn = int(sqrt(radius*radius /2.))
    elif distribution =='uniform':
        ndotsOut =  int(ndots / 2.)
        ndotsIn = int(ndots /2.)
        radiusIn = int(sqrt(radius*radius /2.))

    #print symmetry, axes, minimumDist, gap, propNoise, radius, distribution
    stimulusIn =generateStimulus(symmetry, axes, ndotsIn, minimumDist, gap, propNoise, radiusIn)
    stimulusOut =generateStimulus(symmetry, axes, ndotsOut, minimumDist, radiusIn, propNoise, radius)
#        stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)

    drawingShape(stimulusIn, orientation, colour)   # this is the first type of noise approach target+random
    drawingShape(stimulusOut, orientation, colour)   # this is the first type of noise approach target+random
    myWin.flip()
    myWin.getMovieFrame()
    core.wait(duration)
    pSymm = (1 - propNoise)*100 # This idiot proof the file names
    pSymm = '%.0f'%pSymm
    p = '%.0f' %(x+1)
    n= "%s%s%s%s%s" %(pSymm,'Uniform','Light',p,'.png')
    myWin.saveMovieFrames(n)


myWin.close()
core.quit()