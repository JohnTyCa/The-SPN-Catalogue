from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, sound, gui#,parallel #these are the psychopy libraries
import math
import visualExtra
#parallel
#
#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

baselineDuration = 1.0
ISI =1.5
durationOne = 0.25
durationTwo = 0.5

radius = 80
angle = 10
jigger =20
ResponseScreenLimit = 60 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3
s1 = sound.Sound(800,secs=0.5,sampleRate=44100, bits=16)

expName='Delayed Discrimination Task'
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

filename= 'dataColor/%s_%s' %(expInfo['participant'], expInfo['date'])

if not os.path.isdir('dataColor'):
    os.makedirs('dataColor')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(allowGUI=False, size=[600,600], units='pix', fullscr= False)
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=50, color='black')
myTarget =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'red')
disk = visual.Circle(myWin, radius=100, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
diskSmall = visual.Circle(myWin, radius=80, lineColor=None, fillColor=[0,0,0])
diskTiny = visual.Circle(myWin, radius=8, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
cellTiny = visual.Rect(myWin, width=20, height=20, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
frame = visual.Rect(myWin, width=200, height=200, lineColor=[1,-1,-1], fillColor=None)

#stim =visual.ShapeStim(myWin, fillColor=[-1,-1,-1], lineColor =None)
stim =visual.ShapeStim(myWin, fillColor=[1,-1,-1], lineColor =None)
#myFlanker =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'black', fillColor = 'black')

ResponseScreen=visual.TextBox(myWin, text = 'Same Color        Do Not Know        Different Color', textgrid_shape=[70,3], pos=[0, 0], grid_horz_justification='center', grid_vert_justification='center', font_size=20,font_color = 'white',  units= 'pix')
restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
feedbackScreen =  visual.TextStim(myWin, ori=0, text='x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
totalScreen =  visual.TextStim(myWin, ori=0, text='x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
respClock=core.Clock()

def rewardSound():
    s1 = sound.Sound(200,secs=0.2,sampleRate=44100, bits=16)
    s2 = sound.Sound(250,secs=0.2,sampleRate=44100, bits=16)
    s3 = sound.Sound(300,secs=0.2,sampleRate=44100, bits=16)
    s1.play()
    core.wait(0.2)
    s2.play()
    core.wait(0.2)
    s3.play()
    core.wait(0.2)
    

def punishmentSound():
    s1 = sound.Sound(150,secs=0.6,sampleRate=44100, bits=16)
    s1.play()
    core.wait(0.6)



def message(Type, nBlocksToGo = 1, total= 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice. You will see two patterns. You task is to decide whether they were the same or different')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but  longer than the practice. Try not to blink, and keep your eyes on the central fixation cross')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the experiment')
    elif Type == 'Break':
        message = 'You have %s points! %s Blocks to go: Wait for experimenter to check electrodes' %(total,nBlocksToGo)
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(correctKey):
    ResponseScreen.draw()
    myWin.flip()

    responseKey = event.waitKeys(keyList=['z','v','m'])
    respRT = respClock.getTime()
    
    if responseKey ==None:
        respCorr =-1
    else:
        if responseKey[0]  == 'escape':
            event.clearEvents()
            myWin.close
            core.quit()    # to close  and exit

    respCorr = -1
    if correctKey == 'z':
        if responseKey == ['z']: 
            respCorr=1
    elif correctKey == 'm':
        if responseKey == ['m']:
            respCorr=1
    
    if responseKey == ['v']:
        respCorr = 0
    #print respCorr,correctKey,responseKey
    core.wait(screenLag) # here the words are still on the screen. 
    if respCorr == 1:
       feedbackScreen.setText('you win 1 point :)')
       feedbackScreen.setColor('green')
       feedbackScreen.draw()
       myWin.flip()
       rewardSound()
    if respCorr == -1:
        feedbackScreen.setText('you lose 1 point :(')
        feedbackScreen.setColor('red')
        feedbackScreen.draw()
        myWin.flip()
        punishmentSound()
       
        
    return responseKey, respRT, respCorr

def pick_coord_random(seedNO):
    seed(seedNo)
    ver =[]
    
    nsteps = 360 /angle
    for i in range(nsteps):
        newradius = radius + randint(-jigger,jigger)
        x = newradius * cos( i * radians(angle))
        y = newradius * sin( i * radians(angle))
        ver.append([x,y])
    
    return ver

def pick_coord_ref(seedNo):
    seed(seedNo)
    ver =[]
    
    nsteps = 360 /angle
    for i in range(nsteps):
        newradius = radius + randint(-jigger,jigger)
        x = newradius * cos( i * radians(angle))
        y = newradius * sin( i * radians(angle))
        ver.append([x,y])
    
    nstepsQuad =nsteps /4
    for i in range(nstepsQuad):
        ver[ -i][0] = ver[i][0]
        ver[ -i][1] = -ver[i][1]
               
    for i in range(nstepsQuad):
        ver[ nstepsQuad*2 -i -1][0] = -ver[i][0]
        ver[ nstepsQuad*2 -i -1][1] = ver[i][1]
        
    for i in range(nstepsQuad +1):
        ver[ nstepsQuad*2 +i][0] = -ver[i][0]
        ver[ nstepsQuad*2 +i][1] = -ver[i][1]
        
    return ver
    



def drawMyTarget(position,seedNo,col):
    seed(seedNo)
    maxx =110
    maxy =110
    store =[]
    cx = 1
    i =0
    for x in range(-maxx,0, 20):
        for y in range(-maxy,0, 20):
            c = (randint(-80,80))/100.
            store.append(c)
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1

    i=0
    for x in range(maxx, 0, -20):
        for y in range(-maxy,0, 20):
            c = (randint(-80,80))/100.
            c =store[i]
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1
            
    i=0
    for x in range(-maxx,0, 20):
        for y in range(maxy, 0, -20):
            c = (randint(-80,80))/100.
            c=store[i]
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1

    i=0
    for x in range(maxx, 0, -20):
        for y in range(maxy,0, -20):
            c = (randint(-80,80))/100.
            c=store[i]
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1
#    frame.draw()


def drawNoiseMask(position,seedNo,col):
    seed(seedNo)
    maxx =110
    maxy =110
    cx = 1
    for x in range(-maxx,maxx+20, 20):
        for y in range(-maxy,maxy+20, 20):
            c = (randint(-80,80))/100.
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()
    seed(seedNo)
    v =ndarray.tolist(myTarget.vertices)
#    v = myTarget.vertices
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
    stim.setPos(position)
    stim.setFillColor([0,0,0])

def drawNoiseMask2(position,seedNo,col):
    seed(seedNo)
    maxx =140
    maxy =140
    cx = 1
    for x in range(-maxx,maxx+20, 20):
        for y in range(-maxy,maxy+20, 20):
            c = (randint(-80,80))/100.
            if col == 0:
                cx = c
            cellTiny.setFillColor([c,c,cx])
            cellTiny.setPos([x,y])
            cellTiny.draw()

#    cellTiny.setFillColor([-1,-1,-1])        
#    cellTiny.setPos([-110,-110])
#    cellTiny.draw()
#    cellTiny.setPos([110,110])
#    cellTiny.draw()
#    frame.draw()
def drawMetaMask(position,seedNO):
    seed(seedNo)
    v =ndarray.tolist(myTarget.vertices)
#    v = myTarget.vertices
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
    stim.setPos(position)
    stim.setFillColor([0,0,0])
    disk.draw()
    diskSmall.draw()
    
#    s1 =[]
#    for i in range(0, len(v)-1, 1):
#        s1 =[]
#        s1.append(v[i])
#        s1.append(v[i+1])
#        s1.append(centre)
#
#        stim.vertices =s1
#        stim.draw()


    
def runBlock(trialbook,Reps):
    trialCounter = 0
    total = 0
    blockDuration = 32
    nBlocksToGo = 2
    if Reps > 1: # not practice
        nBlocksToGo = 20
    myClock = core.Clock()
    trials=data.TrialHandler(nReps=Reps, method='sequential', trialList=data.importConditions(trialbook))

    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break', nBlocksToGo = nBlocksToGo, total=total)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1
       
            

        seed1 = randint(1000000000)
        if Same == 1:
            seed2 = seed1
        elif Same == 0:
            seed2 = randint(1000000000)
            while seed1 == seed2:
                seed2 = randint(1000000000)
        
        maskSeed = randint(1000000000)
        
        while maskSeed == seed1 or maskSeed == seed2:
                maskSeed = randint(1000000000)
#        print seed1
#        print seed2
        fixation.draw()
        myWin.flip()
        core.wait(baselineDuration)

        # standardPresentation
        if standard == 'Sym':
            drawMyTarget([0, 0],seed1,colOne)
        elif standard == 'Rand':
            drawNoiseMask([0, 0],seed1,colOne)
        #parallel.setData(Trigger1)
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        t = myClock.getTime() + durationOne
        fixation.draw()
        drawNoiseMask2([0, 0],maskSeed,0)
        while myClock.getTime() < t:
            pass #do nothing
        
        
        # Gap between standard and test
        #parallel.setData(Trigger2)
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        t = myClock.getTime() + ISI
        if test == 'Sym':
            drawMyTarget([0, 0],seed2,colTwo)
        elif test== 'Rand':
            drawNoiseMask([0, 0],seed2,colTwo)
        while myClock.getTime() < t:
            pass #do nothing
            
        # Test presentation!
        #parallel.setData(Trigger3)
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        t = myClock.getTime() + durationTwo
        while myClock.getTime() < t:
            pass #do nothing
        
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
            

message('HelloPractice')
event.waitKeys(keyList=['g'])
runBlock('DDtrialbookCol.xlsx',1)
myWin.saveMovieFrames('image.png')
myWin.close
core.quit()