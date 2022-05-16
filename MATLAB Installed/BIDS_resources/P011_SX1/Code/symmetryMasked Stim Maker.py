from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, sound, gui#parallelthese are the psychopy libraries
import math
import visualExtra
#parallel

#parallel.setPortAddress(0x378)#address for parallel port on many machines
#parallel.setData(0)

baselineDurationMax = 1.5
baselineDurationMin = 1.5
radius = 80
angle = 10
jigger =20
ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3
s1 = sound.Sound(200,secs=0.5,sampleRate=44100, bits=16)

expName='SymmetryMasked'
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(allowGUI=False, size=[680,1024], units='pix', fullscr= True)
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

ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=34, color='Black', units= 'pix')
restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
respClock=core.Clock()

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice. You will see three patterns. Your task is to decide whether the presented pattern is reflection or random')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but  longer than the practise. Try not to blink, and keep your eyes on the central fixation cross')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(ResponseScreenLimit, Prompt, correctKey, screenLag, practice):
    #print practice
    ResponseScreen.setText(Prompt)
    ResponseScreen.draw()
    myWin.flip()

    responseKey = event.waitKeys(keyList=['a','l','escape'], maxWait = ResponseScreenLimit)
    respRT = respClock.getTime()
    
    if responseKey ==None:
        respCorr =-1
    else:
        if responseKey[0]  == 'escape':
            event.clearEvents()
            myWin.close
            core.quit()    # to close  and exit

    respCorr = 0

    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
    elif correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
    #print respCorr,correctKey,responseKey
    core.wait(screenLag) # here the words are still on the screen. 
    if respCorr == 0 and practice:
       s1.play()
       core.wait(0.5)
       
        
    return responseKey, respRT, respCorr

def pick_coord_random():
    
    ver =[]
    
    nsteps = 360 /angle
    for i in range(nsteps):
        newradius = radius + randint(-jigger,jigger)
        x = newradius * cos( i * radians(angle))
        y = newradius * sin( i * radians(angle))
        ver.append([x,y])
    
    return ver

def pick_coord_ref():
    
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
    


def drawMyTarget(position):
    maxx =110
    maxy =110
    store =[]
    
    i =0
    for x in range(-maxx,0, 20):
        for y in range(-maxy,0, 20):
            c = (randint(-80,80))/100.
            store.append(c)
            cellTiny.setFillColor([c,c,c])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1

    i=0
    for x in range(maxx, 0, -20):
        for y in range(-maxy,0, 20):
            c = (randint(-80,80))/100.
            c =store[i]
            cellTiny.setFillColor([c,c,c])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1
            
    i=0
    for x in range(-maxx,0, 20):
        for y in range(maxy, 0, -20):

            c = (randint(-80,80))/100.
            c=store[i]
            cellTiny.setFillColor([c,c,c])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1

    i=0
    for x in range(maxx, 0, -20):
        for y in range(maxy,0, -20):

            c = (randint(-80,80))/100.
            c=store[i]
            cellTiny.setFillColor([c,c,c])
            cellTiny.setPos([x,y])
            cellTiny.draw()
            i = i+1
#    frame.draw()

def drawMyTarget2(position):

    v =ndarray.tolist(myTarget.vertices)
#    v = myTarget.vertices
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
    stim.setPos(position)
    stim.setFillColor([-0.5,-0.5,-0.5])
           
    s1 =[]
    for i in range(0, len(v)-1, 1):
        s1 =[]
        s1.append(v[i])
        s1.append(v[i+1])
        s1.append(centre)

        stim.vertices =s1
        stim.draw()

#    for i in v:
#        dot.setPos(i)
#        dot.draw()


def drawNoiseMask(position):
    maxx =110
    maxy =110
    
    for x in range(-maxx,maxx+20, 20):
        for y in range(-maxy,maxy+20, 20):
            c = (randint(-80,80))/100.
            cellTiny.setFillColor([c,c,c])
            cellTiny.setPos([x,y])
            cellTiny.draw()

#    cellTiny.setFillColor([-1,-1,-1])        
#    cellTiny.setPos([-110,-110])
#    cellTiny.draw()
#    cellTiny.setPos([110,110])
#    cellTiny.draw()
#    frame.draw()
    
def drawNoiseMask2(position):
    maxx =100
    maxy =100
    
    for i in range(80):
        x = randint(-maxx,maxy)
        y = randint(-maxx,maxy)
        c = (randint(-100,100))/100.
        diskTiny.setFillColor([c,c,c])        
        diskTiny.setPos([x,y])
        diskTiny.draw()

    c = (randint(-100,100))/100.
    diskTiny.setFillColor([c,c,c])        
    diskTiny.setPos([-maxx,-maxy])
    diskTiny.draw()
    c = (randint(-100,100))/100.
    diskTiny.setFillColor([c,c,c])        
    diskTiny.setPos([maxx,-maxy])
    diskTiny.draw()
    c = (randint(-100,100))/100.
    diskTiny.setFillColor([c,c,c])        
    diskTiny.setPos([-maxx,maxy])
    diskTiny.draw()
    c = (randint(-100,100))/100.
    diskTiny.setFillColor([c,c,c])        
    diskTiny.setPos([maxx,maxy])
    diskTiny.draw()
    
def drawMetaMask(position):

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
    blockDuration = 36
    nBlocksToGo = 12
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
        fixation.draw()
            
        myWin.flip()
        ITI = uniform(baselineDurationMin,baselineDurationMax)
        core.wait(ITI)
        fixation.draw()

#        v1 =pick_coord_random()
#        v2 =pick_coord_ref()
#        v3 =pick_coord_random()
#        v4 =pick_coord_random()
            
        if condition == 'Sym':
            drawMyTarget([0, 0])
        elif condition == 'Rand':
            drawNoiseMask([0, 0])

        #parallel.setData(Trigger)
        myWin.flip()
        myWin.getMovieFrame()
        #parallel.setData(0)
        t = myClock.getTime() + duration
        drawNoiseMask([0, 0])
        while myClock.getTime() < t:
            pass #do nothing
        #parallel.setData(Trigger +100)    # this way stim with trigger 1 has mask trigger 101 and so on
        myWin.flip()
        #parallel.setData(0)
        myWin.getMovieFrame()
        t = myClock.getTime() + durationMask
        while myClock.getTime() < t:
            pass #do nothing
        myWin.flip()
           
        responseKey, respRT, respCorr =responseCollect(ResponseScreenLimit, prompt, correctKey, screenLag, Reps==2)
        trials.addData('respCorr', respCorr)
        
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])
    trials.saveAsWideText(filename+'.txt')

message('HelloPractice')
event.waitKeys(['g'])
runBlock('trialbook.xlsx',1)

myWin.saveMovieFrames('j.png') # useful  screen saver system 
#message('HelloMain')
#event.waitKeys(['g'])
#runBlock('trialbook.xlsx',36)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()