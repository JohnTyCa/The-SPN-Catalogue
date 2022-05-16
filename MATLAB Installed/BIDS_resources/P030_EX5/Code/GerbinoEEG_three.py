# Important Information
# version GerbinoEEG_4.py is the one that was used to collect data from
# the first Gerbino EEG study
# GerbinoEEG_Control is the one where there is no confounding convex/concave factor
# GerbinoEEG_4Centred columns are now centred on fixation cross

########## DONT FORGET TO PUT THE TRIGGERS BACK IN ############

from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui, parallel #these are the psychopy libraries
import math
import visualExtra

ResponseScreenLimit = 10 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3
stimHeight =160
stimH2 = stimHeight*2
stimSep =140
stimStart =int(stimSep*1.75)
stimEnd  =int(stimSep*1.25)
stimN =4
#parallel.setData(0)

#store info about the experiment
expName='GerbinoEEGcontrolOne'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, units='pix', allowStencil=True, size=(500,500), fullscr=True, monitor = 'EEG lab participant')#creates a window using pixels as units
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='white')#this is for the fixation

color1 =(0.,-1.,-1.)   # was black now red
color2 =(-1.,0.,-1.)   # was white now green
color3 =(-1,-1,-1)   # was green now black
thick = 20
halfThick =thick/2
color4 =(-0,-0.,0)   # grey
a=50

#these define the black borders of stimuli
#frameBlack = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color1)
#frameWhite = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color2)
#frameBlack2 = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color4)
#
#r11 = visual.ShapeStim(myWin, vertices=[[-stimStart,160],[-stimStart,210],[stimStart,210],[stimStart,160]], fillColor=color4, lineColor=color4)
#r12 = visual.ShapeStim(myWin, vertices=[[-stimStart,-160],[-stimStart,-210],[stimStart,-210],[stimStart,-160]], fillColor=color4, lineColor=color4)
#r13_1 = visual.ShapeStim(myWin, vertices=[[-stimStart+175,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+175,210]], fillColor=color4, lineColor=color4)
#r13_2 = visual.ShapeStim(myWin, vertices=[[-stimStart+175,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+175,210]], fillColor=color4, lineColor=color4)
#r14_1 = visual.ShapeStim(myWin, vertices=[[stimStart-175,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-175,210]], fillColor=color4, lineColor=color4)
#r14_2 = visual.ShapeStim(myWin, vertices=[[stimStart-175,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-175,210]], fillColor=color4, lineColor=color4)
#
#r21 = visual.ShapeStim(myWin, vertices=[[-stimStart,160],[-stimStart,210],[stimStart,210],[stimStart,160]], fillColor=color4, lineColor=color4)
#r22 = visual.ShapeStim(myWin, vertices=[[-stimStart,-160],[-stimStart,-210],[stimStart,-210],[stimStart,-160]], fillColor=color4, lineColor=color4)
#r23_1 = visual.ShapeStim(myWin, vertices=[[-stimStart+175,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+175,210]], fillColor=color4, lineColor=color4)
#r23_2 = visual.ShapeStim(myWin, vertices=[[-stimStart+175,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+175,210]], fillColor=color4, lineColor=color4)
#r24_1 = visual.ShapeStim(myWin, vertices=[[stimStart-175,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-175,210]], fillColor=color4, lineColor=color4)
#r24_2 = visual.ShapeStim(myWin, vertices=[[stimStart-175,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-175,210]], fillColor=color4, lineColor=color4)
#

#3stimuli
frameBlack = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color1)
frameWhite = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color2)
frameBlack2 = visual.Rect(myWin, width=100+stimStart*2, height=100+stimH2, pos=[0,0], lineColor=None, fillColor=color4)

r11 = visual.ShapeStim(myWin, vertices=[[-stimStart,160],[-stimStart,210],[stimStart,210],[stimStart,160]], fillColor=color4, lineColor=color4)
r12 = visual.ShapeStim(myWin, vertices=[[-stimStart,-160],[-stimStart,-210],[stimStart,-210],[stimStart,-160]], fillColor=color4, lineColor=color4)
r13_1 = visual.ShapeStim(myWin, vertices=[[-stimStart+40,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+40,210]], fillColor=color4, lineColor=color4)
r13_2 = visual.ShapeStim(myWin, vertices=[[-stimStart+40,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+40,210]], fillColor=color4, lineColor=color4)
r14_1 = visual.ShapeStim(myWin, vertices=[[stimStart-40,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-40,210]], fillColor=color4, lineColor=color4)
r14_2 = visual.ShapeStim(myWin, vertices=[[stimStart-40,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-40,210]], fillColor=color4, lineColor=color4)

r21 = visual.ShapeStim(myWin, vertices=[[-stimStart,160],[-stimStart,210],[stimStart,210],[stimStart,160]], fillColor=color4, lineColor=color4)
r22 = visual.ShapeStim(myWin, vertices=[[-stimStart,-160],[-stimStart,-210],[stimStart,-210],[stimStart,-160]], fillColor=color4, lineColor=color4)
r23_1 = visual.ShapeStim(myWin, vertices=[[-stimStart+40,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+40,210]], fillColor=color4, lineColor=color4)
r23_2 = visual.ShapeStim(myWin, vertices=[[-stimStart+40,-210],[-(stimStart+a),-210],[-(stimStart+a),210],[-stimStart+40,210]], fillColor=color4, lineColor=color4)
r24_1 = visual.ShapeStim(myWin, vertices=[[stimStart-40,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-40,210]], fillColor=color4, lineColor=color4)
r24_2 = visual.ShapeStim(myWin, vertices=[[stimStart-40,-210],[stimStart+a,-210],[stimStart+a,210],[stimStart-40,210]], fillColor=color4, lineColor=color4)



instruction=visual.TextStim(myWin, ori=0, text='text', height=34, color='white', units= 'pix')
ResponseScreen=visual.TextStim(myWin, ori=0, text='Prompt', pos=[0, 0], height=34, color='white', units= 'pix')
dot = visual.Circle(myWin, radius=16, fillColor=color3, lineColor=None, interpolate=True, edges=46)
r5 = visual.Rect(myWin, pos=[0, 0], width=100, height=stimH2, fillColor='blue', lineColor=None)
rVertical = visual.Rect(myWin, pos=[0, 0], width=30, height=stimH2, fillColor=color1, lineColor=None)
#rVerticalBlank = visual.Rect(myWin, pos=[0, 0], width=80, height=stimH2, fillColor='black', lineColor=None)
smallDot = visual.Circle(myWin, radius=2, fillColor='black', lineColor=None, interpolate=True, edges=12)
dot.setSize([1.0,1.4])


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

def responseCollect(ResponseScreenLimit,Prompt,correctKey,screenLag):
    global responseKey
    global respRT
    global respCorr

    ResponseScreen.setText(Prompt)
    ResponseScreen.draw()
    myWin.flip()
    respClock=core.Clock()
    responseKey = event.waitKeys(keyList=['a','l'], maxWait = ResponseScreenLimit)
    respRT = respClock.getTime()
    respCorr = 0
    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
    elif correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
    elif correctKey == 's':
        if responseKey == ['s']:
            respCorr=1
    elif correctKey == 'k':
        if responseKey == ['k']:
            respCorr=1
    core.wait(screenLag) # here the words are still on the screen. 
    
def beads(x, nsteps, symmetry, orientation, p_r, p_y,p_o):
    
    diagonal = sqrt(2*stimH2*stimH2)
    jigger =8
    rjigger =8
    separation =14
    start_radius =26

    if symmetry =='randomConvex' or symmetry=='randomConcave':
        symmetry ='random'

    if symmetry =='refConcave' and orientation ==-1:
        separation = -separation
        aperture = visual.Aperture(myWin, size=diagonal, units='pix',pos=[x+stimSep-separation, 0],shape='square')
    else:
        aperture = visual.Aperture(myWin, size=diagonal, units='pix',pos=[x-stimSep-separation, 0],shape='square')
#        apertureSeparation = -separation
#    else:
#        apertureSeparation = separation
    aperture.enable()
    
    r_m1 =[]
    y_m1 =[]
    o_m1 =[]
    r_m2 =[]
    y_m2 =[]
    o_m2 =[]

    realSymmetry = symmetry #to remember the value before changing it
    if p_r ==[]:
        symmetry ='random'   #it is not really random but I set it to random because it is the first beads and so no reflection is necessary

    step = int(stimH2 /nsteps)   # vertical steps for each blob
    
    i=0
    for y in range (stimHeight,-stimHeight-1,-step):
        r = start_radius + randint(-rjigger,rjigger)
        yy = y + randint(-jigger,jigger)
        o =randint(1,180)
        if symmetry =='refConcave':
            r   =p_r[i]
            yy =p_y[i]
            o  =-p_o[i]
        i = i+1
        dot.setRadius(r)
        dot.setPos([x-separation,yy])
        dot.setOri(o)
#        dot.setFillColor('blue')
        if not (orientation==1 and p_r ==[]):
            if not(realSymmetry =='refConcave' and orientation ==-1 and  p_r ==[]):
                dot.draw()
        
        r_m1.append(r)
        y_m1.append(yy)
        o_m1.append(o)

    if realSymmetry =='refConcave' and orientation ==-1:
        aperture.setPos([x-stimSep+separation, 0])
    else:
        aperture.setPos([x+stimSep+separation, 0])        
    
    i=0
    for y in range (stimHeight,-stimHeight-1,-step):
        r = start_radius + randint(-rjigger,rjigger)
        yy = y + randint(-jigger,jigger)
        o =randint(1,180)
        r_m2.append(r)
        y_m2.append(yy)
        o_m2.append(o)
        if symmetry =='refConvex':
            r   =r_m1[i]
            yy =y_m1[i]
            o  =-o_m1[i]
        i =i+1
        dot.setRadius(r)
        dot.setPos([x+separation,yy])
        dot.setOri(o)
#        dot.setFillColor('blue')
        if not (orientation==-1 and p_r ==[]):
            dot.draw()
        if  (orientation==-1 and realSymmetry=='refConcave'):
            dot.draw() 
        
    aperture.disable()
    rVertical.setPos([x,0])
    rVertical.draw()
    
    return r_m2, y_m2, o_m2

        
def runBlock(filename):
    #set up handler to look after randomisation of trials etc
    restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    if filename=='data/practice':
        numrep =1
    else:
        numrep=10
    trials=data.TrialHandler(nReps=numrep, method='sequential', trialList=data.importConditions('trialbookOne1.xlsx')) #
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

#        symmetry ='randomConcave'  # debug
#        orientation =1 #debug
#        colore = 'color1'#debug
        
        if trialCounter in [32,64,96,128,160,192,224,256,288]:
            blockCounter = blockCounter+1
            block = noBlocks-(blockCounter)
            blockString= "%d blocks to go:     Wait for the experimenter to check electrodes" %(block)
            restScreen.setText(blockString)
            restScreen.draw()
            myWin.flip()
#            event.waitKeys(keyList = 'g')
        trialCounter = trialCounter + 1
        
#        if fixationPos =='right':
#            fixation.setPos((stimSep/4,0))
#        elif fixationPos =='left':
#            fixation.setPos((-stimSep/4,0))
        
        frameBlack2.draw()
        r11.draw()
        r12.draw()
        fixation.draw()#draws fixation

        myWin.flip()#flipping the buffers is very important as otherwise nothing is visible
#        event.waitKeys(keyList=["a"])
        
#        t = myClock.getTime() + 1.5     # fixation for this much time
#        while myClock.getTime() < t:
#            pass #do nothing
    
        p_r=[]
        p_y=[]
        p_o=[]
        
        if symmetry =='refConcave' or symmetry=='randomConcave':
            if colore=='color2':
                frameBlack.draw()
                rVertical.setFillColor(color4)  # this was color2
                dot.setFillColor(color4)         # this was color2
            elif colore=='color1':
                frameWhite.draw()
                rVertical.setFillColor(color4)   # this was black
                dot.setFillColor(color4)        # this was black


        elif symmetry =='refConvex' or symmetry=='randomConvex':  #testing how to fix the black version
            if colore=='color2':
                frameBlack2.draw()
                rVertical.setFillColor(color1)  # this was color2
                dot.setFillColor(color1)         # this was color2
            elif colore=='color1':
                frameBlack2.draw()
                rVertical.setFillColor(color2)   # this was black
                dot.setFillColor(color2)        # this was black
           
        if orientation==1:
            start =-stimStart
            end =stimEnd+1
            step =stimSep
            
        elif orientation==-1:
            start =stimStart
            end =-(stimEnd+1)
            step =-stimSep

# these centre the stimuli
        if symmetry=='refConcave' or symmetry =='randomConcave':
            if orientation==-1:
                start = start-(stimSep/4)
                end = end-(stimSep/4)
            else:
                start = start +(stimSep/4)
                end = end+(stimSep/4)

        if symmetry=='refConvex' or symmetry =='randomConvex':
            if orientation ==-1:
                start = start + (stimSep/4)
                end = end + (stimSep/4)
            else:
                start = start -(stimSep/4)
                end = end-(stimSep/4)

#these position the beads
        for ii in range(start,end,step):
            p_rtemp, p_ytemp, p_otemp =beads(ii, nsteps, symmetry, orientation, p_r, p_y,p_o)
            p_r =p_rtemp
            p_y=p_ytemp
            p_o=p_otemp

#these draw black borders around stimuli
        if symmetry=='refConcave' or symmetry=='randomConcave':
            if colore=='color1':      # color1 works for refConcave
                r11.draw()
                r12.draw()
                if orientation==1:
                    r13_1.draw()
                    r14_1.draw()
                else:
                    r13_2.draw()
                    r14_2.draw()                
            elif colore=='color2':       # color2 works for refConcave
                r21.draw()
                r22.draw()
                if orientation==1:
                    r23_1.draw()
                    r24_1.draw()
                else:
                    r23_2.draw()
                    r24_2.draw()

        elif symmetry =='refConvex' or symmetry=='randomConvex':
            if colore=='color2':      # color1 works for refConcave
                r11.draw()
                r12.draw()
                if orientation==-1:
                    r13_1.draw()
                    r14_1.draw()
                else:
                    r13_2.draw()
                    r14_2.draw()                
            elif colore=='color1':       # color2 works for refConcave
                r21.draw()
                r22.draw()
                if orientation==-1:
                    r23_1.draw()
                    r24_1.draw()
                else:
                    r23_2.draw()
                    r24_2.draw()

#        myWin.flip() #debug
#        event.waitKeys(keyList=['z'])   #debug

        fixation.draw()
#        parallel.setData(trigger)
        myWin.flip()

        myWin.getMovieFrame()
        

        imagename = 'images3/'+'p%s'%(trialCounter) +symmetry + colore + str(orientation) + '.png'
        myWin.saveMovieFrames(imagename)


#        parallel.setData(0)
#        event.waitKeys(keyList=['a'])   #debug
#        if event.getKeys(keyList=["escape"]):
#            core.quit()    # to close  and exit
#            event.clearEvents()
#            myWin.close
#        presentation = myClock.getTime() +1.5
#        while myClock.getTime()<presentation:
#            pass

#these create black square on response screen 
        frameBlack2.draw()
        r11.draw()
        r12.draw()
#        key = event.waitKeys(keyList=["a"])
        print symmetry, trigger
        
#        responseCollect(ResponseScreenLimit,Prompt,correctKey,screenLag)
        responseKey ='z'
        respRT =0
        respCorr =0
        trials.addData('responseKey',responseKey)
        trials.addData('respRT',respRT)
        trials.addData('respCorr',respCorr)

    #save all data
    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'sheet', dataOut=['all_raw'])
    
#message('HelloExperiment')
event.waitKeys(keyList=['space'])
runBlock('data/practice')
#message('HelloTask')
#event.waitKeys(keyList=['space'])
#runBlock('data/experiment')
message('Goodbye')
myWin.close()
core.quit()




