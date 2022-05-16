#   This is in progress [Adel, 25/06]
#   Need to change the task:
#   from "red or green?"
#   to "which shape? -Symmetry-  -Random-  -Half Shape-  -Occluded Shape-





from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, visual, data, event,  gui,parallel #these are the psychopy libraries
import math
parallel.setPortAddress(0x378)#address for parallel port on many machines
ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3
nsteps =12
parallel.setData(0)

#store info about the experiment
expName='AmodalEEG'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, units='pix', allowStencil=False, size=(1280,1024), fullscr=True, monitor = 'EEG lab participant')#creates a window using pixels as units
fixation=visual.TextStim(myWin, text='o', pos=[0, 0], height=20, color='white')#this is a gray cross for the fixation

colorRed    =(0.,-1.,-1.)   # red
colorGreen =(-1.,0.,-1.)   # green
colorBlack =(-1,-1,-1)    # black
colorGrey =(-0.5,-0.5,-0.5) # grey

color1 =(-1.,0.25,-1.)   # green
color2 =(-1.,0.3,-1.)   # green

stimL =visual.ShapeStim(myWin, lineWidth=1.5, lineColor=None, fillColor=None)
stimR =visual.ShapeStim(myWin, lineWidth=1.5, lineColor=None, fillColor=None)
occluder =visual.ShapeStim(myWin, lineColor=None, fillColor=colorGrey, ori=0, interpolate=True)
occluderTop =visual.ShapeStim(myWin, lineColor=None, fillColor=colorGrey, ori=0, interpolate=True)
occluderBottom =visual.ShapeStim(myWin, lineColor=None, fillColor=colorGrey, ori=0, interpolate=True)
shadow =visual.ShapeStim(myWin, lineColor=None, fillColor=(-0.05,-0.05,-0.05))
stim1 =visual.ShapeStim(myWin, lineColor=None, fillColor=colorBlack)

linea =visual.Rect(myWin, width=100, height=1.5, lineColor=colorBlack, fillColor=None)
marginL =visual.Line(myWin)
marginR =visual.Line(myWin)

instruction=visual.TextStim(myWin, ori=0, text='text', height=34, color='black', units= 'pix')
ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 50], height=34, color='Black', units= 'pix')#height was 34
restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
respClock=core.Clock()
    
def message(Type):
    if Type == 'HelloExperiment':
        instruction.setText('Welcome to the Experiment. Press space to start with the practice.')
    elif Type == 'HelloTask':
        instruction.setText('This is the end of the practice. Press space bar to start with the experimental trials.')
    elif Type == 'Goodbye':
        instruction.setText('End of experiment')
    instruction.draw()
    instruction.setPos((0,0))
    myWin.flip()
    event.waitKeys(keyList=['space'])
    

def responseCollect(ResponseScreenLimit, Prompt, correctKey, screenLag):

    drawBackground()
    ResponseScreen.setText(Prompt)
    ResponseScreen.draw()
    myWin.flip()

    responseKey = event.waitKeys(keyList=['a','z','k','m','escape'], maxWait = ResponseScreenLimit)
    respRT = respClock.getTime()
    
    if responseKey ==None:
        respCorr =-1
    else:
        if responseKey[0]  =='escape':
            event.clearEvents()
            myWin.close
            core.quit()    # to close  and exit
        elif responseKey[0] == correctKey:
            respCorr=1
        else:
            respCorr = 0        

    core.wait(screenLag) # here the words are still on the screen. 
    return responseKey, respRT, respCorr

def drawBackground():
    
    starting = [150*1.06, 0]
    linea.setPos([0,11])
    linea.setWidth(1400)
#    linea.draw()
    ystep =10
    
    for i in range(26):
        p = linea.pos
        ystep = ystep *1.15
        p[1] = 11 -(ystep)
        linea.setPos(p)
        #        linea.setWidth(1.06,"*")
        linea.draw()
        
    ending =[linea.width/2, p[1]]
    marginL.start = starting
    marginL.end =ending
    marginL.draw()
    
    marginR.start = [-starting[0],starting[1]]
    marginR.end =  [-ending[0], ending[1]]
    marginR.draw()    

    
def prepareShape(nsteps, colore, condition, orientation):
    
    height =160
    width =100
    
    # the left side
    coords =[]
    coords.append([0,-height])
    coords.append([-width, -height])
    
    y = -height
    step = (height*2)/nsteps
    for i in range(nsteps-1):
        y = y +step
        x = -width + randint(-40,40)
        coords.append([x,y])

    coords.append([-width, height])
    coords.append([0, height])
    coords.append([randint(-20,20), randint(-20,20)])
    coords.append([0, -height])
    
    #stimL.setVertices(coords)
    stimL.vertices=coords
    
    # the right side
    if condition =='random':
        coords =[]
        coords.append([0,-height])
        coords.append([width, -height])
        
        y = -height
        step = (height*2)/nsteps
        for i in range(nsteps-1):
            y = y +step
            x = width + randint(-40,40)
            coords.append([x,y])
    
        coords.append([width, height])
        coords.append([0, height])
        coords.append([randint(-20,20), randint(-20,20)])
        coords.append([0, -height])
        
        stimR.vertices=coords
        
    else:
        temp = []
        for i in range(len(coords)):
            temp.append([-coords[i][0],coords[i][1]])
        #stimR.setVertices(temp)
        stimR.vertices=temp
    # now the occluder
    coord1 =[]

    coord1.append([coords[0][0],coords[0][1]-40])
    coord1.append([0,0])
    coord1.append([coords[-1][0],coords[-3][1]+40])
    coord1.append([width*2,coords[-3][1]+40])
    coord1.append([width*2,0])
    coord1.append([width*2,coords[0][1]-40])

    for i in coord1[3:6]:
        i[0] = i[0] + randint(-20,20)
        i[1] = i[1] + randint(-20,20)
#    print coord1

    if orientation ==-1:
        fooL = stimL.vertices
        fooR = stimR.vertices
        for index in range(len(coord1)):
            coord1[index][0] = - coord1[index][0]
        for index in range(len(fooL)):
            fooL[index][0] = - fooL[index][0]            
            fooR[index][0] = - fooR[index][0]                     
        occluder.vertices=coord1
        stimL.vertices=fooL
        stimR.vertices=fooR    
    
    t =[]
    t.append(coord1[0])
    t.append(coord1[1])
    t.append(coord1[4])
    t.append(coord1[5])
    occluderTop.vertices=t

    t =[]
    t.append(coord1[1])
    t.append(coord1[2])
    t.append(coord1[3])
    t.append(coord1[4])
    occluderBottom.vertices=t

    shadow.setPos([0,0])
    occluder.setPos([0,0])
    occluderTop.setPos([0,0])
    occluderBottom.setPos([0,0])

#    shadow.setVertices(coord1)
#    shadow.setPos([5,-5],"+")
    
#    if colore=='green':
#        stim1.setFillColor(colorGreen)
#    elif colore=='red':
#        stim1.setFillColor(colorRed)      

def drawShape(nsteps, colore, leftright):

    if leftright =='l':
        temp = stimL.vertices
    elif leftright =='r':
        temp = stimR.vertices

    if colore=='green':
        color1 =(0.,0.8,0.)   # green
        color2 =(0.,0.9,0.)   # green
    elif colore=='red':
        color1 =(0.9,0.,0.)   # red
        color2 =(0.8,0.,0.)   # red
        
    flag =0
    for i in range(nsteps):
        s1 =[]
        s1.append(temp[i+1])
        s1.append(temp[i+2])
        s1.append([0,temp[i+2][1]])
        s1.append([0,temp[i+1][1]])

        if flag==1:
            stim1.setFillColor(color1)
            flag =0
        else:
            stim1.setFillColor(color2)
            flag =1
        stim1.vertices=s1
        stim1.draw()

#    shadow.draw()

def displayOccluder(hshift, vshift):

    if hshift !=0 or vshift !=0:
        occluder.setPos([hshift, vshift],"-")
        occluderTop.setPos([hshift, vshift],"-")
        occluderBottom.setPos([hshift, vshift],"-")
        
#    occluder.draw()
    occluderTop.draw()
    occluderBottom.draw()
    
            
def runBlock(filename):
    #set up handler to look after randomisation of trials etc
    if filename=='data/practice':
        trials=data.TrialHandler(nReps=1, method='random', trialList=data.importConditions('trialbookA.xlsx')) #('trialbookPractice.xlsx')) 
    else:
        trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('trialbookA.xlsx')) #
    
    trials.extraInfo =expInfo  #so we store all relevant info into trials
    myClock = core.Clock()#this creates and starts a clock which we can later read
    trialCounter = 0
    blockCounter = 0
    blockDuration = 32
    noBlocks = 10

    # This long loop runs through the trials
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName) #this lines seem strange but it is just mkes the variables more readable

        orientation =1 # debug        
#        condition ='overlap'   # debug
#        print condition, colore
        
        if trialCounter == blockDuration:
            blockCounter = blockCounter+1
            trialCounter = 0
            block = noBlocks-(blockCounter)
            blockString= "%d blocks to go:     Wait for the experimenter to check electrodes" %(block)
            restScreen.setText(blockString)
            restScreen.draw()
            myWin.flip()
            event.waitKeys(keyList = 'g')
        trialCounter = trialCounter + 1
        
        if fixationPos =='right':
            fixation.setPos((stimSep/4,0))
        elif fixationPos =='left':
            fixation.setPos((-stimSep/4,0))

        drawBackground()        
        fixation.draw()#draws fixation
        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible
        
        t = myClock.getTime() + random() + 1.0     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
        if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
#        fixation.draw()#draws fixation
#        myWin.flip() #debug
#        event.waitKeys(keyList=['z'])   #debug

        fixation.draw()
        prepareShape(nsteps, colore, condition, orientation)
        drawBackground()
#        if orientation ==1:
#            occPosX =-60
#        elif orientation ==-1:
#            occPosX =60
            
#        condition = 'none'
        if condition =='half':
            drawShape(nsteps, colore, 'l')
        elif condition =='full':
            displayOccluder(0, -60)
            drawShape(nsteps, colore, 'r')
            drawShape(nsteps, colore, 'l')
        elif condition =='occluded':
            drawShape(nsteps, colore, 'l')
            drawShape(nsteps, colore, 'r')
            displayOccluder(0, -20)
        elif condition=='overlap':
            displayOccluder(40 * orientation, -60)
            drawShape(nsteps, colore, 'l')
        elif condition=='random':
            displayOccluder(0, -60)
            drawShape(nsteps, colore,'r')
            drawShape(nsteps, colore,'l')
        fixation.draw()
        
        parallel.setData(trigger)
        myWin.flip()
        parallel.setData(0)

        presentation = myClock.getTime() +1.5
        while myClock.getTime()<presentation:
            pass

        responseKey, respRT, respCorr =responseCollect(ResponseScreenLimit, prompt, correctKey, screenLag)
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)
        trials.addData('respCorr',respCorr)

    #save all data
    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'sheet', dataOut=['all_raw'])
    
message('HelloExperiment')
runBlock('data/practice')
message('HelloTask')
runBlock('data/experiment')
message('Goodbye')
myWin.close()
core.quit()




