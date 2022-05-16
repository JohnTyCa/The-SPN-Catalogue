from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual, core, data, event, sound, gui#,parallel #these are the psychopy libraries
import math
import visualExtra
#parallel

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0)

baselineDuration = 1.0
ISI =1.5
durationOne = 0.25
durationTwo = 0.5

radius = 80
angle = 10
jigger =20
ResponseScreenLimit = 60 # how many seconds do you want the oddball screen to be on?
screenLag = 0.3
s1 = sound.Sound(800,secs=0.5,sampleRate=44100, bits=16)


myWin = visual.Window(allowGUI=False, size=[300,100],monitor = 'EEG lab participant', units='pix', fullscr= False)
responseScreen=visual.TextStim(myWin, ori=0,text = 'x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=50, color='black')
myTarget =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'red')
disk = visual.Circle(myWin, radius=100, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
diskSmall = visual.Circle(myWin, radius=80, lineColor=None, fillColor=[0,0,0])
diskTiny = visual.Circle(myWin, radius=8, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
cellTiny = visual.Rect(myWin, width=20, height=20, lineColor=None, fillColor=[-0.5,-0.5,-0.5])
frame = visual.Rect(myWin, width=200, height=200, lineColor=[1,-1,-1], fillColor=None)

#stim =visual.ShapeStim(myWin, fillColor=[-1,-1,-1], lineColor =None)
stim =visual.ShapeStim(myWin, fillColor=[1,-1,-1], lineColor =None)
#myFlanker =visual.ShapeStim(myWin, lineWidth = 2, lineColor = 'black', fillColor = 'black')

ResponseScreen=visual.TextBox(myWin, text = 'Same Pattern            Do Not Know            Different Pattern', textgrid_shape=[70,3], pos=[0, 0], grid_horz_justification='center', grid_vert_justification='center', font_size=20,font_color = 'white',  units= 'pix')
restScreen = visual.TextStim(myWin, ori=0, text='message', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
feedbackScreen =  visual.TextStim(myWin, ori=0, text='x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
totalScreen =  visual.TextStim(myWin, ori=0, text='x', pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
respClock=core.Clock()

def rewardSound():
    s1 = sound.Sound(200,secs=0.2,sampleRate=44100, bits=16)
    s2 = sound.Sound(250,secs=0.2,sampleRate=44100, bits=16)
    s3 = sound.Sound(300,secs=0.2,sampleRate=44100, bits=16)
    s1.play()
    core.wait(0.2)
    s2.play()
    core.wait(0.2)
    s3.play()
    core.wait(0.2)
    

def punishmentSound():
    s1 = sound.Sound(150,secs=0.6,sampleRate=44100, bits=16)
    s1.play()
    core.wait(0.6)



def message(Type, nBlocksToGo = 1, total= 1):
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice. You will see two patterns. You task is to decide whether they were the same or different')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but  longer than the practise. Try not to blink, and keep your eyes on the central fixation cross')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the experiment')
    elif Type == 'Break':
        message = 'You have %s points! %s Blocks to go: Wait for experimenter to check electrodes' %(total,nBlocksToGo)
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()

def responseCollect(correctKey):
    ResponseScreen.draw()
    
    myWin.flip()
   # myWin.getMovieFrame()
   # myWin.saveMovieFrames('choice.png')
    responseKey = event.waitKeys(keyList=['z','v','m'])
    respRT = respClock.getTime()
    
    if responseKey ==None:
        respCorr =-1
    else:
        if responseKey[0]  == 'escape':
            event.clearEvents()
            myWin.close
            core.quit()    # to close  and exit

    respCorr = -1
    if correctKey == 'z':
        if responseKey == ['z']: 
            respCorr=1
    elif correctKey == 'm':
        if responseKey == ['m']:
            respCorr=1
    
    if responseKey == ['v']:
        respCorr = 0
    #print respCorr,correctKey,responseKey
    core.wait(screenLag) # here the words are still on the screen. 
    if respCorr == 1:
       feedbackScreen.setText('you win 1 point :)')
       feedbackScreen.setColor('green')
       feedbackScreen.draw()
       myWin.flip()
       myWin.getMovieFrame()
       rewardSound()
       myWin.saveMovieFrames('win.png')

    if respCorr == -1:
        feedbackScreen.setText('you lose 1 point :(')
        feedbackScreen.setColor('red')
        feedbackScreen.draw()
        myWin.flip()
        myWin.getMovieFrame()
        punishmentSound()
        myWin.saveMovieFrames('lose.png')
        
    return responseKey, respRT, respCorr

responseCollect('z')
myWin.close()
core.quit()

