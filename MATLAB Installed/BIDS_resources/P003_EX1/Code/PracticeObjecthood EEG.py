
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui, parallel
import psychopy.log #import like this so it doesn't interfere with numpy.log
from pyglet.gl import *

weight = 2
width = 400 # All other dimensions are computed from this parameter
Edge = width/2
Disp = width/6
Jitter = width/8
linesPerContour = 12
Height = width/2
duration = 2
margin = width/10
baselineDurationMax = 2
baselineDurationMin = 1.5
#            warn = sound.Sound(800,secs=1,sampleRate=44100, bits=8)

#store info about the experiment
expName='ObjecthoodEEG'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName

#setup files for saving
if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, size=[1280,1024], units='pix', fullscr= True)
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='Black')
backgroundSquare = visual.PatchStim(myWin, tex='none', texRes = 500, size=(width+margin, Height+margin), mask ='none', interpolate=True, color= [0.6,0.6,0.6])
Line = psychopy.visual.Line(myWin, lineWidth = weight, lineColor = 'black')
Question=visual.TextStim(myWin, pos=[0, 0], height=20, color='black')
End = visual.TextStim(myWin, text = 'Experiment over. Thank you for participanting', pos=[0, 0], height=30, color='black')



trials=data.TrialHandler(nReps=1, method='random', trialList=data.importConditions('PracticeObjectTrialbook.xlsx'))
thisTrial=trials.trialList[0]#so we can initialise stimuli with some values

#psychopy.parallel.setData(0)

for thisTrial in trials:
    if thisTrial!=None:
        for paramName in thisTrial.keys():
            exec(paramName+'=thisTrial.'+paramName)
    
    baselineDuration = uniform(baselineDurationMax, baselineDurationMin)
    backgroundSquare.draw()
    fixation.draw()
    myWin.flip()
    core.wait(baselineDuration)
    backgroundSquare.draw()
    fixation.draw()
    
    
    if event.getKeys(["escape"]): 
        core.quit()
        event.clearEvents()
        myWin.close
    
    
    yPos = -(Height/2)
    xPos = (Disp + uniform(Jitter,-Jitter))

    if type == 'reflection':
        xPos2 = -xPos
    elif type == 'translation':
        xPos2 = xPos-(Disp*2)
    elif type == 'random':
        xPos2 = (Disp + uniform(Jitter,-Jitter))*-1
        
    S = [xPos, yPos]
    S2 = [xPos2, yPos]

    if objects == 1:
        Line.setStart(S)
        Line.setEnd(S2)
        Line.draw()


    elif objects == 2:
        Line.setStart(S)
        Line.setEnd([Edge,yPos])
        Line.draw()
        Line.setStart(S2)
        Line.setEnd([-Edge,yPos])
        Line.draw()

    for a in range(linesPerContour):
        Line.setStart(S)
        xPos = (Disp + uniform(Jitter,-Jitter))
        yPos = yPos+(Height/linesPerContour)
        E = [xPos, yPos]
        Line.setEnd(E)
        Line.draw()
        S = E
        
        if type == 'reflection':
            xPos2 = -xPos
            Line.setStart(S2)
            E2 = [xPos2, yPos]
            Line.setEnd(E2)
            Line.draw()
            S2 = E2
        elif type == 'translation':
            xPos2 = xPos-(Disp*2)
            Line.setStart(S2)
            E2 = [xPos2, yPos]
            Line.setEnd(E2)
            Line.draw()
            S2 = E2
        elif type == 'random':
            xPos2 = (Disp + uniform(Jitter,-Jitter))*-1
            Line.setStart(S2)
            E2 = [xPos2, yPos]
            Line.setEnd(E2)
            Line.draw()
            S2 = E2
    
    Line.setStart([Edge,-Height/2])
    Line.setEnd([Edge,+yPos])
    Line.draw()
    Line.setStart([-Edge,-Height/2])
    Line.setEnd([-Edge,+yPos])
    Line.draw()

    if objects == 1:
        Line.setStart(S)
        Line.setEnd(S2)
        Line.draw()
        
    elif objects == 2:
        Line.setStart(S)
        Line.setEnd([Edge,yPos])
        Line.draw()
        Line.setStart(S2)
        Line.setEnd([-Edge,yPos])
        Line.draw()
        
        

        
    psychopy.parallel.setData(trigger)
    myWin.flip()
    psychopy.parallel.setData(0)
    core.wait(duration)
    myWin.flip()
    if event.getKeys(["escape"]): 
            core.quit()
            event.clearEvents()
            myWin.close
    
    Question.setText(prompt)
    backgroundSquare.draw()
    Question.draw()
    myWin.flip()
    responseKey = event.waitKeys(keyList=['a', 'l'],maxWait = 3)
    if correctKey == 'a':
        if responseKey == ['a']: 
            respCorr=1
        else: 
            respCorr=0
#            warn.play()
#            core.wait(2)
#        
    if correctKey == 'l':
        if responseKey == ['l']:
            respCorr=1
        else:
            respCorr=0
#            warn.play()
#            core.wait(2)
    trials.addData('respCorr', respCorr)

trials.saveAsExcel(filename+'.xlsx', sheetName='trials',
    stimOut=['trigger', 'type', 'objects', 'prompt', 'correctKey'],
    dataOut=['all_raw'])

End.draw()
myWin.flip()
core.wait(4)
myWin.flip()
myWin.close()
core.quit()

