from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui # parallel
from pyglet.gl import * #a graphic library
import math

expName='pSymm'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

duration = 1.5 # how long do we want the trials to last?
baselineDuration = 1.5
folds = 4# PLAY WITH THIS TO SEE 
reg =  'degraded' # vary the ammount of reflection and random (set pRef to 0 to get random)

#reg = 'refRotMix' # vary the proportion of reflected and rotated dots (0 gives 100% rotation)
#reg = 'ref' # pure reflection (same as using degraded and setting pRef to 100) 
#reg = 'rot'# pure rot (same as using degraded and setting pRef to 100)
antiS = 0 # symmetry or antisymmetry (1 or 0)

#pRef = 100 # percent of reflected of reflected elements. Works with degraded or refRotMix

DS = 10 # DS = 'Downsampling' i.e. how many pixels between the elements
density = 40 # in percent, how many positions get filled

pattemWidth = 400
pattemHeight = 400
DSSW = pattemWidth/DS # DOWNSAMPLED SCREEN WITDH
DSSH = pattemHeight/DS# DOWNSAMPLED SCREEN HEIGHT

A = pattemWidth/2 # A stands for 'adjacent'

myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color=(0.5, 0.5, 0.5))
fixation = visual.Circle(myWin, radius = DS, interpolate=True, fillColor= 'red', lineColor = 'black')
e = visual.Circle(myWin, radius = DS/2, interpolate=True, fillColor= 'black', lineColor = 'black')
#e = visual.Rect(myWin, size = [10,10], interpolate=True, fillColor= 'blue', lineColor = 'blue')
background = visual.Circle(myWin, radius = A, edges = 512,  interpolate=True, lineColor = 'black', lineWidth  = DS, units = 'pix')
background2 = visual.Circle(myWin, radius = A, edges = 512, interpolate=True, fillColor = 'white', units = 'pix')
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
        dotSize = 1
    elif a[0] <= pSmall+pMid and a[0] > pSmall:
        dotSize = 3
    elif a[0] > pSmall+pMid:
        dotSize = 6
    return dotSize
    
#a= AlloSF(5,90,5)
#print a
#core.quit()


def setup(density,folds,reg,pRef,memCoords):
    global tCoords
    tCoords = zeros([((DSSW/2)*DSSH),7])
    angle = 360.0/folds
    a = angle/2.0
    b = radians(a)
    LenO = tan(b)*A
    segment= visual.ShapeStim(myWin, vertices = [(LenO,A),(0,0),(-LenO,A)], closeShape = True, fillColor = 'white',lineColor = 'black', ori =0)
    
    if folds == 1: # This is a bit of a hack to get one fold symmetry
        segment = background
    #segment.draw()
    pSmall = 0
    pMid = 100
    pLarge = 0
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
            if segment.contains([xPos,yPos]) and background.contains([xPos,yPos]):
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
                    if w[k] <= pRef: # if we are having a ref
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
                
                elif reg == 'degradedType2':
                    if memCoords == 'NA': # First Segment  HERE IS THE PROBLEM
                        if w[k] <= pRef: # if we are having a ref
                            tCoords[p,6] = 1
                            if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1 # light up first
                                tCoords[p,5] = 1# light up second
                    else: # All other sements
                            tCoords = memCoords
                    k = k+1
                elif reg == 'degraded':
                    if memCoords == 'NA': # First Segment  HERE IS THE PROBLEM
                        if w[k] < pRef: # if we are having a ref
                            tCoords[p,6] = 1
                            if AlloDot(density) == 1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1 # light up first
                                tCoords[p,5] = 1# light up second
                                #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                                #tCoords[p,8] = tCoords[p,7]
                        else: # if we are having a rand
                            if AlloDot(density) ==1: # gives a 'density' % chance of getting a dot
                                tCoords[p,4] = 1
                                #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            if AlloDot(density) ==1:  # gives a 'density' % chance of getting a dot
                                tCoords[p,5] = 1
                                #tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    else: # All other sements
                        tCoords = memCoords
                        if tCoords[p,6] == 0: # its a random
                            tCoords[p,4] = 0 # reset first
                            tCoords[p,5] = 0# reset first
                            if AlloDot(density) ==1: # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,4] = 1
                                #tCoords[p,7] = AlloSF(pSmall,pMid,pLarge)
                            if AlloDot(density) ==1:  # randint(4) gives either 0 1 2 or 3:
                                tCoords[p,5] = 1
                                #tCoords[p,8] = AlloSF(pSmall,pMid,pLarge)
                    k = k+1
            p = p + 1


def pattern(folds,reg,pRef):
    global dotcount
    background2.draw()
    dotcount = 0
    memCoords = 'NA'
    setup(density,folds,reg,pRef,memCoords)
    memCoords = tCoords
    for segment in range(folds): 
        if reg == 'degraded' or reg == 'degradedType2':
            setup(density,folds,reg,pRef,memCoords)
        for p in range ((DSSW/2)*DSSW):
            if tCoords[p,4] ==1: # # if its an element
                 if antiS == 1:
                    e.setFillColor('blue') # use these to make anti-symmetries
                 xPos = tCoords[p,0]
                 yPos = tCoords[p,1]
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians
                 #e.setRadius(tCoords[p,7])
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
            if tCoords[p,5] ==1: # if its an element
                 if antiS == 1:
                    e.setFillColor('red') # use these to make anti-symmetries
                 xPos = tCoords[p,2] 
                 yPos = tCoords[p,3]
                 xPos, yPos = rotateCoords(xPos,yPos,radians((360/folds)*segment)) # angle is in radians
                 #e.setRadius(tCoords[p,8])
                 e.setPos([xPos,yPos])
                 dotcount = dotcount+1
                 e.draw()
    background.draw()
    fixation.draw()
    
pattern(folds,'degradedType2',20) # This calls the experiment
myWin.flip()
core.wait(4)
core.quit()


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
    
def responseCollect(responseScreenVersion):
    event.clearEvents()
    choice = 'rand'
    if responseScreenVersion == 1:
        responseScreen.setText('Some Regularity      No Regularity ')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'ref'
    elif responseScreenVersion == 2:
        responseScreen.setText('No Regularity       Some Regularity')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'ref'
    return choice

   
def runBlock(trialbook,Reps):
    #parallel.setData(0)
    trialCounter = 0
    blockDuration = 30
    nBlocksToGo = 20
    myClock = core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1
        background2.draw()
        background.draw()
        fixation.draw()
        
        myWin.flip()
        
        pattern(folds,reg,pRef) # This calls the experiment
        w = myClock.getTime() + baselineDuration
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        #parallel.setData(trigger)
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        w = myClock.getTime() + duration
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close

#        choice = responseCollect(responseScreenVersion)
#        trials.addData('choice', choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])


runBlock('trialbook.xlsx',1)
myWin.saveMovieFrames('j.png')

core.wait(2)
myWin.close
core.quit()