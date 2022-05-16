from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, gui #,parallel
from pyglet.gl import * #a graphic library
import random
import math

#parallel.setPortAddress(0x378)#address for parallel port on many machines
#parallel.setData(0)


expName='GlassesExperiment_Behavioural_RT'#from the Builder filename that created this script
expInfo={'booth':1,'participant':'name', 'number':'','order': 1}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filenamexlsx= 'data/%s_%s_%s' %(expInfo['booth'],expInfo['participant'], expInfo['date'])
filenametxt= expName 

expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName 

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  


if expInfo['booth'] == 1 or expInfo['booth'] == 2 or expInfo['booth'] == 3 or expInfo['booth'] == 4 or expInfo['booth'] == 5:
    screensizex= 600#1600
    screensizey = 550#900
if expInfo['booth']== 6 or expInfo['booth']== 10:
    screensizex= 1280
    screensizey = 1024
    
myWin = visual.Window(units='pix',size=(screensizex,screensizey))#monitor='testMonitor',


'''
There are two options to set the LimitAllowed 
1. you give the radius of the circle within which elements are allocated
2. sets the radius of the circle circumscribed around the pattern square (segment) within which elements are allocated
    This setting is same as holographic paper.
'''
limAllo=250 ## 1. maximum distance allowed for a dipole from the center 

#SizePatternSquare=400 ## size of the pattern square
#limAllo= int(math.sqrt(2*(SizePatternSquare**2))) ## 2.This sets the radius of the circle circumscribed around the pattern square
#xSq= ySq = SizePatternSquare/2 
#segment= visual.ShapeStim(myWin, vertices = [[-xSq, -ySq],[-xSq, ySq],[xSq, ySq],[xSq, -ySq]], closeShape = True, fillColor = None,lineColor = 'black', ori =0)


 ## set this for higher density patterns
radiusDipole = 3 ##distance between element of dipole and centre of dipole
eradius=1.5 ##radius of each dot-element of the dipole

#A= (2*limAllo)*(2*limAllo)
#a= (2*radiusDipole)*(2*radiusDipole)
#print  A/ag

nDipoles= 50## N of dipoles ~40% dots density # 100 dipoles on each side from vertical axis

btwDip = 10 ## min distance between dipoles

# ## Set these if you want patterns same as holographic paper
#radiusDipole = 6 ##distance between element of dipole and centre of dipole
#eradius=3 ##radius of each dot-element of the dipole
#nDipoles= 50 ## N of dipoles
#btwDip = 15 ## min distance between dipoles

##
fixation = visual.TextStim(myWin, ori=0,text = '+', pos=[0, 1], height=30, color='red', units= 'pix')
centralDot = visual.Circle(myWin, lineColor='red', fillColor='red', radius=eradius/2, edges=20, pos=[0,0]) 
e1= visual.Circle(myWin, lineColor='white', fillColor='white', radius=eradius, edges=20, pos=[0,0])
#e2=  visual.Circle(myWin, lineColor='black', fillColor='black', radius=eradius, edges=20, pos=[0,0])
e2= visual.Circle(myWin, lineColor='white', fillColor='white', radius=eradius, edges=20, pos=[0,0])
circle= visual.Circle(myWin, lineColor='red', fillColor= None, radius=(btwDip/2), edges=20, pos=[0,0])
bigcircle= visual.Circle(myWin, lineColor='red', fillColor= None, radius=limAllo+(btwDip/2), edges=20, pos=[0,0])
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 300], height=30, color='white', units= 'pix')
##
ResponseScreenVersion = expInfo['order']
if ResponseScreenVersion == 1:
    responseScreen.setText('Regular      Random')
if ResponseScreenVersion == 2:
    responseScreen.setText('Random      Regular')
##
centerLineV = visual.Line(myWin, start=(0, -500), end=(0, 500))
centerLineH = visual.Line(myWin, start=(-1000, 0), end=(1000,0))

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to classify whether they are regular or random, AS FAST AS YOU CAN. Press Spacebar to start')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Press spacebar to start')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: press "G" to carry on' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
def responseCollect(Reg,ResponseScreenVersion):
    event.clearEvents()
    responseKey = event.waitKeys(keyList=['a', 'l'])
    if ResponseScreenVersion == 1:
         
        responseScreen.setText('Regular      Random')
        responseScreen.draw()
        myWin.flip()
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
        #responseKey = event.waitKeys(keyList=['a', 'l']) 
        responseScreen.setText('Random       Regular')
        responseScreen.draw()
        myWin.flip()
        
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
    
def getAngle(x,y):
    return math.atan2(y,x) ## 
def getRandomPosition(pos):
    ## This gets a random position of the elements of the dipole around the center
    x = pos[0]
    y = pos[1]
    angle = math.radians(random.randint(0,360)) ## generates an angle.
    x1 = radiusDipole*math.cos(angle) ## cos(angle) = x1/radius 
    y1 = radiusDipole*math.sin(angle) ## sin(angle) = y1/radius 
    x2 = -1*x1
    y2 = -1*y1
    return [x1+x, y1+y],[x2+x, y2+y]
    
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
    
def getTranslationPositionOri(pos,ori=0):
    x= pos[0]
    y= pos[1]
    angle = math.radians(ori)
    x1=  radiusDipole*math.cos(angle) ## cos(angle) = x1/radius 
    y1 = radiusDipole*math.sin(angle) ## sin(angle) = y1/radius 
    x2 = -1*x1
    y2 = -1*y1
    return [x1+x, y1+y],[x2+x, y2+y]
    
def getRadialPosition(pos):
    x = pos[0]
    y = pos[1]
    a = getAngle(x,y) ## 
    
    ##
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
        print ' problem with getting eulidian distance with input values: ', a, b

def _getNextCenterDipolePosition(): #edit this function depending on the LimAllo settings 
    while True:
        xPos = randint(-limAllo, 0)#limAllo)
        yPos = randint(-limAllo, limAllo)
        d = _getEuclidianDistance([xPos, yPos], [0,0]) ## this has two arguments [a0,a1], [b0, b1]
        ## d is the distance between the point [xPos,yPos] and [0,0]
        ##Edit the if statement below depending on LimAllo settings
        #if segment.contains([xPos, yPos]) and d > 20:
        if d < limAllo and d > btwDip*2:
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
                    if distance < btwDip:  ## and if the distance is whitin the spacing limit, or too close to center, then it will keep looping
                        overLapCount = 0 ## assigning a zero on this cycle, will make the total count <len(dotList), so it will have to restart from beginning
                    else:
                        overLapCount += 1
        CenterDipoleList.append(currentPosition) ## currentPosition has been approved. it is far enough from all the other coords of the dotList. 
    return CenterDipoleList
    
def generateDipoles(nDipoles, btwDip):
    dipoles1 = dict()
    dipoles2 = dict()## The dict() constructor builds a dictionary {} in which we will put key:value pairs. 
    ## The key will be the coordinates in 'dots', which refer to the center of the dipole. in p1 and p2 we will draw he two elements of the dipole. (e.g. {'[120,25]': [p1, p2], '[130, 120]':[p1, p2]})
    CenterDips1 = generateCenterDipolesPattern(nDipoles, btwDip)
    for i in CenterDips1:
        cd = str(i) ## takes coordinates at the position i in dots and translates in a string. This is used as key for the dictionary
        dipoles1[cd] = [] ## this creates a new key [dot] (e.g. '[120,25]') to which we are going now to assign two values (= the two elements of the dipole).
        #centralDot.setPos(i)
        #centralDot.draw() 
        ## For each key we append two values: two dots that make dipole.
        dipoles1[cd].append(e1) ##first head of dipole
        dipoles1[cd].append(e2) ##second head of dipole
        ## >>>> Can't find a way to avoid to create a new object for each element.
    CenterDips2 = generateCenterDipolesPattern(nDipoles, btwDip)
    for i in CenterDips2:
        i[0]= -i[0]
        cd = str(i) ## takes coordinates at the position i in dots and translates in a string. This is used as key for the dictionary
        dipoles2[cd] = [] ## this creates a new key [dot] (e.g. '[120,25]') to which we are going now to assign two values (= the two elements of the dipole).
        #centralDot.setPos(i)
        #centralDot.draw() 
        ## For each key we append two values: two dots that make dipole.
        dipoles2[cd].append(e1) ##first head of dipole
        dipoles2[cd].append(e2) ##second head of dipole
        ## >>>> Can't find a way to avoid to create a new object for each element.
    return CenterDips1, dipoles1, CenterDips2, dipoles2
    
def GlassRandom(CenterDips1, dipoles1, CenterDips2, dipoles2):
    for i in CenterDips1:
        cd = str(i) 
        p1,p2 = getRandomPosition(i) ## p1 and p2 will be the coordinates of the two elements of the dipole.
        ## GetRandomPosition creates random location for one element (and specular location for the other element) respect to the coordinate [i], whcih is the center of the dipole
        dipoles1[cd][0].setPos(p1) ##first head of dipole
        dipoles1[cd][1].setPos(p2) ##second head of dipole
        dipoles1[cd][0].draw()  ##first head of dipole
        dipoles1[cd][1].draw() ##second head of dipole
    for i in CenterDips2:
        cd = str(i)
        p1,p2 = getRandomPosition(i)
        dipoles2[cd][0].setPos(p1) ##first head of dipole
        dipoles2[cd][1].setPos(p2) ##second head of dipole
        dipoles2[cd][0].draw()  ##first head of dipole
        dipoles2[cd][1].draw() ##second head of dipole
        
        
def GlassRadial(CenterDips1, dipoles1, CenterDips2, dipoles2):
    for i in CenterDips1:
        cd = str(i)
        p1,p2 = getRadialPosition(i) 
        dipoles1[cd][0].setPos(p1) ##first head of dipole
        dipoles1[cd][1].setPos(p2) ##second head of dipole
        dipoles1[cd][0].draw()  ##first head of dipole
        dipoles1[cd][1].draw() ##second head of dipole
    for i in CenterDips2:
        cd = str(i)
        p1,p2 = getRadialPosition(i) 
        dipoles2[cd][0].setPos(p1) ##first head of dipole
        dipoles2[cd][1].setPos(p2) ##second head of dipole
        dipoles2[cd][0].draw()  ##first head of dipole
        dipoles2[cd][1].draw() ##second head of dipole
        
def GlassCircular(CenterDips1, dipoles1, CenterDips2, dipoles2):
    for i in  CenterDips1:
        cd = str(i)
        p1,p2 = getTangetPosition(i) 
        dipoles1[cd][0].setPos(p1) ##first head of dipole
        dipoles1[cd][1].setPos(p2) ##second head of dipole
        #circle.setPos(i)
        dipoles1[cd][0].draw()  ##first head of dipole
        dipoles1[cd][1].draw() ##second head of dipole
        #circle.draw()
    for i in  CenterDips2:
        cd = str(i)
        p1,p2 = getTangetPosition(i) 
        dipoles2[cd][0].setPos(p1) ##first head of dipole
        dipoles2[cd][1].setPos(p2) ##second head of dipole
        #circle.setPos(i)
        dipoles2[cd][0].draw()  ##first head of dipole
        dipoles2[cd][1].draw() ##second head of dipole
        #circle.draw()
def GlassTranslation(CenterDips1, dipoles1, CenterDips2, dipoles2):
    for i in CenterDips1:
        cd = str(i)
        p1,p2 = getTranslationPosition(i)
        dipoles1[cd][0].setPos(p1) ##first head of dipole
        dipoles1[cd][1].setPos(p2) ##second head of dipole
        dipoles1[cd][0].draw()  ##first head of dipole
        dipoles1[cd][1].draw() ##second head of dipole
    for i in CenterDips2:
        cd = str(i)
        p1,p2 = getTranslationPosition(i)
        dipoles2[cd][0].setPos(p1) ##first head of dipole
        dipoles2[cd][1].setPos(p2) ##second head of dipole
        dipoles2[cd][0].draw()  ##first head of dipole
        dipoles2[cd][1].draw() ##second head of dipole
        
def GlassTranslationOri(CenterDips1, dipoles1, CenterDips2, dipoles2,ori):
    for i in CenterDips1:
        cd = str(i)
        p1,p2 = getTranslationPositionOri(i,ori)
        dipoles1[cd][0].setPos(p1) ##first head of dipole
        dipoles1[cd][1].setPos(p2) ##second head of dipole
        dipoles1[cd][0].draw()  ##first head of dipole
        dipoles1[cd][1].draw() ##second head of dipole
    for i in CenterDips2:
        cd = str(i)
        p1,p2 = getTranslationPositionOri(i,ori)
        dipoles2[cd][0].setPos(p1) ##first head of dipole
        dipoles2[cd][1].setPos(p2) ##second head of dipole
        dipoles2[cd][0].draw()  ##first head of dipole
        dipoles2[cd][1].draw() ##second head of dipole
        

# This is to build Reflection patterns with same logic as the Glasses 
def _getDipPos_ForRef(pos,pos1):
    ## This gets a random position of the elements of the dipole around the center
    angle = math.radians(randint(0,360)) ## generates an angle.
    x1 = radiusDipole*math.cos(angle) ## cos(angle) = x1/radius 
    y1 = radiusDipole*math.sin(angle) ## sin(angle) = y1/radius 
    x2 = -1*x1
    y2 = -1*y1
    return [x1+pos[0], y1+pos[1]] , [x2+pos[0], y2+pos[1]] , [x2+pos1[0], y1+pos1[1]] , [x1+pos1[0], y2+pos1[1]]
    
def generateCenterDipolesPattern_ForReflection(nDipoles, btwDip):
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
        currentPosition = _getNextCenterDipolePosition()  ##we get the coordinates of the center of the dipole
        
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
        CenterDipoleList.append(currentPosition)## currentPosition has been approved. it is far enough from all the other coords of the dotList. 
        Op= [-currentPosition[0],currentPosition[1]]
        CenterDipoleList.append(Op)
    return CenterDipoleList
    
def generateDipoles_ForReflection(nDipoles, btwDip):
    global CenterDips
    global dipoles
    dipoles = dict() ## The dict() constructor builds a dictionary {} in which we will put key:value pairs. 
    ## The key will be the coordinates in 'dots', which refer to the center of the dipole. in p1 and p2 we will draw he two elements of the dipole. (e.g. {'[120,25]': [p1, p2], '[130, 120]':[p1, p2]})
    CenterDips = generateCenterDipolesPattern_ForReflection(nDipoles/2, btwDip)
    for i in CenterDips:
        cd = str(i) ## takes coordinates at the position i in dots and translates in a string. This is used as key for the dictionary
        dipoles[cd] = [] ## this creates a new key [dot] (e.g. '[120,25]') to which we are going now to assign two values (= the two elements of the dipole).
#        centralDot.setPos(i)
#        centralDot.draw() 
        ## For each key we append two values: two dots that make dipole.
        dipoles[cd].append(e1) ##first head of dipole
        dipoles[cd].append(e2) ##second head of dipole
        ## >>>> Can't find a way to avoid to create a new object for each element.
    return CenterDips, dipoles
def GlassReflection(CenterDips, dipoles):
    i= 0
    while i < len(CenterDips):
        cp= CenterDips[i]
        cp1= CenterDips[i+1]
        cd = str(cp)#str(i) 
        cd1 =str(cp1)
        p1, p2, p3, p4= _getDipPos_ForRef(CenterDips[i], CenterDips[i+1]) 
        ## p1 and p2 will be the coordinates of the two elements of the dipole. 
        ## GetRandomPosition creates random location for one element (and specular location for the other element) respect to the coordinate [i], whcih is the center of the dipole
        dipoles[cd][0].setPos(p1) ##first head of dipole
        dipoles[cd][1].setPos(p2) ##second head of dipole
        dipoles[cd][0].draw()  ##first head of dipole
        dipoles[cd][1].draw() ##second head of dipole
        dipoles[cd1][0].setPos(p3) ##first head of dipole
        dipoles[cd1][1].setPos(p4) ##second head of dipole
        dipoles[cd1][0].draw()  ##first head of dipole
        dipoles[cd1][1].draw() ##second head of dipole
        i=i+2
# #


# NonGlassReflection, NonGlassRandom, NonGlassTranslation
def _getNextDotPosition():#edit this function depending on the LimAllo settings 
    while True:
        xPos = randint(-limAllo, 0)
        yPos = randint(-limAllo, limAllo)
        d = _getEuclidianDistance([xPos, yPos], [0,0]) ## this has two arguments [a0,a1], [b0, b1]
        ## d is the distance between the point [xPos,yPos] and [0,0]
        
        ##Edit the if statement below depending on LimAllo settings
        #if segment.contains([xPos, yPos]) and d > btwDip:
        if d < limAllo and d >btwDip*2:
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
    CenterDipoleList = []
    for i in range(nDipoles):
        currentPosition = _getNextDotPosition() ##we get the coordinates of the center of the dipole
        
        overLapCount = 0
        while overLapCount < len(CenterDipoleList): ## here we check for overlaps 
            currentPosition = _getNextDotPosition() ##we get the coordinates of the center of the dipole
            if i < 1: ## Don't check if first element in dot list
                pass
            else:
                for CenterPos in CenterDipoleList: ## takes each [x,y] coord in dotlist... 
                    distance = _getEuclidianDistance(CenterPos, currentPosition)## ...calculates the distance between it and CurrentPosition,...
                    if distance < btwDip/2: ## and if the distance is whitin the spacing limit, or too close to center, then it will keep looping
                        overLapCount = 0 ## assigning a zero on this cycle, will make the total count <len(dotList), so it will have to restart from beginning
                    else:
                        overLapCount += 1
        CenterDipoleList.append(currentPosition) ## currentPosition has been approved. it is far enough from all the other coords of the dotList. 
    return CenterDipoleList
    
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
# #
    
# #
def RunBlock(trialbook, session, Reps):
    
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    trials.extraInfo = expInfo  #so we store all relevant info into trials
    thisTrial=trials.trialList[0]#so we can initialise stimuli with some values
    
    myClock= core.Clock()
    trialCounter = 0
    nBlocksToGo = 15
    blockDuration = 32
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
                
#        pattern = 'glassTrans'
#        ori= 162
                
        trialCounter= trialCounter+1
        if session == 'practice':
            #seed(trialCounter+1000) 
            seed(seedNo)
        if session == 'experiment':
            seed(seedNo)
            
        ## This calls some functions at the very beginning so we save some time for the generation of the patterns.
        if pattern == 'glassRef':
            CenterDips, dipoles= generateDipoles_ForReflection(nDipoles, btwDip)
        else:
            CenterDips1, dipoles1, CenterDips2, dipoles2 = generateDipoles(nDipoles/2, btwDip)
            
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        fixation.draw()
        myWin.flip()
        
        w = myClock.getTime() + baselineDuration
        
        responseScreen.draw()
        
        if pattern == 'glassRan':
            GlassRandom(CenterDips1, dipoles1, CenterDips2, dipoles2)
        elif pattern == 'glassTrans':
            GlassTranslationOri(CenterDips1, dipoles1, CenterDips2, dipoles2,ori)#ori = 0 for only horizontal 
        elif pattern == 'glassCirc':
            GlassCircular(CenterDips1, dipoles1, CenterDips2, dipoles2)
        elif pattern == 'glassRad':
            GlassRadial(CenterDips1, dipoles1, CenterDips2, dipoles2)
        elif pattern == 'glassRef':
            GlassReflection(CenterDips, dipoles)
            
        fixation.draw()
        while myClock.getTime() < w:
            pass
            
#        centerLineV.draw()
#        centerLineH.draw()
#        bigcircle.draw()
        myWin.flip()
        print pattern
        myWin.getMovieFrame()
        fname = '%s_%s.png' %((pattern),(ori))
        myWin.saveMovieFrames(fname)
    
        w = myClock.getTime()
        respCorr, choice = responseCollect(Reg, ResponseScreenVersion)
        respTime = myClock.getTime()-w
        
        
#        fixation.draw()
#        w = myClock.getTime() + patternDuration
#        while myClock.getTime() < w:
#            pass
            
#        w = myClock.getTime()
#        respCorr, choice = responseCollect(Reg, ResponseScreenVersion)
#        respTime = myClock.getTime()-w
        
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            
        trials.addData('respTime', respTime)
        trials.addData('choice', choice)
        trials.addData('respCorr', respCorr)
        
        
    if session == 'experiment': #save all data
        trials.saveAsExcel(filenamexlsx+'.xlsx', sheetName= 'filenamexlsx', dataOut=['all_raw'])
        #trials.extraInfo =expInfo      
        #trials.saveAsWideText('data/'+filenametxt+'.txt')   
 
        
trialbookP= 'GlassesExperiment_Figures.xlsx'
trialbookE= 'GlassesExperiment.seed.xlsx'

message('HelloPractice')
event.waitKeys('Space')
RunBlock(trialbookP, 'practice', 1)
message('HelloMain')
event.waitKeys('Space')
RunBlock(trialbookE,'experiment', 1)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()