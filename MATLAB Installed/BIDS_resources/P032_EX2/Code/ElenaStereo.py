from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy
from psychopy import gui, visual, core, data, event, clock
import os  # handy system and path functions
import visualExtra

expName='ElenaStereo'
expInfo={'name':'','number':1}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: 
    core.quit() #user pressed cancel
    
#store info about the experiment
if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/datafile'

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
#random.seed(seedN)

verticalSize = 900
myWin = visual.Window(allowGUI=False, units='pix', color='white', size=(800,verticalSize), allowStencil=True, viewScale=[1.0,0.5], fullscr= True, screen = 1)#creates a window using pixels as units
#myWin = visual.Window(allowGUI=False, units='pix', color='white', size=(800,verticalSize), viewScale=[1.0,0.5])#creates a window using pixels as units

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='Grey')#this is a gray cross for the fixation
red = visual.Rect(myWin, size=(220,220), pos=[0,0], fillColor='red')
blue = visual.Rect(myWin, size=(100,100), pos=[0,0], fillColor='blue')
myTexture = numpy.random.randint(0,2,(16,16))*2-1
rds1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
rds2 = visual.GratingStim(myWin, tex=myTexture, size=[256,256])
rds3 = visual.Aperture(myWin, units="pix", shape=[[-60,-60],[-60,20],[40,0]])
rds4 = visual.GratingStim(myWin, tex=myTexture, size=[256,256])

myClock = core.Clock()#this creates adn starts a clock which we can later read

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

def createWithin(c1, c2, c3, c4):

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
        
    rds3.shape =s1
        
def drawEye(disp, shift):

    print(disp, shift)
    rds3.enable=False
    rds1.setPos([0,shift])
    rds1.draw()
    
#    rds3.enable=True
#    rds3.setPos([disp,shift])    
    rds2.setPos([disp,shift])
    rds2.draw()
        
    rds3.enable=True
#    rds3.pos =[disp,shift]   
    rds3.enable=False
    
# This long loop runs through the trials
def mainLoop():

    #set up handler to look after randomisation of trials etc
    trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('book.xlsx')) 
    upshift = verticalSize/2
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        
        c1, c2, c3, c4 =createContour(symmetry)
        createWithin(c1,c2,c3,c4)
        
        rds3.enabled = False
        myTexture = numpy.random.randint(0,2,(128,128))*2-1   #between -1 and 1
        rds1.setTex(myTexture)
        myTexture = numpy.random.randint(0,2,(64,64))-1    #between -0.5 and 0.5
        rds2.setTex(myTexture)
        fixation.draw()#draws fixation
        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible

        cc =visualExtra.generateSymmetry(symmetry='r', axes=1, ndots=16, radius=80, minDist=1, gapAxis=40)
        cc = [visualExtra.polar2cartesian(i[0],i[1]) for i in cc]    # get cartesian coordinates
        rds3.shape=[[-20,-20],[-20,20],[40,0]]
        
        t = myClock.getTime() + 0.6     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
        
#        drawEye(0, -upshift)
#        drawEye(40, upshift)

        rds1.setPos([0, -upshift])
        rds1.draw()
        rds3.pos= [0, -upshift]
        rds3.enabled = True
        rds2.setPos([0, -upshift])
        rds2.draw()

        rds3.enabled = False
        rds1.setPos([0, upshift])
        rds1.draw()
        rds3.pos= [0, upshift]
        rds3.enabled = True
        rds2.setPos([40, upshift])
        rds2.draw()
        rds3.enabled = False
        
        myWin.flip()
            
        timenow = myClock.getTime()
        responseKeyOri = event.waitKeys(keyList=['a', 'l','escape'])
        respRT = myClock.getTime()-timenow #time taken to respond
        
        if responseKeyOri[0] == 'escape':
            core.quit()
        trials.addData('responseCond', responseKeyOri)
        trials.addData('respRt', respRT)
#        rds3.enable = True
        
    #save all data
    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= '', dataOut=['all_raw'])

mainLoop()
myWin.close()
core.quit()





