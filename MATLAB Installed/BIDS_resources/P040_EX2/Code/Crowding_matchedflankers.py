from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, gui, parallel #these are the psychopy libraries
import math
import visualExtra


parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)

stimDuration =0.2 
stimDuration2 = 1.5
baselineDurationMax = 2
baselineDurationMin = 1.5
radius = 35
angle = 10
jigger = 15
ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3

expName='Crowding'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  

myWin = visual.Window(allowGUI=False, size=[1280,1024], units='pix', fullscr= False)
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=50, color='black')
myTarget =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'black')
dot = visual.Circle(myWin, radius=4, lineColor='black', edges=12)
stim =visual.ShapeStim(myWin, fillColor=[-1,-1,-1], lineColor =None)
#myFlanker =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'black', fillColor = 'black')

ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=34, color='Black', units= 'pix')
restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')

respClock=core.Clock()

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice. You will see either a single pattern on its own or three patterns together. Your task is to decide whether the target (the central pattern in the three pattern configuration) is reflection or random whilst keeping your eyes on the central fixation cross')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but just much longer than the practise. Try not to blink, and keep your eyes on the central fixation cross!')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the experiment')
    elif Type == 'Break':
        message = '%d blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(ResponseScreenLimit, Prompt, correctKey, screenLag):

    ResponseScreen.setText(Prompt)
    ResponseScreen.draw()
    myWin.flip()

    respClock=core.Clock()
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

    core.wait(screenLag) # here the words are still on the screen. 
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
    
#def pick_coord_random2():
#    
#    ver =[]
#    
#    nsteps = 360 /angle
#    for i in range(nsteps):
#        newradius = radius + randint(-jigger,jigger)
#        x = newradius * cos( i * radians(angle))
#        y = newradius * sin( i * radians(angle))
#        ver.append([x,y])
#    
#    return ver
#    
#def pick_coord_random3():
#    
#    ver =[]
#    
#    nsteps = 360 /angle
#    for i in range(nsteps):
#        newradius = radius + randint(-jigger,jigger)
#        x = newradius * cos( i * radians(angle))
#        y = newradius * sin( i * radians(angle))
#        ver.append([x,y])
#    
#    return ver


def drawMyTarget(position):

    v =ndarray.tolist(myTarget.vertices)
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
    stim.setPos(position)
    myTarget.setPos(position)
           
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

    myTarget.draw()

def runBlock(trialbook,Reps):

    trialCounter = 0
    blockDuration = 48
    nBlocksToGo = 10
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

        v1 =pick_coord_ref()
        v2 =pick_coord_ref()
        v3 =pick_coord_ref()
        v4 =pick_coord_random()
        v5 =pick_coord_random()
        v6 =pick_coord_random()

#        condition = 'RandFlankerV'   #debug


        if condition == 'TargetSym':
           myTarget.vertices=v1
           drawMyTarget([250, 0])
        elif condition == 'TargetRand':
           myTarget.vertices =v4
           drawMyTarget([250, 0])
           
        elif condition == 'SymFlankerS':
           myTarget.vertices=v1
           drawMyTarget([150, 0])
           myTarget.vertices=v2
           drawMyTarget([250, 0])
           myTarget.vertices=v3
           drawMyTarget([350, 0])

        elif condition == 'RandFlankerS':
           myTarget.vertices= v1
           drawMyTarget([150, 0])
           myTarget.vertices=v4
           drawMyTarget([250, 0])
           myTarget.vertices=v2
           drawMyTarget([350, 0])
           
        elif condition == 'SymFlankerR':
           myTarget.vertices= v5
           drawMyTarget([150, 0])
           myTarget.vertices=v3
           drawMyTarget([250, 0])
           myTarget.vertices=v4
           drawMyTarget([350, 0])

        elif condition == 'RandFlankerR':
           myTarget.vertices= v4
           drawMyTarget([150, 0])
           myTarget.vertices=v5
           drawMyTarget([250, 0])
           myTarget.vertices=v6
           drawMyTarget([350, 0])
           
        if condition == 'TargetSym1':
           myTarget.vertices=v1
           drawMyTarget([-250, 0])
        elif condition == 'TargetRand1':
           myTarget.vertices =v4
           drawMyTarget([-250, 0])
           
        elif condition == 'SymFlankerS1':
           myTarget.vertices=v1
           drawMyTarget([-150, 0])
           myTarget.vertices=v2
           drawMyTarget([-250, 0])
           myTarget.vertices=v3
           drawMyTarget([-350, 0])

        elif condition == 'RandFlankerS1':
           myTarget.vertices= v1
           drawMyTarget([-150, 0])
           myTarget.vertices=v4
           drawMyTarget([-250, 0])
           myTarget.vertices=v2
           drawMyTarget([-350, 0])
           
        elif condition == 'SymFlankerR1':
           myTarget.vertices= v5
           drawMyTarget([-150, 0])
           myTarget.vertices=v3
           drawMyTarget([-250, 0])
           myTarget.vertices=v4
           drawMyTarget([-350, 0])

        elif condition == 'RandFlankerR1':
           myTarget.vertices= v4
           drawMyTarget([-150, 0])
           myTarget.vertices=v5
           drawMyTarget([-250, 0])
           myTarget.vertices=v6
           drawMyTarget([-350, 0])

        parallel.setData(Trigger)

        myWin.flip()
        a= myClock.getTime()
#        print a
        parallel.setData(0)
#        event.waitKeys(keyList=["a"])

        core.wait(stimDuration)

        myWin.flip()
        b= myClock.getTime()

        tafter =b-a
        print tafter
        
        core.wait(stimDuration2)
        myWin.flip()

        responseKey, respRT, respCorr =responseCollect(ResponseScreenLimit, prompt, correctKey, screenLag)
        trials.addData('respCorr', respCorr)
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)

    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])

myClock = core.Clock()#this creates and starts a clock which we can later read


message('HelloPractice')
event.waitKeys(['g'])
runBlock('trialbookMF.xlsx',1)
message('HelloMain')
event.waitKeys(['g'])
runBlock('trialbookMF.xlsx',20)
message('Goodbye')
core.wait(2)
myWin.close
core.quit()