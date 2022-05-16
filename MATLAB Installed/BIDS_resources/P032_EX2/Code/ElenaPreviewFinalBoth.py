from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy as np
from psychopy import gui, visual, core, data, event, clock, sound
import os  # handy system and path functions
import visualExtra
import serial, time

ser = serial.Serial('COM3', 115200, timeout=100)
#s = ser.read(100)
ser.write(chr(0).encode())
#ser.write(chr(0))
#ser.write(b'0')
#ser.write('0'.encode('ISO-8859-1')

expName='ElenaPreviewEEGboth'#from the Builder filename that created this script
expInfo={'participant':'','streoAcuity':0,'subN':0}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

if not os.path.isdir('dataPreviewEEGboth'):
    os.makedirs('dataPreviewEEGboth')#if this fails (e.g. permissions) we will get error      
filename= 'dataPreviewEEGboth/' + expName 

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
random.seed(seedN)

verticalSize = 1080
dispRightEye = -2  # disparity in the right eye, if negative shift is to the left
dispLeftEye =  2
nV = 28 #number of Vertices
sRadius = 80 #starting radius and therefore size of the stim
proportionRadius = 0.5  # how much in and out it can change
barWidth = 14
dotBrightness = 0.2
upshift = verticalSize/2 #upshift value
baselineDuration = 1.5

myWin = visual.Window(allowGUI=False, color=[0,0,0], units='pix', size=(800,verticalSize), allowStencil=True, viewScale=[1.0, 0.5], fullscr= True, screen = 1)

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.Circle(myWin, pos=[0, 0], radius = 10, fillColor= 'red', lineColor = None)#this is a gray cross for the fixation
responseScreen=visual.TextStim(myWin, ori=0, text = 'Symmetrical        Asymmetrical', pos=[0,256], height= 25, color='blue', colorSpace='rgb', units= 'pix')
myTexture = numpy.random.randint(0,2,(256,256))-0.8
rdp0 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.8
rdp1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512]) #, color= 'blue')
temp = visual.ShapeStim (myWin, lineColor= 'red', fillColor=None)
dot = visual.Circle (myWin, radius=10, lineColor= 'green', fillColor=None)
tempLine = visual.Line (myWin, lineColor = 'green', start = [0,0], end = [0, 360])

punishmentSoundDuration = 0.8
s1 = sound.Sound(200,secs=punishmentSoundDuration,sampleRate=44100)

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
    
    instructions.setPos([dispRightEye, -upshift/2])
    instructions.draw()
    instructions.setPos([dispLeftEye, upshift/2])
    instructions.draw()
    myWin.flip()

#creates a list of x,y coordinates around a cricle with a startradius and 
#makes the shape symetrical if axes > 0
def makePattern(centrex, centrey, shape, nvertices, startradius, axes):

    increment =float(math.pi * 2 / nvertices)     # example: pi * 2 / 12 = 0.52359
    peri =0
    nConcave =0
    deviation = startradius * proportionRadius    #whatever you pick as startradius, the deviation in or out from it is 30% of startradius
    minConcave = int(nvertices / 2)  #always minimum 33% concave vertices - so 4 in the case of 12, 16 for 48
    minPeri = startradius * 2 * math.pi #always minimum the circumenference of the starting circle
    
    
    if axes >0:
        if (nvertices % (axes * 2)) > 0:
            print("Error: nvertices has to be divisible by 4")
            core.quit()
        
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
            npersector = int(nvertices / (axes *2))   # 
            for i in range (nvertices - npersector):
                p = int (i%npersector)   #gets rid of the float
                s = floor(i/npersector) + 1          #floor rounds it down 
                n = npersector - 1
                deviationList[int(npersector*s + (n-p))] = deviationList[i]
                angleList[int(npersector*s + (n-p))] = - angleList[i]


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
        
        
    newcoords = visualExtra.rotateVertices(vertices = coords, a = numpy.rad2deg(increment/2))

    return newcoords

#draw either the preview with stencilR or the stimulus with stencil
#stencilR or stencilL to create the asymmetry
def drawStim(sten, cond): #stencilL, stencilR,
    
    # this is the preview       
        if cond == 'figure'or cond == 'ground':  # cond in ['figure', 'ground']  
            sten.enabled = False
            rdp0.setPos([0, -upshift])    # right eye 
            rdp0.draw()
            rdp0.setPos([0, upshift])     # left eye
            rdp0.draw()
        
        if cond == 'figure':
            sten.enabled = True
            sten.inverted = False
            rdp1.setPos([dispRightEye, -upshift])  # right eye
            sten.setPos ([dispRightEye, -upshift])
            rdp1.draw()
            rdp1.setPos([dispLeftEye, upshift])    # left eye
            sten.setPos ([dispLeftEye, upshift])
            rdp1.draw()
            
        elif cond == 'ground': 
            sten.enabled = True
            sten.inverted = True
            rdp1.setPos([dispRightEye, -upshift])
            sten.setPos ([dispRightEye, -upshift])
            rdp1.draw()
            rdp1.setPos([dispLeftEye, upshift])
            sten.setPos ([dispLeftEye, upshift])
            rdp1.draw()  
        sten.enabled = False
       
        fixation.setPos([dispRightEye, -upshift])
        fixation.draw()
        fixation.setPos([dispLeftEye, upshift])
        fixation.draw()

def responseCollect(trialType, screen, practiceExp):
    event.clearEvents()
    respCorr = 0     # this stops the participants hacking through by pressing both a and l at the same time
    responseScreen.setPos([0, -upshift/2])
    responseScreen.draw()
    responseScreen.setPos([0, upshift/2])
    responseScreen.draw()
    myWin.flip()

    responseKey = event.waitKeys(keyList=['a', 'l', 'escape'])[0]
 #   responseKey = 'a'  # debug
    
    if responseKey == 'escape':
       core.quit()
       
    if screen == 'l':
        if responseKey == 'a':
            if trialType == 'asym':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == 'l':
            if trialType == 'asym':
                respCorr = 1
            else:
                respCorr = 0

                
    elif screen == 'r':
        if responseKey == 'l':
            if trialType == 'asym':
                respCorr = 0
            else:
                respCorr = 1
        elif responseKey == 'a':
            if trialType == 'asym':
                respCorr = 1
            else:
                respCorr = 0
    
    if practiceExp == 'practice':
        if respCorr == 0:
            s1 = sound.Sound(200,secs=0.3,sampleRate=44100)
            s1.play()
            core.wait(punishmentSoundDuration)
           
    return respCorr, responseKey
    
# This long loop runs through the trials
def mainLoop(trialbook, reps, practiceExp): # define Reps and set at bottom how many blocks you want  
    blockDuration = 20    
    nBlocksToGo = 24
    trialCounter = 0
    trials=data.TrialHandler(nReps=reps, method='random', trialList=data.importConditions(trialbook))
    trials.extraInfo = expInfo
    thisTrial=trials.trialList[0]
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        cond = figureground #+ str(plane) 

        if symmetry == 'sym':
            v =  makePattern(0, 0, 'circle', nV, sRadius, 2)
        elif symmetry == 'asym':
            v = makePattern(0, 0, 'circle', nV, sRadius, 0)  #if axes more than 0 is showing only symmetrical
        else:
            print('error')
        
        if trialCounter == blockDuration and practiceExp=='exp':
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1

        if screen == 'l':
            responseScreen.setText("Symmetry       Asymmetry")
        elif screen == 'r':
            responseScreen.setText("Asymmetry       Symmetry")

        myTexture0 = numpy.random.randint(0,2,(128,128))- dotBrightness
        rdp0.tex = myTexture0
        myTexture1 = numpy.random.randint(0,2,(128,128))- dotBrightness
        rdp1.tex = myTexture1
        
        
        verticesP = [(-barWidth,256),(-barWidth, -256),(barWidth,- 256),(barWidth,256),(256, 256), (256, 196), (196, 196),
        (196, 256),(-256, 256), (-256, 196), (-196, 196), (-196, 256)]

        stencilP = visual.Aperture(myWin, units="pix", shape= verticesP, size = 1)
        fixation.setRadius(8)

        drawStim(stencilP, cond)
        myWin.flip()
        t = myClock.getTime() + 1.5     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
#       
        npersector = int(nV / (4)) 
        upRight = 0
        upLeft = nV - 1
        bottomLeft = nV - npersector * 2
        bottomRight = nV -( npersector * 2) -1
        newBottomL = (nV - npersector * 2) + 3
        newBottomR = (nV -( npersector * 2) -1) +3
       
        
#        print(upLeft, bottomLeft, bottomRight)
        v[upRight][0] = -barWidth
        v[upLeft][0] = barWidth
        v[bottomRight][0] = -barWidth
        v[bottomLeft][0] = barWidth
        
        topL = [v[upRight][0],256]
        topR =  [v[upLeft][0],256]
        bottomL = [v[bottomRight][0],-256]
        bottomR =  [v[bottomLeft][0],-256]
        
        v.insert(0, topR)
        v.insert(1, topL)
        v.insert(newBottomR, bottomL)
        v.insert(newBottomL, bottomR)

        v.append([barWidth, 256])
        v.append([256, 256])
        v.append([256, 196])
        v.append([196, 196])
        v.append([196, 256])

        v.append([-256, 256])
        v.append([-256, 196])
        v.append([-196, 196])
        v.append([-196, 256])
        v.append([-256, 256])

#        temp.vertices = v
#        temp.draw()
#        dot.setPos(v[17])
#        dot.draw()
#        
        stencil = visual.Aperture(myWin, units="pix", shape= v)
        stencil.enabled = False

#generating 50% random dots
        for x in range(128):
            for y in range(128):            
                if random.randint(0,1):
                    myTexture0[x][y] =  random.randint(0,1) - dotBrightness
                else:
                    myTexture0[x][y] =  rdp0.tex[x][y]        
        rdp0.tex = myTexture0
        for x in range(128):
            for y in range(128):            
                if random.randint(0,1):
                    myTexture1[x][y] =  random.randint(0,1) - dotBrightness
                else:
                    myTexture1[x][y] =  rdp1.tex[x][y]        
        rdp1.tex = myTexture1
        
# this is the stimulus
        fixation.setRadius(16)
        drawStim(stencil, cond)
        myWin.flip()
#        print (cond, symmetry)
        t = myClock.getTime() + 1.5
        
        ser.write(chr(trigger).encode())
        core.wait(0.01)
#        ser.write(chr(0))
        
             # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
                
        myWin.flip()
        if event.getKeys(["escape"]):
            core.quit()
#        responseScreen.setPos([0, -upshift/2])
#        responseScreen.draw()
#        responseScreen.setPos([0, upshift/2])
#        responseScreen.draw()
#        myWin.flip()

#        w = myClock.getTime() + baselineDuration
#        
#        responseKey = event.waitKeys(keyList=['a', 'l', 'escape'])[0]
#        while myClock.getTime() < w:
#            if event.getKeys (['escape']):
#                core.quit()
#                event.clearEvents()
#                myWin.close
        
#        if responseKey == 'escape':
#a            core.quit()
        
        respCorr, choice = responseCollect(symmetry, screen, practiceExp)
#        if symmetry == 'sym':
#            if responseKey == 'a':
#                respCorr = 1
#                myWin.flip()
#            elif responseKey == 'l':
#                respCorr = 0
#                s1 = sound.Sound(200,secs=0.3,sampleRate=44100)
#                if block == "practice": s1.play()
#                myWin.flip()
#        elif symmetry == 'asym':
#            if responseKey =='l':
#                respCorr = 1
#                myWin.flip()
#            elif responseKey == 'a':
#                respCorr = 0
#                s1 = sound.Sound(200,secs=0.3,sampleRate=44100)
#                if block == "practice": s1.play()
#                myWin.flip()
                
       
        trials.addData('respCorr', respCorr)
        trials.addData('choice', choice)
        #trials.addData('RT',RT)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'data', dataOut=['all_raw'])
    trials.saveAsWideText(filename+'.txt')

message('HelloPractice')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreview.xlsx', 2, "practice") #32 practice trials
message('HelloMain')
event.waitKeys(keyList = ['g'])
mainLoop('bookPreview.xlsx', 30, "exp") #30 x 16 = 480 trials    
message('Goodbye')
core.wait(2)
ser.close()
myWin.close()
core.quit()





