from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy as np
from psychopy import gui, visual, core, data, event, clock, sound
import os  # handy system and path functions
import visualExtra
import locale

locale.setlocale(locale.LC_ALL, 'sv_SE.UTF-8')


expName='ElenaPreviewRT'#from the Builder filename that created this script
expInfo={'participant':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

if not os.path.isdir('dataPreviewRT'):
    os.makedirs('dataPreviewRT')#if this fails (e.g. permissions) we will get error      
filename= 'dataPreviewRT/' + expName 

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
random.seed(seedN)

verticalSize = 1080
disp = 3
myWin = visual.Window(allowGUI=False, units='pix', size=(800,verticalSize), allowStencil=True, viewScale=[1.0, 0.5], fullscr= True, screen = 1)

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.Circle(myWin, pos=[0, 0], radius = 10, fillColor= 'white', lineColor = None)#this is a gray cross for the fixation
responseScreen=visual.TextStim(myWin, ori=0, text = 'Symmetrical        Asymmetrical', pos=[0,256], height= 25, color='blue', colorSpace='rgb', units= 'pix')
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp0 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512]) #color= 'blue')
temp = visual.ShapeStim (myWin, lineColor= 'red', fillColor=None)
dot = visual.Circle (myWin, radius=10, lineColor= 'green', fillColor=None)
tempLine = visual.Line (myWin, lineColor = 'green', start = [0,0], end = [0, 360])
#print (stencil.vertices)
s1 = sound.Sound(200,secs=1,sampleRate=44100)
upshift = verticalSize/2 #upshift value
baselineDuration = 1.5
myClock = core.Clock()#this creates and starts a clock which we can later read



def message(type, nBlocksToGo = 1):
    if type == 'HelloPractice':
        string = ('Welcome to the Practice Experiment. You will see LOTS of images. Your task is to decide whether they are symmetrical or asymmetical.')
    elif type == 'HelloMain':
        string = ('Now for the real thing, its the same, but much longer. Try too keep your eyes and the central cross and not to blink!')
    elif type == 'Goodbye':
        string = ('Thank you for taking part in the Experiment')
    elif type == 'Break':
       string = "{} Blocks to go".format(nBlocksToGo) #new style code for string formatting
        #string = str(nBlocksToGo) + " Blocks to go"
    instructions=visual.TextStim(myWin, ori=0, text=string, pos=[0, 256], height=25, color='white', colorSpace='rgb', units= 'pix')
    
    instructions.setPos([-disp, -upshift/2])
    instructions.draw()
    instructions.setPos([0, upshift/2])
    instructions.draw()
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

#draw either the preview with stencilR or the stimulus with stencil
#stencilR or stencilL to create the asymmetry
def drawStim(sten, cond): #stencilL, stencilR,
    
    # this is the preview       
        if cond == 'figure'or cond == 'ground':  # cond in ['figure', 'ground']  
            sten.enabled = False
            rdp0.setPos([0, -upshift])
            rdp0.draw()
            rdp0.setPos([0, upshift])
            rdp0.draw()
        
        if cond == 'figure':
            sten.enabled = True
            sten.inverted = False
            rdp1.setPos([-disp, -upshift])
            sten.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            sten.setPos ([0, upshift])
            rdp1.draw()
            
        elif cond == 'ground': 
            sten.enabled = True
            sten.inverted = True
            rdp1.setPos([-disp, -upshift])
            sten.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            sten.setPos ([0, upshift])
            rdp1.draw()  
        sten.enabled = False
       
        fixation.setPos([-disp, -upshift])
        fixation.draw()
        fixation.setPos([0, upshift])
        fixation.draw()

    
# This long loop runs through the trials
def mainLoop(trialbook, reps): # define Reps and set at bottom how many blocks you want
    blockDuration = 20
    nBlocksToGo = 12
    trialCounter = 0
    trials=data.TrialHandler(nReps=reps, method='random', trialList=data.importConditions(trialbook))
    trials.extraInfo = expInfo
    thisTrial=trials.trialList[0]
    #set up handler to look after randomisation of trials etc
    #trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('bookPreview.xlsx')) 
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        cond = figureground #+ str(plane)
        #print (cond, symmetry)
        #cond = 'figure1' #debug only showing specified trials   
        nV = 32 #number of Vertices
        v = makePattern(0, 0, 'circle', nV, 100, 0)  #if axes more than 0 is showing only symmetrical
        if symmetry == 'sym':
            v =  makePattern(0, 0, 'circle', nV, 100, 2)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1


        myTexture0 = numpy.random.randint(0,2,(128,128))-0.5
        rdp0.tex = myTexture0
        myTexture1 = numpy.random.randint(0,2,(128,128))-0.5
        rdp1.tex = myTexture1
        
        verticesP = [(-30,256),(-30, -256),(30,- 256),(30,256),(256, 256), (256, 216), (216, 216),
        (216, 256),(-256, 256), (-256, 216), (-216, 216), (-216, 256)]
        
#        if symmetry == 'sym':
#            verticesP.append([-256, -256])
#            verticesP.append([-256, -216])
#            verticesP.append([-216, -216])
#            verticesP.append([-216, -256])
#            verticesP.append([-256, -256])
#    
#            verticesP.append([256, -256])
#            verticesP.append([256, -216])
#            verticesP.append([216, -216])
#            verticesP.append([216, -256])
#            verticesP.append([256, -256])
#            verticesP.append([256, 256])
         
#        temp.vertices = verticesP
#        temp.draw()
            
            
#        dot.setPos([256,256])
#        dot.draw()
#        dot.setPos([-256,-256])
#        dot.draw()
#        dot.setPos([-256,256])
#        dot.draw()
#        dot.setPos([-256,256])
#        dot.draw()
#        
        stencilP = visual.Aperture(myWin, units="pix", shape= verticesP, size = 1)
        
#        t = myClock.getTime() + 0.5     # fixation for this much time
#        while myClock.getTime() < t:
#            pass #do nothing

        fixation.setRadius(10)

        drawStim(stencilP, cond)
        myWin.flip()
        t = myClock.getTime() + 1     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
#        
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
#        v.insert(35, topR)
        
#        print (v.insert(35, topR))
#        temp.vertices = v
#        temp.draw()
#        a = (360./nV)/2.
#        while a<360:
#            tempLine.setOri(a)
#            a = a + 360./nV
#            tempLine.draw()
#        print (topR)
#        for i in range(len(v)):
#            dot.setPos(v[i])
#            dot.draw()
#        dot.setPos(v[35])
#        dot.draw()
#        dot.setPos(v[31])
#        dot.draw()

        v.append([30, 256])
        v.append([256, 256])
        v.append([256, 216])
        v.append([216, 216])
        v.append([216, 256])
#        v.append([256, 256])
        
        v.append([-256, 256])
        v.append([-256, 216])
        v.append([-216, 216])
        v.append([-216, 256])
        v.append([-256, 256])
        
#        if symmetry == 'sym':
#            v.append([-256, -256])
#            v.append([-256, -216])
#            v.append([-216, -216])
#            v.append([-216, -256])
#            v.append([-256, -256])
#    
#            v.append([256, -256])
#            v.append([256, -216])
#            v.append([216, -216])
#            v.append([216, -256])
#            v.append([256, -256])
#            v.append([256, 256])
            
        
           
        
#        temp.vertices = v
#        temp.draw()

        stencil = visual.Aperture(myWin, units="pix", shape= v)
        stencil.enabled = False

        for x in range(128):
            for y in range(128):            
                if random.randint(0,1):
                    myTexture0[x][y] =  random.randint(0,1) -0.5
                else:
                    myTexture0[x][y] =  rdp0.tex[x][y]        
        rdp0.tex = myTexture0
        for x in range(128):
            for y in range(128):            
                if random.randint(0,1):
                    myTexture1[x][y] =  random.randint(0,1) -0.5
                else:
                    myTexture1[x][y] =  rdp1.tex[x][y]        
        rdp1.tex = myTexture1
       #        myTexture = numpy.random.randint(0,2,(128,128))-0.5
#        myTexture = numpy.random.randint(0,2,(128,128))-0.5

#        myTexture = numpy.random.randint(0,2,(128,128))-0.5
#        rdp1.tex = myTexture
        
# this is the stimulus

        fixation.setRadius(20)
        drawStim(stencil, cond)
                #print (myClock.getTime()- w)
        responseScreen.setPos([0, -200 -upshift/2])
        #responseScreen.draw()
        responseScreen.setPos([0, -200 + upshift/2])
        #responseScreen.draw()
        myWin.flip()

        w = myClock.getTime() 
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
                s1 = sound.Sound(200,secs=0.2,sampleRate=44100)
                s1.play()
#                core.wait(0.2)
                myWin.flip()
        elif symmetry == 'asym':
            if responseKey =='l':
                respCorr = 1
                myWin.flip()
            elif responseKey == 'a':
                respCorr = 0
                s1 = sound.Sound(200,secs=0.2,sampleRate=44100)
                s1.play()
#                core.wait(0.2)
                myWin.flip()

        trials.addData('respCorr',respCorr)
        trials.addData('choice',responseKey)
        trials.addData('RT',RT)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'data', dataOut=['all_raw'])
    trials.saveAsWideText(filename+'.txt')

message('HelloPractice')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreviewPractice.xlsx', 1)
message('HelloMain')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreview.xlsx', 30) #30 x 8 = 240 trials
message('Goodbye')
core.wait(2)
myWin.close()
core.quit()





