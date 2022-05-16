from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy as np
from psychopy import gui, visual, core, data, event, clock
import os  # handy system and path functions
import visualExtra

expName='ElenaStereo'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'dataRT'.format(expInfo['participant'], expInfo['date'])
if not os.path.isdir('dataRT'):
    os.makedirs('dataRT')#if this fails (e.g. permissions) we will get error      
#store info about the experiment

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
random.seed(seedN)

verticalSize = 1080
disp = 3
myWin = visual.Window(allowGUI=False, units='pix', size=(800,verticalSize), allowStencil=True, viewScale=[1.0, 0.5], fullscr= True, screen = 1)

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='red')#this is a gray cross for the fixation
responseScreen=visual.TextStim(myWin, ori=0, text = 'Symmetrical        Asymmetrical', pos=[0,256], height= 20, color='blue', colorSpace='rgb', units= 'pix')
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp0 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512], color = 'blue')
temp = visual.ShapeStim (myWin, lineColor= 'red', fillColor=None)
dot = visual.Circle (myWin, radius=10, lineColor= 'green', fillColor=None)
tempLine = visual.Line (myWin, lineColor = 'green', start = [0,0], end = [0, 360])

#print (stencil.vertices)

baselineDuration = 1.5
myClock = core.Clock()#this creates and starts a clock which we can later read

def message(Type, nBlocksToGo = 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of images. Your task is to decide whether they are symmetrical or asymmetical.')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try too keep your eyes and the central cross and not to blink!')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = "{} Blocks to go".format(nBlocksToGo) #new style code for string formatting
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 256], height=20, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

#creates a list of x,y coordinates around a cricle with a startradius and 
#makes the shape symetrical if axes > 0
def makePattern(centrex, centrey, shape, nvertices, startradius, axes):
    
    increment =float(math.pi * 2 / nvertices)     # example: pi * 2 / 12 = 0.52359
    peri =0
    nConcave =0
    deviation = startradius /3.    #whatever you pick as startradius, the deviation in or out from it is 33% of startradius
    minConcave = int(nvertices / 3)  #always minimum 33% concave vertices - so 4 in the case of 12, 16 for 48
    minPeri = startradius * 2 * math.pi #always minimum the circumenference of the starting circle
    
    while (peri <minPeri) or (nConcave < minConcave):
        counter =0
        coords =[]
        angleInc =0.
        deviationList =[]
        angleList = []
    
        for i in range(nvertices):
            deviationList.append(startradius  + uniform(-deviation, deviation))#uniform to generate random numbers in range
            angleList.append(uniform (- 0.017, +0.017) )  #this is + or - 1 degree
        if axes>0:
            npersector = int(nvertices / (axes *2))   # 3
            for i in range (nvertices - npersector):
                p = int (i%npersector)   #gets rid of the float
                s = floor(i/npersector) + 1          #floor rounds it down 
                n = npersector - 1
                deviationList[int(npersector*s + (n-p))] = deviationList[i]
                angleList[int(npersector*s + (n-p))] = - angleList[i]
    #        print (i, s, npersector, int(npersector*s + (n-p)), p)
    #    print (deviationList)
    #    print(angleList)
    #    core.quit()

#        elif shape=='ellipse':
#            print 'I am an ellipse'
#            while angle <6.11:   # this is 2 pi that is 360 deg
#                counter =counter +1 
#                angle = angle +increment    #this is between 10 deg and 19 deg (0.175 rad and 0.3329 rad)
#                a = b =startradius
#                b = startradius  + randint(-deviation, deviation +1)     #this is the deviation which is 33% of the startradius   
#                a = b * 0.7                                                                   #this is 70% of b
#                c = math.sqrt(a*a * cos(2*angle) +math.sqrt(b*b*b*b - a*a * sin(2*angle)*sin(2*angle)))
#                y =cos(angle) * c
#                x =sin(angle) * c
#                coords.append([centrex+x,centrey+y])     
                
        if shape=='circle':
            while counter <nvertices:  #angle < (2 * math.pi):
                angleInc = angleInc + increment
                angle = angleInc + angleList[counter]
                b = deviationList[counter]     #this is the deviation which is 33% of the startradius   
                a = 0                                                                   #this is 0% of b
                c = math.sqrt(a*a * cos(2*angle) +math.sqrt(b*b*b*b - a*a * sin(2*angle)*sin(2*angle)))
                y =cos(angle) * c
                x =sin(angle) * c
                coords.append([centrex+x,centrey+y])
                counter =counter +1 
        peri =visualExtra.computePerimeter(coords)
        cx, ce = visualExtra.computeAngles (coords)
        nConcave = len(ce)
        
#        print (peri, nConcave)
        
    newcoords = visualExtra.rotateVertices(vertices = coords, a = numpy.rad2deg(increment/2))

    return newcoords

    
# This long loop runs through the trials
def mainLoop(trialbook, Reps): # define Reps and set at bottom how many blocks you want
    blockDuration = 20
    nBlocksToGo = 10
    trialCounter = 0
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    #set up handler to look after randomisation of trials etc
    #trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('bookPreview.xlsx')) 
    upshift = verticalSize/2 #upshift value
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        cond = figureground #+ str(plane)
        #print (cond, symmetry)
        #cond = 'figure1' #debug only showing specified trials   
        nV = 32 #number of Vertices
        v = makePattern(0, 0, 'circle', nV, 120, 0)
        if symmetry == 'sym':
            v =  makePattern(0, 0, 'circle', nV, 120, 2)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1


        
        myTexture = numpy.random.randint(0,2,(128,128))-0.5
        rdp0.tex = myTexture
        myTexture = numpy.random.randint(0,2,(128,128))-0.5
        rdp1.tex = myTexture

        vertices = [(-30,-256),(-30,256),(30,256),(30,-256)]
        stencilP = visual.Aperture(myWin, units="pix", shape= vertices, size = 1)
        myWin.flip()
#        t = myClock.getTime() + 0.5     # fixation for this much time
#        while myClock.getTime() < t:
#            pass #do nothing

# this is the preview       
        if cond == 'figure'or cond == 'ground':  # cond in ['figure', 'ground']  
            stencilP.enabled = False
            rdp0.setPos([0, -upshift])
            rdp0.draw()
            rdp0.setPos([0, upshift])
            rdp0.draw()
        
        if cond == 'figure':
            stencilP.enabled = True
            stencilP.inverted = False
            rdp1.setPos([-disp, -upshift])
            stencilP.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            stencilP.setPos ([0, upshift])
            rdp1.draw()
            
        elif cond == 'ground': 
            stencilP.enabled = True
            stencilP.inverted = True  
            rdp1.setPos([-disp, -upshift])
            stencilP.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            stencilP.setPos ([0, upshift])
            rdp1.draw()  
        stencilP.enabled = False
       
        fixation.setPos([-disp, -upshift/2])
        fixation.draw()
        fixation.setPos([0, upshift/2])
        fixation.draw()
        myWin.flip()
        t = myClock.getTime() + 1     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
            
        #event.waitKeys()
        
        v[0][0] = -30
        v[31][0] = 30
        v[15][0] = -30
        v[16][0] = 30
        
        topL = [v[0][0],256]
        topR =  [v[31][0],256]
        bottomL = [v[15][0],-256]
        bottomR =  [v[16][0],-256]
        
        v.insert(0, topR)
        v.insert(1, topL)
        v.insert(18, bottomL)
        v.insert(19, bottomR)
        
        stencil = visual.Aperture(myWin, units="pix", shape= v)
        stencil.enabled = False
        
        verticesL = [(-256, 256), (256, -216), (-487, 216), (-216, 256)]
        verticesR = [(256, 256), (256, 216), (216, 216), (216, 256)]
        stencilL = visual.Aperture(myWin, units="pix", shape= verticesL, size = 1)
        stencilR  = visual.Aperture(myWin, units="pix", shape= verticesR, size = 1)
        #myWin.flip()
        #core.wait(1)
        #event.waitKeys()

    
# this is the stimulus

#depth plane -1
#        if cond == 'figure0' or cond == 'ground0':
#            rdp1.setPos([disp, -upshift])
#            rdp1.draw()
#            rdp1.setPos([0, upshift])
#            rdp1.draw()
            
#depth plane 0
        if cond == 'figure' or 'ground':
            stencil.enabled = False
            rdp0.setPos([0, -upshift])
            rdp0.draw()
            rdp0.setPos([0, upshift])
            rdp0.draw()
        stencil.enabled = False

#depth plane 1
        if cond == 'figure':
            stencil.enabled = True
            stencil.inverted = False
            stencilL.enabled = True
            stencilR.enabled = True
            stencilL.inverted = False
            stencilR.inverted = False
        
        elif cond == 'ground':
            stencil.enabled = True
            stencil.inverted = True 
            stencilL.enabled = True
            stencilR.enabled = True
            stencilL.inverted = True
            stencilR.inverted = True
        if cond == 'figure' or cond == 'ground':
            rdp1.setPos([-disp, -upshift])
            stencil.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            stencil.setPos ([0, upshift])
            rdp1.draw()
        stencil.enabled = False
        
        fixation.setPos([-disp, -upshift/2])
        fixation.draw()
        fixation.setPos([0, upshift/2])
        fixation.draw()
        ##w= myClock.getTime()
        myWin.flip()
        w = myClock.getTime() + 1     # fixation for this much time
        while myClock.getTime() < w:
            pass #do nothing
#        core.wait(1)
#       event.waitKeys()

        #print (myClock.getTime()- w)
        
        responseScreen.draw()
#        w = myClock.getTime() + baselineDuration
#        while myClock.getTime() < w:
#            pass

        
        w = myClock.getTime() 
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l', 'escape'])[0]
        if responseKey == 'escape':
            core.quit()
        RT = myClock.getTime() -w
        if symmetry == 'sym':
            if responseKey == 'a':
                respCorr = 1
                myWin.flip()
            elif responseKey == 'l':
                respCorr = 0
                myWin.flip()
        elif symmetry == 'asym':
            if responseKey =='l':
                respCorr = 1
                myWin.flip()
            elif responseKey == 'a':
                respCorr = 0
                myWin.flip()
        if not respCorr:
            

         trials.addData('respCorr',respCorr)
         trials.addData('choice',responseKey)
         trials.addData('RT',RT)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])


message('HelloPractice')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreviewPractice.xlsx', 1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreview.xlsx', 10) 
message('Goodbye')
core.wait(2)
myWin.close()
core.quit()





