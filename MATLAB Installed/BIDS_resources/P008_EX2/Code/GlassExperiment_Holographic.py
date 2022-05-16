from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, gui ,parallel
from pyglet.gl import * #a graphic library
import random
import math

parallel.setPortAddress(0x378)#address for parallel port on many machines
parallel.setData(0)



expName='GlassExperiment_Holographic'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filenamexlsx= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])
filenametxt= expName
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName 

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  



## In the original Glass experiment patterns had 30 dots each half; Glass patterns had 15 dipoles each half
## Here there are 200 dipoles for Glass patterns. So Reflection and nonGlassRandom will have 200 dots each side.
#myWin = visual.Window(size=(1280,1024), allowStencil = True, allowGUI = 'False',monitor= 'EEG lab participant', units='pix',fullscr = 'True')
myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True, color='grey')
SizePattern=400 ## size of the squared pattern
radiusDipole = 6 ##distance between element of dipole and centre of dipole
eradius=3 ##radius of each dot-element of the dipole
nDipoles= 50 ## N of dipoles
btwDip = 15 ## min distance between dipoles
centerLineV = visual.Line(myWin, start=(0, -500), end=(0, 500))
centerLineH = visual.Line(myWin, start=(-1000, 0), end=(1000,0))

limAllo= int(math.sqrt(2*(SizePattern**2))) ##This sets the radius of the circle circumscribed around the pattern square
xSq= ySq = SizePattern/2 
segment= visual.ShapeStim(myWin, vertices = [[-xSq, -ySq],[-xSq, ySq],[xSq, ySq],[xSq, -ySq]], closeShape = True, fillColor = None,lineColor = 'black', ori =0)

fixation = visual.TextStim(myWin, ori=0,text = '+', pos=[0, 1], height=30, color='red', units= 'pix')
centralDot = visual.Circle(myWin, lineColor='red', fillColor='red', radius=eradius/2, edges=20, pos=[0,0]) 
e1= visual.Circle(myWin, lineColor='white', fillColor='white', radius=eradius, edges=20, pos=[0,0])
e2=  visual.Circle(myWin, lineColor='white', fillColor='white', radius=eradius, edges=20, pos=[0,0])
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', units= 'pix')
#OuterCircle= visual.Circle(myWin, lineColor='red', fillColor=None, radius=600, edges=20, pos=[0,0]) 




def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to decide whether they are regular or random')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
def responseCollect(Reg,ResponseScreenVersion):
    event.clearEvents()
    if ResponseScreenVersion == 1:
        responseScreen.setText('Regular      Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'reg'
            if Reg== 0:
                respCorr = 0
            elif Reg== 1:
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'rand'
            if Reg== 0:
                respCorr = 1
            elif Reg == 1:
                respCorr = 0
    elif ResponseScreenVersion == 2:
        responseScreen.setText('Random       Regular')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['l']:
            choice = 'reg'
            if Reg == 0:
                respCorr = 0
            elif Reg == 1:
                respCorr = 1
        elif responseKey == ['a']:
            choice = 'rand'
            if Reg== 0:
                respCorr = 1
            elif Reg == 1:
                respCorr = 0
    return respCorr, choice
## GlassCircular + nonGlassRandom
def getAngle(x,y):
    return math.atan2(y,x) ## 


def getTangetPosition(pos):
    ## For the CircularPatterns 
    x = pos[0]
    y = pos[1]
    a = (math.pi/2) + getAngle(x,y) ## 
    
    x1 = radiusDipole*math.cos(a)
    y1 = radiusDipole*math.sin(a)
    
    x2 = -1*x1
    y2 = -1*y1
    return [x1+x, y1+y], [x2+x, y2+y]
    

def _getEuclidianDistance(a,b=[0,0]): 
    '''    
    distance between two points
    ====================================
    Input:
    
    the function gets two arguments a and b
    
    for the argument "a" it gets a list with two numbers [xPos, yPos], which will be respectively a[0] and a[1]
    and for the argument "b" it gets [0,0] which are b[0] and b[1]
    '''
    try:
        return math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2) ## applies the Pitagora theoreme to give a number which is the hypothenuse (= distance between the points)
    except:
        print ' problem with getting euclidian distance with input values: ', a, b

def _getNextCenterDipolePosition():
    while True:
        xPos = random.randint(-limAllo, limAllo)
        yPos = random.randint(-limAllo, limAllo)
        d = _getEuclidianDistance([xPos, yPos], [0,0]) ## this has two arguments [a0,a1], [b0, b1]
        ## d is the distance between the point [xPos,yPos] and [0,0]
        if segment.contains([xPos, yPos]) and d > 20:
            ## if d is whithin the limit allowed, we can proceed
            return [xPos, yPos]
            
def generateCenterDipolesPattern(nDipoles, btwDip):
    '''
    Input:
    ======
    Takes number of dots as a input, and also the minimum spacing between each dotList
    Output:
    =======
    List of the x-y coordinates of the dots
    '''
    CenterDipoleList = []
    for i in range(nDipoles):
        currentPosition = _getNextCenterDipolePosition() ##we get the coordinates of the center of the dipole
        
        overLapCount = 0
        while overLapCount < len(CenterDipoleList): ## here we check for overlaps 
            currentPosition = _getNextCenterDipolePosition() ##we get the coordinates of the center of the dipole
            if i < 1: ## Don't check if first element in dot list
                pass
            else:
                for CenterPos in CenterDipoleList: ## takes each [x,y] coord in dotlist... 
                    distance = _getEuclidianDistance(CenterPos, currentPosition)## ...calculates the distance between it and CurrentPosition,...
                    if distance < btwDip: ## and if the distance is whitin the spacing limit, or too close to center, then it will keep looping
                        overLapCount = 0 ## assigning a zero on this cycle, will make the total count <len(dotList), so it will have to restart from beginning
                    else:
                        overLapCount += 1
        CenterDipoleList.append(currentPosition) ## currentPosition has been approved. it is far enough from all the other coords of the dotList. 
    return CenterDipoleList

def generateDipoles(nDipoles, btwDip):
    global CenterDips
    global dipoles
    dipoles = dict() ## The dict() constructor builds a dictionary {} in which we will put key:value pairs. 
    ## The key will be the coordinates in 'dots', which refer to the center of the dipole. in p1 and p2 we will draw he two elements of the dipole. (e.g. {'[120,25]': [p1, p2], '[130, 120]':[p1, p2]})
    CenterDips = generateCenterDipolesPattern(nDipoles, btwDip)
    for i in CenterDips:
        cd = str(i) ## takes coordinates at the position i in dots and translates in a string. This is used as key for the dictionary
        dipoles[cd] = [] ## this creates a new key [dot] (e.g. '[120,25]') to which we are going now to assign two values (= the two elements of the dipole).
        #centralDot.setPos(i)
        #centralDot.draw() 
        ## For each key we append two values: two dots that make dipole.
        dipoles[cd].append(e1) ##first head of dipole
        dipoles[cd].append(e2) ##second head of dipole
        ## >>>> Can't find a way to avoid to create a new object for each element.



def GlassCircular():
    for i in  CenterDips:
        cd = str(i)
        p1,p2 = getTangetPosition(i) 
        dipoles[cd][0].setPos(p1) ##first head of dipole
        dipoles[cd][1].setPos(p2) ##second head of dipole
        dipoles[cd][0].draw()  ##first head of dipole
        dipoles[cd][1].draw() ##second head of dipole


def nonGlassRandom(Randots):
    for i in Randots:
        e1.setPos(i)
        e1.draw()

## NonGlasReflection + NonGlassTranslation
def _getNextDotPosition():
    while True:
        xPos = random.randint(-limAllo, 0-btwDip)
        #xPos = random.randint(-limAllo, 0)# this gives dots which can touch the midline
        yPos = random.randint(-limAllo, limAllo)
        d = _getEuclidianDistance([xPos, yPos], [0,0]) ## this has two arguments [a0,a1], [b0, b1]
        ## d is the distance between the point [xPos,yPos] and [0,0]
        if segment.contains([xPos, yPos]) and d > btwDip:
            ## if d is whithin the limit allowed, we can proceed
            return [xPos, yPos]
def generateHalfDotPattern(nDipoles, btwDip):
    '''
    Input:
    ======
    Takes number of dots as a input, and also the minimum spacing between each dotList
    Output:
    =======
    List of the x-y coordinates of the dots
    '''
    
    dots= []
    for i in range(nDipoles):
        currentPosition = _getNextDotPosition() ##we get the coordinates of the center of the dipole
        
        overLapCount = 0
        while overLapCount < len(dots): ## here we check for overlaps 
            currentPosition = _getNextDotPosition() ##we get the coordinates of the center of the dipole
            if i < 1: ## Don't check if first element in dot list
                pass
            else:
                for CenterPos in dots: ## takes each [x,y] coord in dotlist... 
                    distance = _getEuclidianDistance(CenterPos, currentPosition)## ...calculates the distance between it and CurrentPosition,...
                    if distance < btwDip/2: ## and if the distance is whitin the spacing limit, or too close to center, then it will keep looping
                        overLapCount = 0 ## assigning a zero on this cycle, will make the total count <len(dotList), so it will have to restart from beginning
                    else:
                        overLapCount += 1
        dots.append(currentPosition) ## currentPosition has been approved. it is far enough from all the other coords of the dotList. 
    return dots
    
def nonGlassReflection(dotsCoor):
    for i in dotsCoor:
        e1.setPos(i)
        e2.setPos([-i[0], i[1]])
        e1.draw()
        e2.draw()
        
def nonGlassTranslation(dotsCoor):
    translate = (SizePattern/2)+btwDip
    for i in dotsCoor:
        e1.setPos(i)
        e2.setPos([i[0]+translate,i[1]])
        e1.draw()
        e2.draw()


def nonGlassRandom(dotsCoor,dotsCoor1):
    for i in dotsCoor:
        e1.setPos(i)
        e1.draw()
    for i in dotsCoor1:
        e1.setPos([-i[0],i[1]])
        e1.draw()

def RunBlock(trialbook, Reps):
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    myClock= core.Clock()
    trialCounter = 0
    nBlocksToGo = 15
    blockDuration = 24
    baselineDuration = 1.5
    patternDuration = 1.5 
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
                
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
                
        ## This calls some functions at the very beginning so we save some time for the generation of the patterns.
        if pattern == 'nonglassRan' :
            #Randots = generateCenterDipolesPattern(nDipoles*2, btwDip)
            dotsCoor = generateHalfDotPattern(nDipoles, btwDip)
            dotsCoor1 = generateHalfDotPattern(nDipoles, btwDip)
            #print len(Randots)
            #print len(dotsCoor)
        elif pattern == 'nonglassRef' or pattern == 'nonglassTrans':
            dotsCoor = generateHalfDotPattern(nDipoles, btwDip)
            #print len(dotsCoor)
        else: 
            generateDipoles(nDipoles, btwDip)
            #print len(CenterDips)
        
        trialCounter= trialCounter+1
        seedNo= trialCounter 
        
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        fixation.draw()
        myWin.flip()
        
        #t = myClock.getTime()
        w = myClock.getTime() + baselineDuration
        
        ##patterns are created during baselineDuration 
        if pattern == 'glassCirc':
            GlassCircular()
        elif pattern == 'nonglassRan':
            #nonGlassRandom(Randots)
            nonGlassRandom(dotsCoor,dotsCoor1)
        elif pattern == 'nonglassRef':
            nonGlassReflection(dotsCoor)
        elif pattern == 'nonglassTrans':
            nonGlassTranslation(dotsCoor)
            
        fixation.draw()
        while myClock.getTime() < w:
            pass
        #print myClock.getTime() -t
#        centerLineV.draw()
#        centerLineH.draw()
        parallel.setData(trigger)
        myWin.flip()
        parallel.setData(0)
        
        fixation.draw()
        #t = myClock.getTime()
        w = myClock.getTime() + patternDuration
        while myClock.getTime() < w:
            pass
        #print myClock.getTime() -t
        
        respCorr, choice = responseCollect(Reg, ResponseScreenVersion)
        
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        trials.addData('choice', choice)
        trials.addData('respCorr', respCorr)
    #save all data
    trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'filenamexlsx', dataOut=['all_raw'])
    trials.extraInfo =expInfo      
    #trials.saveAsWideText('data/'+filenametxt+'.txt')  
        


##
trialbook= 'GlassExperiment_Holographic.xlsx'
message('HelloPractice')
event.waitKeys('Space')
RunBlock(trialbook, 2)
message('HelloMain')
event.waitKeys('Space')
RunBlock(trialbook, 30)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()