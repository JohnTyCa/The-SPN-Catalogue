from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui
from pyglet.gl import * #a graphic library
import math


#reg =  'degraded' # vary the ammount of reflection and random (set pRef to 0 to get random)
#reg = 'refRotMix' # vary the proportion of reflected and rotated dots (0 gives 100% rotation)
#reg = 'ref' # pure reflection (same as using degraded and setting pRef to 100) 
repeats = 180
duration = 0.1

antiS = 0 # symmetry or antisymmetry (1 or 0)
elementShape = 'circle'
pSmall = 60
pMid = 20
pLarge = 10
smallSize = 5
midSize = 10
largeSize = 20

folds = 1

DS = 15 # DS = 'Downsampling' i.e. how many pixels between the elements
density =50 # in percent, how many positions get filled

pattemWidth = 400
pattemHeight = 400
DSSW = pattemWidth/DS # DOWNSAMPLED SCREEN WITDH
DSSH = pattemHeight/DS# DOWNSAMPLED SCREEN HEIGHT

A = pattemWidth/2 # A stands for 'adjacent'

myWin = visual.Window(size = [850,850], allowGUI=False, monitor = 'testMonitor', units = 'pix', fullscr= False, color=(0.5, 0.5, 0.5))
fixation = visual.Circle(myWin, radius = DS, interpolate=True, fillColor= 'red', lineColor = 'black')
e = visual.Circle(myWin, radius = DS/2.5, interpolate=True, fillColor= 'black', lineColor = 'black')
#e = visual.Rect(myWin, size = DS/2.5, interpolate=True, fillColor= 'black', lineColor = 'black')
background = visual.Circle(myWin, radius = A+(DS/2), edges = 512,  interpolate=True, lineColor = 'black', fillColor = 'black', lineWidth  = 0, units = 'pix') # I've done quite a bit of hacking because there are strange constraints on lineWidth here
background2 = visual.Circle(myWin, radius = A-(DS/2), edges = 512, interpolate=True, fillColor = (0.8,0.8,0.8), units = 'pix')
hiddenBoundary = visual.Circle(myWin, radius = A-30, edges = 512, interpolate=True, fillColor = (0.8,0.8,0.8), units = 'pix')

responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='black', colorSpace='rgb', units= 'pix')

def rotateCoords(x1, y1, angle):
    newx = float(cos(angle) * x1 - sin(angle) * y1)
    newy = float(sin(angle) * x1 + cos(angle) * y1)
    return newx, newy

def AlloPairs():
    whichPairs = []
    for p in range(32):
        a= zeros([100])
        for i in range(100):
            a[i] = i+1
        shuffle(a)
        if p == 0:
            whichPairs = a
        elif p > 0:
            whichPairs = append(whichPairs,a)
    return whichPairs
    

def AlloDot(density):
    yesDot = 0
    a= zeros([100]) #we are working in percentages
    for i in range(100):
        a[i] = i+1
    shuffle(a)
    if a[0] <= density:
        yesDot = 1
    return yesDot

def AlloSF(pSmall,pMid, pLarge):
    tot = pSmall+pMid+pLarge
    a= zeros([tot]) 
    for i in range(tot):
        a[i] = i+1
    shuffle(a)
    if a[0] <= pSmall:
        dotSize = smallSize

    elif a[0] <= pSmall+pMid and a[0] > pSmall:
        dotSize = midSize
    elif a[0] > pSmall+pMid:
        dotSize = largeSize

    return dotSize
    
#a= AlloSF(5,90,5)
#print a
#core.quit()


def setup(density,folds,reg,pRef,memCoords):
    global tCoords
    tCoords = zeros([((DSSW/2)*DSSH),9])
    angle = 360.0/folds
    a = angle/2.0
    b = radians(a)
    LenO = tan(b)*A
    segment= visual.ShapeStim(myWin, vertices = [(LenO,A),(0,0),(-LenO,A)], closeShape = True, opacity = 1,lineColor = 'black', ori =0)
    
    if folds == 1: # This is a bit of a hack to get one fold symmetry
        segment = hiddenBoundary
    #segment.draw()

    w = AlloPairs()
    k = 0
    p = 0
    xPos = -pattemWidth/2
    for x in range(DSSW/2):
        xPos = xPos+DS
        yPos = -pattemHeight/2
        #print xPos
        for y in range(DSSH):
            yPos = yPos+DS
            #print yPos
            tCoords[p,0] = xPos # secondDot
            tCoords[p,1] = yPos # secondDot
            tCoords[p,2] = -xPos # secondDot
            tCoords[p,3] = yPos # secton dot
            if segment.contains([xPos,yPos]) and hiddenBoundary.contains([xPos,yPos]):
                if reg == 'ref': 
                    if AlloDot(density) == 1: # randint(4) gives either 0 1 2 or 3
                        tCoords[p,4] = 1 # light up first
                        tCoords[p,5] = 1# light up second
                        tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                        tCoords[p,8] = tCoords[p,7]
                elif reg == 'rot': 
                    if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                        tCoords[p,4] = 1
                        tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                    if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                        tCoords[p,5] = 1
                        tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                elif reg == 'refRotMix':
                    if w[k] < pRef: # if we are having a ref
                        if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                            tCoords[p,4] = 1 # light up first
                            tCoords[p,5] = 1# light up second
                            tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            tCoords[p,8] = tCoords[p,7]
                    else: # if we are having a rand
                        if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                            tCoords[p,4] = 1
                            tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                        if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                            tCoords[p,5] = 1
                            tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    k = k+1
                
                
                elif reg == 'degraded':
                   
                    if memCoords == 'NA': # First Segment  HERE IS THE PROBLEM
                        if w[k] < pRef+1: # if we are having a ref
                            tCoords[p,6] = 1
                            if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1 # light up first
                                tCoords[p,5] = 1# light up second
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,8] = tCoords[p,7]
                        else: # if we are having a rand
                            if AlloDot(density) ==1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            if AlloDot(density) ==1:  # gives a 'density' % chance of getting a dot
                                tCoords[p,5] = 1
                                tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    else: # All other sements
                        tCoords = memCoords
                        if tCoords[p,6] == 0: # its a random
                            tCoords[p,4] = 0 # reset first
                            tCoords[p,5] = 0# reset first
                            if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,4] = 1
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,5] = 1
                                tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    k = k+1
            p = p + 1


def pattern(folds,reg,pRef):
    global dotcount
    background.draw()
    background2.draw()
    
    dotcount = 0
    memCoords = 'NA'
    setup(density,folds,reg,pRef,memCoords)
    memCoords = tCoords
    for segment in range(folds): 
        if reg == 'degraded':
            setup(density,folds,reg,pRef,memCoords)
        for p in range ((DSSW/2)*DSSW):
            if tCoords[p,4] ==1: # # if its an element
                 if antiS == 1:
                    e.setFillColor('blue') # use these to make anti-symmetries
                 xPos = tCoords[p,0]
                 yPos = tCoords[p,1]
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians
                 if elementShape == 'circle':
                    e.setRadius(tCoords[p,7])
                 elif elementShape == 'square':
                    e.setSize(tCoords[p,7])
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
            if tCoords[p,5] ==1: # if its an element
                 if antiS == 1:
                    e.setFillColor('red') # use these to make anti-symmetries

                 
                 xPos = tCoords[p,2] 
                 yPos = tCoords[p,3] # These were switched to get flip horizontal
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians
                 if elementShape == 'circle':
                    e.setRadius(tCoords[p,8])
                 elif elementShape == 'square':
                    e.setSize(tCoords[p,8])
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
    
    fixation.draw()


#pattern(5,'degraded',100) # This calls the experiment
#myWin.flip()
#core.wait(4)
#myWin.close()
#core.quit()
seed(1)

p = 0
for x in range(repeats):
    pattern(folds,'degraded',100) #This calls the experiment
    myWin.flip()
    core.wait(duration)
    myWin.getMovieFrame()
    myWin.flip()
    p = '%.0f' %(x+1)
    n= "%s%s%s" %('Vertical',p,'.png')
    myWin.saveMovieFrames(n)
myWin.close()
core.quit()
