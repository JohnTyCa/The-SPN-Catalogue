from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event,  gui#,parallel# these are the psychopy libraries
from pyglet.gl import * #a graphic library
import math
#parallel.setPortAddress(0x378)#address for parallel port on many machines
expName='Anti Symm Disc Symm'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

folds = 1# PLAY WITH THIS TO SEE         <------------------------------!!!!!! I HAVE CHANGED THIS TO ONE FOLD (06/07/15)!!!!!!!!
reg =  'degraded' # vary the ammount of reflection and random (set pRef to 0 to get random)
duration = 1.5 # how long do we want the trials to last?
baselineDuration = 1.5
#reg = 'refRotMix' # vary the proportion of reflected and rotated dots (0 gives 100% rotation)
#reg = 'ref' # pure reflection (same as using degraded and setting pRef to 100) 
#reg = 'rot'# pure rot (same as using degraded and setting pRef to 100)
#antiS = 0 # symmetry or antisymmetry (1 or 0)

#pRef = 100 # percent of reflected of reflected elements. Works with degraded or refRotMix
seed(1)
DS = 15 # DS = 'Downsampling' i.e. how many pixels between the elements


pattemWidth = 400
pattemHeight = 400
DSSW = pattemWidth/DS # DOWNSAMPLED SCREEN WITDH
DSSH = pattemHeight/DS# DOWNSAMPLED SCREEN HEIGHT

A = pattemWidth/2 # A stands for 'adjacent'

myWin = visual.Window(size = [800,800], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= False, color=(0.5, 0.5, 0.5))
fixation = visual.Circle(myWin, radius = DS, interpolate=True, lineWidth = 1,fillColor= 'red', lineColor = 'black')
#e = visual.Circle(myWin, radius = DS/2, interpolate=True, fillColor= 'black', lineColor = 'grey', lineWidth = 0, fillColorSpace = 'rgb', lineColorSpace = 'rgb')
e = visual.Rect(myWin, size = [30,30], interpolate=True, opacity = 1, lineColor = 'black')
ruler = visual.Rect(myWin, size = [800,30], interpolate=True, opacity = 1, lineColor = 'black', pos = [0,200], units = 'pix')
background = visual.Circle(myWin, radius = A, edges = 512,  interpolate=True, lineColor = 'black', lineWidth  = 10, units = 'pix')
background2 = visual.Circle(myWin, radius = A, edges = 512, interpolate=True, fillColor = 'grey', units = 'pix')
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='black', colorSpace='rgb', units= 'pix')
hiddenBoundary = visual.Circle(myWin, radius = A-DS, edges = 512, interpolate=True, fillColor = (0.8,0.8,0.8), units = 'pix')
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
    
#AlloPairs()
#
#core.quit()


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
        dotSize = 3
    elif a[0] <= pSmall+pMid and a[0] > pSmall:
        dotSize = 6
    elif a[0] > pSmall+pMid:
        dotSize = 12
    return dotSize
    
#a= AlloSF(5,90,5)
#print a
#core.quit()


def setup(density,folds,reg,pRef,memCoords,antiS):
    tCoords = zeros([((DSSW/2)*DSSH),11])
    angle = 360.0/folds
    a = angle/2.0
    b = radians(a)
    LenO = tan(b)*A
    segment= visual.ShapeStim(myWin, vertices = [(LenO,A),(0,0),(-LenO,A)], closeShape = True, lineWidth = 1, fillColor = 'white',lineColor = 'black', ori =0)
    MDSSH = DSSH/2
    if folds == 1: # This is a bit of a hack to get one fold symmetry
        segment = background
        MDSSH = DSSH
    #segment.draw() # useful for understanding how the pattern is constructed
    pSmall = 0
    pMid = 100
    pLarge = 0
    w = AlloPairs()
    k = 0
    p = 0
    xPos = -pattemWidth/2
    for x in range((DSSW/2)-1):
        xPos = xPos+DS
        if folds > 1:
            yPos = 0
        elif folds ==1:
            yPos = -pattemHeight/2
        #print yPos
        for y in range(MDSSH):
            yPos = yPos+DS
            
            tCoords[p,0] = xPos # firstDot
            tCoords[p,1] = yPos # firstDot
            tCoords[p,2] = -xPos # secondDot
            tCoords[p,3] = yPos # secton dot
            if segment.contains([xPos,yPos]) and hiddenBoundary.contains([xPos,yPos]):
                if reg == 'ref': 
                    if AlloDot(density) == 1: # randint(4) gives either 0 1 2 or 3
                        tCoords[p,4] = 1 # light up first
                        tCoords[p,5] = 1# light up second
                        #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                        #tCoords[p,8] = tCoords[p,7]
                elif reg == 'rot': 
                    if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                        tCoords[p,4] = 1
                        #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                    if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                        tCoords[p,5] = 1
                        #tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                elif reg == 'refRotMix':
                    if w[k] < pRef+1: # if we are having a ref
                        if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                            tCoords[p,4] = 1 # light up first
                            tCoords[p,5] = 1# light up second
                            #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            #tCoords[p,8] = tCoords[p,7]
                    else: # if we are having a rand
                        if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                            tCoords[p,4] = 1
                            #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                        if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                            tCoords[p,5] = 1
                            #tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    k = k+1
                
                
                elif reg == 'degraded':
                   
                    if memCoords == 'NA': # First Segment  
                        if w[k] < pRef+1: # if we are having a ref
                            tCoords[p,6] = 1
                            if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1 # light up first
                                tCoords[p,5] = 1# light up second
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,8] = tCoords[p,7]
                                
                                tCoords[p,9] = randint(2)
                                if antiS == 0:
                                    tCoords[p,10] = tCoords[p,9]
                                elif antiS == 1 and tCoords[p,9] ==1:
                                    tCoords[p,10] = 0
                                elif antiS == 1 and tCoords[p,9] ==0:
                                    tCoords[p,10] = 1
                        else: # if we are having a rand
                            if AlloDot(density) ==1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,9] = randint(2)
                            if AlloDot(density) ==1:  # gives a 'density' % chance of getting a dot
                                tCoords[p,5] = 1
                                tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,10] = randint(2)
                    else: # All other sements
                        tCoords = memCoords
                        if tCoords[p,6] == 0: # its a random
                            tCoords[p,4] = 0 # reset first
                            tCoords[p,5] = 0# reset first
                            if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,4] = 1
                                tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,9] = randint(2)
                            if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,5] = 1
                                tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                                tCoords[p,10] = randint(2)
                    k = k+1
            p = p + 1
    return tCoords
def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether they are reflection or random')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
    
def pattern(folds,reg,pRef,colorCategory,antiS,density):
    if colorCategory == 'BW':
        color1 = [-1,-1,-1]
        color2 = [1,1,1]
    elif colorCategory == 'Col':
        color1 = [-0.7,-0.7,0.7]
        color2 = [0.7,0.7,-0.7]
    
        
    background2.draw()
    dotcount = 0
    memCoords = 'NA'
    tCoords = setup(density,folds,reg,pRef,memCoords,antiS)
    memCoords = tCoords
    for segment in range(folds): 
        if reg == 'degraded':
            tCoords = setup(density,folds,reg,pRef,memCoords,antiS)
        for p in range ((DSSW/2)*DSSH):
            if tCoords[p,4] ==1: # # if its an element
                 xPos = tCoords[p,0]
                 yPos = tCoords[p,1]
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians # This repeats one half all the way round the edge....
                 #e.setRadius(tCoords[p,7])
                 if tCoords[p,9] == 1:
                    e.setFillColor(color1,'rgb')
                 elif tCoords[p,9] == 0:
                    e.setFillColor(color2,'rgb')
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
            if tCoords[p,5] ==1: # if its an element # This reflects within a segment. 
                 xPos = tCoords[p,2] 
                 yPos = tCoords[p,3]
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians
                 #e.setRadius(tCoords[p,8])
#                 
                 if tCoords[p,10] == 1:
                    e.setFillColor(color1,'rgb')
                 elif tCoords[p,10] == 0:
                    e.setFillColor(color2,'rgb')
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
    background.draw()
    fixation.draw()
    print dotcount
    ruler.draw()

for i  in range(60):
    pattern(1,'degraded',0,'BW',1,80) #This calls the experiment
    myWin.flip()
    #myWin.getMovieFrame()
    core.wait(0.1)


#myWin.saveMovieFrames('j5.png') # useful  screen saver system 
core.quit()

