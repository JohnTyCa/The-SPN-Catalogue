from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import core,visual, data, event,  gui#, parallel #these are the psychopy libraries
import visualExtra, random, os
#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

#store info about the experiment
if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error

expName='gerbinoZero'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(size = [1280,1024], allowGUI=False, monitor = 'EEG lab participant', units = 'pix', fullscr= True)


#these lines are very powerful, they create all stimuli using the special functions of psychopy
instruction=visual.TextStim(myWin, text='', pos=[0, 0], height=30, color='black')
prompt=visual.TextStim(myWin, text='', pos=[0, -200], height=32, color='white')
shape =visual.ShapeStim(myWin, lineColor='black')
dot =visual.Circle(myWin, radius=6, fillColor='green')
line =visual.ShapeStim(myWin, lineColor='black', closeShape=False)
fixation =visual.Line(myWin, start=[0,-10], end=[0,10], lineColor='black')
uniform = visual.Rect(myWin, size=(428,428), fillColor='white')
frame = visual.Rect(myWin, height = 160, width= 100, fillColor=None, lineColor='yellow')
stim =visual.ShapeStim(myWin, fillColor=(0.,-1.,-1.), lineColor=None)
myClock = core.Clock()#this creates adn starts a clock which we can later read
#parallel.setData(0)

red =(0.,-0.5,-0.5)   # was black
green =(-0.5,0.,-0.5)   # was white

def message(Type):
    if Type == 'HelloExperiment':
        instruction.setText('Welcome to the Experiment. Press space to start with the practice.')
    elif Type == 'HelloTask':
        instruction.setText('This is the end of the practice. Press space bar to start with the experimental trials.')
    elif Type == 'Goodbye':
        instruction.setText('End of experiment. Press space bar to quit')
    elif Type == 'Break':
        instruction.setText('End of block. Wait for experimenter to check electrodes')
    instruction.draw()
    myWin.flip()
    event.waitKeys(keyList=['space'])

def responseCollect():
    prompt.setPos([-240, -220])
    prompt.setText("1 Red object / 2 Red objects")
    prompt.draw()
    prompt.setPos([240, -220])
    prompt.setText("1 Green object / 2 Green objects")
    prompt.draw()
    prompt.setPos([-240, -250])
    prompt.setText("'a'                 's'")
    prompt.draw()
    prompt.setPos([240, -250])
    prompt.setText("'k'                 'l'")
    prompt.draw()
    myWin.flip()
    t = myClock.getTime()
    responseKey =event.waitKeys(keyList=['a','s','k','l','escape'])
    if responseKey==None: responseKey=['x']
    respRT = myClock.getTime() -t 
    core.wait(0.1) # here the words are still on the screen. 
    
    return respRT, responseKey[0]
    
def drawWithin(c1, c2, c3, c4):

    v = c2 + c3
    v.append(v[0])
#    centre = visualExtra.analysecentroid(v)
           
    s1 =[]
    for i in range(0, len(c2)-1):
        s1 =[]
        s1.append(c2[i])
        s1.append(c2[i+1])
        s1.append(c3[len(c2) - i -2])
        s1.append(c3[len(c2) - i -1])
        
        stim.vertices =s1
        stim.draw()

#    for i in range(len(v)):
#        if i in [0,1,2,3,4,5,6,7,8]:
#            dot.setPos(v[i])
#            dot.draw()

#    shape.draw()
#    frame.draw()

def drawBetween(c1, c2, c3, c4):

    v = c1+c2
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
           
    s1 =[]
    for i in range(0, len(c1)-1):
        s1 =[]
        s1.append(c1[i])
        s1.append(c1[i+1])
        s1.append(c2[len(c1) - i -2])
        s1.append(c2[len(c1) - i -1])
        
        stim.vertices =s1
        stim.draw()

    v = c3+c4
    v.append(v[0])
    centre = visualExtra.analysecentroid(v)
#    stim.setPos(position)
           
    s1 =[]
    for i in range(0, len(c3)-1):
        s1 =[]
        s1.append(c3[i])
        s1.append(c3[i+1])
        s1.append(c4[len(c1) - i -2])
        s1.append(c4[len(c1) - i -1])
        
        stim.vertices =s1
        stim.draw()
#    for i in range(len(v)):
#        if i in [0,1]:
#            dot.setPos(v[i])
#            dot.draw()

#    shape.draw()
#    frame.draw()

def createContour(symmetry):
    
    d = 60
    d2 = 160
    height = 72
    nSteps = 12
    step = height * 2  /nSteps
    maxj = height / 10
    
    c1 = []
    c2 = []
    c3 = []
    c4 = []
    
    for i in range(nSteps +1):
        y = step * (nSteps -i ) - height
        j = int((height - abs(y)) /2)
        x = -d2 + random.randint(-j,j)
        c1.append([x,y])
        
    for i in range(nSteps +1):
        y = step * i - height
        j = int((height - abs(y)) /2)
        x = -d + random.randint(-j,j)
        c2.append([x,y])

    for i in range(nSteps +1):
        y = step * (nSteps -i ) - height
        j = int((height - abs(y)) /2)
        if symmetry:
            x = -c2[nSteps -i][0]
        else:
            x = d + random.randint(-j,j)
        c3.append([x,y])

    for i in range(nSteps +1):
        y = step * i - height
        j = int((height - abs(y)) /2)
        x = d2 + random.randint(-j,j)
        c4.append([x,y])
        
    return c1, c2, c3, c4

def mainLoop(n, book):
    
    blockDuration =24
    trialCounter = 0
    nBlocks = 12
    trials=data.TrialHandler(nReps=n, method='random', trialList=data.importConditions(book)) 
    # This long loop runs through the trials
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting
        
        if trialCounter == blockDuration:
            nBlocks = nBlocks - 1
            message('Break')
            trialCounter = 0
        trialCounter = trialCounter + 1
                
        fixation.draw()#draws fixation
        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible
        
        t = myClock.getTime() + 1.     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing

        c1, c2, c3, c4 = createContour(symmetry = symmetry)
        shape.vertices= c2 + c3
        if thisTrial.co=='red':
            stim.setFillColor(red)
        elif thisTrial.co=='green':
            stim.setFillColor(green)
        
        if cond =='figure':
            drawWithin(c1, c2, c3, c4)
        elif cond =='ground':
            drawBetween(c1, c2, c3, c4)
        line.vertices = c1
        line.draw()
        line.vertices = c2
        line.draw()
        line.vertices = c3
        line.draw()
        line.vertices = c4
        line.draw()
        fixation.draw()#draws fixation
#        parallel.setData(trigger)
#        myWin.flip()
#        parallel.setData(0)

        t = myClock.getTime() + presentation    # presentation for this much time
        while myClock.getTime() < t:
            pass #do nothing
            
        rt, key = responseCollect()
        
        if key =='escape': 
            core.quit()
            event.clearEvents()
            myWin.close
            
        trials.addData('response', key)
        trials.addData('respRt', rt)
        
    #save all data unless it is practice
    if n>1:
        trials.saveAsWideText(filename+'.txt')
        trials.saveAsExcel(filename+'.xlsx', sheetName= 'HorizontalVertical', dataOut=['all_raw'])


message('HelloExperiment')
mainLoop(1, 'GZTrialBookWithColour.xlsx')
message('HelloTask')
mainLoop(36, 'GZTrialBookWithColour.xlsx')
message('Goodbye')
myWin.close()
core.quit()





