#THIS IS AMY'S EXPERIMENT#

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
from psychopy import core, data, event, visual, sound, gui #these are the psychopy libraries
import math, scipy, random, os, copy
import visualExtra
import math
import gazepoint

# Connect to Eyetracker#
gp3 = gazepoint.EyeTracker()
print gp3.isConnected()
gp3.setRecordingState(False)
print 'done'
gp3.sendMessage(0) #this resets message

#Connect BIOSEMI# 
import serial, time
ser = serial.Serial('COM3', 115200, timeout=100)
ser.write(chr(0))

#To debug
debug = False

expName='AmyBW'
expInfo={'name':'','number':1,'task':'white'}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: 
    core.quit() #user pressed cancel

if not os.path.isdir('dataAmy'):      #folder data
    os.makedirs('dataAmy')            #if this fails (e.g. permissions) we will get error

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
random.seed(seedN)
task = expInfo['task']

#parallel.setPortAddress(0x378)#address for parallel port on many machines
#parallel.setData(0)

myWin = visual.Window(allowGUI=False, units='pix', monitor = 'EEGlab3d', size=(920,620), fullscr=True,screen=2)#creates a window using pixels as units
#fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='red')#this is a gray cross for the fixation
#fixation2=visual.Circle(myWin, pos=[0, 0], radius=30, lineColor='red')
instruction=visual.TextStim(myWin, text='', height=30, color='black')
respInstruction=visual.TextStim(myWin, text='', height=30, wrapWidth=900, color=(-.5,-.5,-.5))

circularRegion =visual.Circle(myWin, radius=240, fillColor='white', lineColor='black')
gaborW = visual.GratingStim(myWin, tex="sin", mask="gauss", texRes=256,  pos=[0,0], units='pix', phase=0.5, size=[16,16], sf=[0.05], ori=0)
gaborB = visual.GratingStim(myWin, tex="sin", mask="gauss", texRes=256,  pos=[0,0], units='pix', phase=0.25, size=[16,16], sf=[0.05], ori=0)
line1 =visual.Line(myWin, start=[-340,0], end=[340,0], lineWidth=1, lineColor='black')
myTexture = zeros([8,8])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", contrast = 0.5, units='pix', size=[16,16])
myTexture = zeros([8,8])+1
gaborWhite = visual.GratingStim(myWin, tex=myTexture, mask="gauss", contrast = 0.5, units='pix', size=[16,16])
myTexture = zeros([8,8])+1
gaborRed = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(1,-1,-1), units='pix', size=[16,16])
stim = visual.ImageStim(myWin)
 
fixationCircle = visual.Circle(myWin, radius=4, fillColor=(0.8,-0.5,-0.5), lineColor=None)
beepWrong = sound.Sound('A', secs=0.12, octave=4)

myTexture = randint(0,2,(512,512)) -0.5
mask = visual.GratingStim(myWin, tex=myTexture, mask="gauss", units='pix', size=[1024,1024])

myClock = core.Clock()#this creates and starts a clock which we can later read

#def generateCoordsPolar(n=10, pos=[0,0], minDist=1, gapAxis=2, radius=100, start=0, stop=360, granularity =1):
#    if  gapAxis == None: gapAxis = minDist
#
#    coords =[]
#    n =int(round(n))
#    minDist2 = minDist / 2.
#    stop = stop / granularity
#    
#    for i in range(n):
#        farEnough = False
#        while farEnough == False:
#            print minDist, radius
#            r = gapAxis + int((radius - gapAxis)*sqrt( rand())) 
#            r= random.randint(gapAxis, radius - gapAxis) 
#            a =random.randint(start, stop) * granularity
#            item1 = visualExtra.polar2cartesian(r,a)
#            right = visualExtra.polar2cartesian(r,start)
#            left = visualExtra.polar2cartesian(r,stop)
#            farEnough = True
#            if visualExtra.distance(item1, left) <minDist2:
#                farEnough =False
#            elif visualExtra.distance(item1, right) <minDist2:
#                farEnough =False
#            else:
#                for j in coords:
#                    item2 = visualExtra.polar2cartesian(j[0], j[1])
#                    if visualExtra.distance(item1, item2) <minDist:
#                        farEnough =False
#                        break
#        coords.append([r,a])
#        
#    return coords

# prepare list of positions with a particular symmetry type and number of axes
# numbre of axes also matter for no symmetry to divide the number of elements into quadrants
def generateSymmetry(symmetry='no', axes=0, ndots=32, radius=300, minDist=10, gapAxis=8):

    shapeFinal =[]
    
    if axes>0:
        n = int(round(ndots / (axes*2.)))       #example for 4 axes and 80 dots then n is 10
        stop = (360. / (axes*2.))   #example for 4 axes start =0 stop = 45
    else:
        n = int(round(ndots))
        stop = 360
    
    if symmetry=='no':
        
        start1 =0
        stop1 = stop
        
        if axes>0:
            for i in range(axes*2):
                shape_v1 = visualExtra.generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=start1, stop=stop1)
                shapeFinal.extend(shape_v1)
                start1 = start1 +stop
                stop1 = stop1 + stop
        else:
            shapeFinal = visualExtra.generateCoordsPolar(n=ndots, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=360)
            
    elif symmetry =='r':
        
        shape_v1 = visualExtra.generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=stop)
        if axes==1:
            shape_v2 = [[x[0], 360 -x[1]] for x in shape_v1]
            shapeFinal = shape_v1 + shape_v2
        elif axes==2:
            shape_v2 = [[x[0], 180 -x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 360 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 180 -x[1]] for x in shape_v4]            
            shapeFinal =shape_v1 + shape_v2  + shape_v3 + shape_v4
        elif axes==3:
            shape_v2 = [[x[0], 120 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 120 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 240 -x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 240 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 360 -x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6
        elif axes==4:
            shape_v2 = [[x[0], 90 -x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 180 -x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 180 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 270 -x[1]] for x in shape_v1]       
            shape_v7 = [[x[0], 270 +x[1]] for x in shape_v1]       
            shape_v8 = [[x[0], 360 -x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6 + shape_v7 + shape_v8

    elif symmetry =='c':
        
        shape_v1 = visualExtra.generateCoordsPolar(n=n, minDist=minDist, gapAxis=gapAxis, radius= radius, start=0, stop=stop)
        if axes==1:
            shape_v2 = [[x[0], 180 +x[1]] for x in shape_v1]
            shapeFinal = shape_v1 + shape_v2
        elif axes==2:
            shape_v2 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 180 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 270 +x[1]] for x in shape_v1]            
            shapeFinal =shape_v1 + shape_v2  + shape_v3 + shape_v4
        elif axes==3:
            shape_v2 = [[x[0], 60 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 120 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 180 +x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 240 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 300 +x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6
        elif axes==4:
            shape_v2 = [[x[0], 45 +x[1]] for x in shape_v1]
            shape_v3 = [[x[0], 90 +x[1]] for x in shape_v1]
            shape_v4 = [[x[0], 135 +x[1]] for x in shape_v1]        
            shape_v5 = [[x[0], 180 +x[1]] for x in shape_v1]       
            shape_v6 = [[x[0], 225 +x[1]] for x in shape_v1]       
            shape_v7 = [[x[0], 270 +x[1]] for x in shape_v1]       
            shape_v8 = [[x[0], 315 +x[1]] for x in shape_v1]       
            shapeFinal =shape_v1 + shape_v2 + shape_v3 + shape_v4 + shape_v5 + shape_v6 + shape_v7 + shape_v8
            
    return shapeFinal

# instructions for the practice and for the experiment
def message(Type, block):
    if Type == 'HelloExperiment':
        if task =='white':
            instruction.setText('Welcome to the Experiment. Look at the centre of the screen and pay attention to the WHITE pattern.')
        elif task =='black':
            instruction.setText('Welcome to the Experiment. Look at the centre of the screen and pay attention to the BLACK pattern.')
    elif Type == 'HelloTask':
        if task =='white':        
            instruction.setText('This is the end of the practice. Pay attention to the WHITE pattern. Start of the experiment.')
        if task =='black':        
            instruction.setText('This is the end of the practice. Pay attention to the BLACK pattern. Start of the experiment.')
    if Type == 'Goodbye':
        instruction.setText('End of experiment. Press space bar to quit.')
    if Type == 'Pause':
        instruction.setText('End of block,' +str(block) + ' more blocks left.')
    instruction.draw()

# only needed if stimuli have orientation (ignore for dots)
#def generateOriPhases(n=10, symmetry='r'):
#    
#    orientations =[]
#    phases =[]
#
#    for i in range(n):
#            orientations.append(random.randint(0,180))
#            phases.append(0.25)
#
#    return orientations, phases


# draw the stimuli
#def drawingShape(shape1, shape2, orientation1, orientation2):
#
#    v1 = [visualExtra.polar2cartesian(i[0],i[1]) for i in shape1]    # get cartesian coordinates
#    v2 = [visualExtra.polar2cartesian(i[0],i[1]) for i in shape2]    # get cartesian coordinates
#    #    v2 = [visualExtra.rotateVertex(vertex=i, a=orientation) for i in v1]  
#    v11 = visualExtra.rotateVertices(vertices=v1, a=-orientation1) # rotate the pattern
#    v22 = visualExtra.rotateVertices(vertices=v2, a=-orientation2) # rotate the pattern
#    #    v3 = [[x+100,y] for [x,y] in v2]
#
#    if task =='white':
#        for i in v22:
#            gaborBlack.setPos(i)
#            gaborBlack.draw()
#        for i in v11:
#            gaborWhite.setPos(i)
#            gaborWhite.draw()
#    elif task =='black':
#        for i in v22:
#            gaborWhite.setPos(i)
#            gaborWhite.draw()
#        for i in v11:
#            gaborBlack.setPos(i)
#            gaborBlack.draw()
#            
#    fixationCircle.draw()

#    for i in range(9):
#        line1.setOri(i*20)
#        line1.draw()

# run the experiment
def runBlock(filename, repeats):
    eyeTrig = 0
    #parallel.setData(0)
    if filename=='dataAmy/practice':
        trials=data.TrialHandler(nReps=repeats, seed=seedN, method='random', trialList=data.importConditions('trialbookAmyUploadPractice.xlsx')) #
        blockTrials = trials.nTotal 
        blockCounter = 1
    elif filename=='dataAmy/experiment':
        trials=data.TrialHandler(nReps=repeats, seed=seedN, method='random', trialList=data.importConditions('trialbookAmyUpload.xlsx')) #
        blockTrials = int(trials.nTotal / 17)
        blockCounter = trials.nTotal / blockTrials
    if not trials.nTotal / 6 != 0:  # has to be a multiple of six
        print 'wrong number of trials'
        core.quit()

    trials.extraInfo =expInfo  #so we store all relevant info into trials
    thisTrial=trials.trialList[0]#so we can initialise stimuli with some values
    counter =0

    # This long loop runs through the trials
    for thisTrial in trials:
        
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName) #these lines seem strange but it just makes the variables more readable 

        counter = counter +1
        if (counter % blockTrials) == 1 & (counter != 1):
            blockCounter = blockCounter -1
            message('Pause', blockCounter)
            myWin.flip()
            event.waitKeys(keyList=['g'])
            fixationCircle.draw()#draws fixation
            myWin.flip()
#        radius = 250 #debugging        
#        orientation1 = 0 #debugging
#        orientation2 = 0 #debugging
#        symmetry1 = 'r' #debugging
#        symmetry2 = 'r' #debugging
#        axes = 2 #debugging        
#        ndots = 52 #debugging        
#        minimumDist = 17.5 #16 / 6. * 2. * 1.3  #debugging  this is  1.96 sd from the mean
#        gap =4 #debugging
#        propNoise = .4
        
#        circularRegion.setRadius(radius)
        t = myClock.getTime() + rand()/2. + 0.75     # blank screen for this much time
        
#        stimulus1 = generateSymmetry(symmetry=symmetry1, axes=axes, ndots=ndots, radius=radius, minDist=minimumDist, gapAxis=gap)
#        stimulus2 = generateSymmetry(symmetry=symmetry2, axes=axes, ndots=ndots, radius=radius, minDist=minimumDist, gapAxis=gap)
#        while visualExtra.overlapCoords(stimulus1, stimulus2, minDist=minimumDist):
#            stimulus2 = generateSymmetry(symmetry=symmetry2, axes=axes, ndots=ndots, radius=radius, minDist=minimumDist, gapAxis=gap)

#        count =0
#        problem = True
#        while problem: 
#            print problem, count
#            problem = visualExtra.overlapCoords(stimulus1, stimulus2, minDist=minimumDist)
#            stimulus2 = generateSymmetry(symmetry=symmetry2, axes=axes, ndots=ndots, radius=radius, minDist=minimumDist, gapAxis=gap)
#            count = count +1
#            core.wait(0.02)

        if debug:
            cond ="rro"
            
        if task =='white':
            s = 'amyImagesW/' + cond + str(set) + '.png'
        elif task =='black':
            s = 'amyImagesB/' + cond + str(set) + '.png'
        stim.setImage(s)
        while myClock.getTime() < t:
            pass #do nothing
        
#        eyeTrig = eyeTrig+1
#        gp3.sendMessage(eyeTrig) #this tells to Gazepoint what trial it is
#        t1 = myClock.getTime() + 0.01     # for the trigger
#        while myClock.getTime() < t1:
#            pass #do nothing
        gp3.sendMessage(trigger) #this tells to Gazepoint which condition it is
        stim.draw()
        myWin.flip()
        #parallel.setData(trigger)
        ser.write(chr(trigger))
        t1 = myClock.getTime() + 0.01     # for the trigger
        while myClock.getTime() < t1:
            pass #do nothing
        ser.write(chr(0))
        #parallel.setData(0)
            
        t2 = myClock.getTime() + 1     # stmulus screen for this much time
        while myClock.getTime() < t2:
            pass #do nothing
        if debug:
            event.waitKeys(keyList=['a'])
            
        myWin.flip()
        gp3.sendMessage(0) #this resets message 
        
        if keyMapping== 'right':
                respInstruction.setText('Symmetry         Asymmetry')
        elif keyMapping == 'left':
                respInstruction.setText('Asymmetry         Symmetry')
        respInstruction.draw()
        fixationCircle.draw()#draws fixation
        myWin.flip()
        timenow = myClock.getTime()
        responseKey = event.waitKeys(keyList=['a', 'l','escape'])
        respRT = myClock.getTime()-timenow #time taken to respond
        fixationCircle.draw()#draws fixation
        myWin.flip()
#        
#        if task==1 and repeats==1:
#            if symmetry2=='no' and responseKey[0]=='a':
#                beepWrong.play()
#            elif symmetry2=='r' and responseKey[0]=='l':
#                beepWrong.play()
#        elif task==2 and repeats==1:
#            if symmetry2=='no' and responseKey[0]=='l':
#                beepWrong.play()
#            elif symmetry2=='r' and responseKey[0]=='a':
#                beepWrong.play()                
#
        if responseKey[0] == 'escape':
            core.quit()
        trials.addData('responseCond', responseKey[0])
        trials.addData('respRt', respRT)

        
    #save all data
    trials.saveAsWideText(filename+'.txt')


gp3.sendMessage(0) #this resets the gazepiont tigger
message('HelloExperiment',0)
myWin.flip()
event.waitKeys(keyList=['g'])
runBlock('dataAmy/practice', 2)
message('HelloTask',0)
myWin.flip()

gp3.setRecordingState(True)
event.waitKeys(keyList=['g'])
runBlock('dataAmy/experiment', 1)
message('Goodbye',0)
myWin.flip()
gp3.setRecordingState(False)

event.waitKeys(keyList=['space'])
myWin.close()
core.quit()