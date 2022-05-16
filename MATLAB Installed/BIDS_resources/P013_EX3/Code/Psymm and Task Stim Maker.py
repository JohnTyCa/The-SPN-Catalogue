from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import core, data, event, visual, gui #these are the psychopy libraries
import math, scipy, random, os, copy
import visualExtra

expName='P Symm Stim Maker'
expInfo={'number':"",'task':""}
#dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
#if dlg.OK==False: 
#    core.quit() #user pressed cancel
#
#if not os.path.isdir('data'):      #folder data
#    os.makedirs('data')            #if this fails (e.g. permissions) we will get error
#

#seed(1000) # no seed during generation




#task =expInfo['task']

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
def generateStimulus(symmetry, axes, n, minimumDist, gap, propNoise, radius):
    
    nyes =(n* (1.0-propNoise)) *1.0
    nno  =(n * propNoise) * 1.0
    print symmetry, axes, n, minimumDist, gap, propNoise, radius, nyes, nno
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

# run the experiment
#def runBlock(trialbook, repeats):
#    
#    trials=data.TrialHandler(nReps=repeats, method='sequential', trialList=data.importConditions(trialbook)) #
#    trials.extraInfo =expInfo  #so we store all relevant info into trials
#    thisTrial=trials.trialList[0]#so we can initialise stimuli with some values
#
#    # This long loop runs through the trials
#    for thisTrial in trials:
#        if thisTrial!=None:
#            for paramName in thisTrial.keys():
#                exec(paramName+'=thisTrial.'+paramName) #these lines seem strange but it just makes the variables more readable 
#                
#        fixation.draw()#draws fixation
#        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible
#
#        stimulus = []
#        while stimulus==[]:
#            stimulus =generateStimulus(symmetry, axes, ndots, minimumDist, gap, propNoise, radius)
#        drawingShape(stimulus, orientation, colour)   # this is the first type of noise approach target+random
#        
#        circularRegion.setRadius(radius+dotSize)
#        circularRegion.draw()
#        myWin.flip()
#        core.wait(duration)
#        myWin.flip()
#
p = 0
axes = 4
ndots = 160
dotSize = 16
orientation = 0
radius = 200
minimumDist = 5.3
gap = 3

duration = 0.1

propNoise = 1  # NOTE THIS IS P NOISE, NOT P SYMM
colour = 'lightGreen'
symmetry = 'no' # needs to be r if we want any symmety at all. but 'no' if we want random
repeats = 150



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
    drawingShape(stimulus, orientation, colour)   # this is the first type of noise approach target+random

    myWin.flip()
    myWin.getMovieFrame()
    core.wait(duration)
    myWin.flip()
    pSymm = (1 - propNoise)*100 # This idiot proof the file names
    pSymm = '%.0f'%pSymm
    p = '%.0f' %(x+1)
    n= "%s%s%s%s" %(pSymm,'Light',p,'.png')
    myWin.saveMovieFrames(n)


myWin.close()
core.quit()