from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui #these are the psychopy libraries
from pyglet.gl import * #a graphic libraryimport math
envelopeHeight = 400 # how tall do you want the envelope of the stimulus to be?
practiceDuration =20# This has to match the practice trials in the Excel file (not very elegant)
blockDuration = 2000 # How many trials per block (this again has to match the block length in the excel file
minDotSize = 20
maxDotSize = 80
envelopeHeight2 = math.sqrt((envelopeHeight*envelopeHeight)*2)#to make the square fit inside the circle (not important)
dotSize = envelopeHeight/8
nDots = 9
Xpos = zeros(nDots)    #creates and fills an array with zeros
Ypos = zeros(nDots)

#store info about the experiment
expName='MemorySymmetry'
expInfo={'participant':'name', 'session':001}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)  #this is the dialog box to take name of participant
if dlg.OK==False: core.quit() #user pressed cancel

#seed(expInfo['session'])#the random seed is the subject number

expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
#setup files for saving
if not os.path.isdir('data'): os.makedirs('data')#if this fails (e.g. permissions) we will get error, otherwise it makes a directory to save the data in
filename= 'data/%s_%s' %(expInfo['participant'], expInfo['date'])

myWin = visual.Window(allowGUI=False, units='pix', fullscr= False, size = (1024,768))
#myWin = visual.Window([600,600], units='pix', allowGUI=True, fullscr= False)  # this smaller screen is useful while one is still developing the experiment

#these lines are very powerful, they create all stimuli using the special functions of psychopy
myDot = visual.PatchStim(myWin, tex='none', texRes = 500, size=(dotSize,dotSize), interpolate=True, color = 'black')#this we call myDot is a dot we use to produce a pattern 
fixation=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=60, color='Grey')#this is a gray cross for the fixation
backgroundCircle = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeHeight2,envelopeHeight2), mask ='circle', interpolate=True, color= 'black')#a background circle
backgroundSquare = visual.PatchStim(myWin, tex='none', texRes = 500, size=(envelopeHeight, envelopeHeight), mask ='none', interpolate=True, color= 'white', ori = 45)#a background square
wordScreen=visual.TextStim(myWin, ori=0, text='OLD (O)                 NEW (N)', pos=[0, 400], color='grey')#the screen with the word
questionScreen=visual.TextStim(myWin, ori=0, text='was it random?', pos=[0, 0], color='Black')#the screen with the question
restScreen=visual.TextStim(myWin, ori=0, text='Break   Press any key to continue', pos=[0, 0], color='Black')#the screen at the end of a block


            
#set up handler to look after randomisation of trials etc
trials=data.TrialHandler(nReps=5, method='sequential', trialList=data.importConditions('StimMaker.xlsx'))
thisTrial=trials.trialList[0]#so we can initialise stimuli with some values

     
# This sets out the template for one quadrant
Xpos[0] = (dotSize+(dotSize/2))
Ypos[0] = (dotSize/2)
            
Xpos[1] = (dotSize*2)+(dotSize/2)
Ypos[1] = (dotSize/2)
            
Xpos[2] = (dotSize*3)+(dotSize/2)
Ypos[2] = (dotSize/2)
            
Xpos[3] = (dotSize/2)
Ypos[3] = (dotSize+(dotSize/2))
            
Xpos[4] = (dotSize+(dotSize/2))
Ypos[4] = (dotSize+(dotSize/2))
            
Xpos[5] =(dotSize*2)+(dotSize/2)
Ypos[5] = (dotSize+(dotSize/2))
            
Xpos[6] = (dotSize/2)
Ypos[6] = (dotSize*2)+(dotSize/2)
            
Xpos[7] = (dotSize+(dotSize/2))
Ypos[7] = (dotSize*2)+(dotSize/2)
            
Xpos[8] = (dotSize/2)
Ypos[8] = (dotSize*3)+(dotSize/2)


#this creates adn starts a clock which we can later read
myClock = core.Clock()

backgroundCircle.draw()
backgroundSquare.draw()
fixation.draw()
myWin.flip()#flipping the buffers is very important as otherwise nothing is visible

trialCounter = trialWithinBlock= 0

# This long loop runs through the trials
for thisTrial in trials:

    backgroundCircle.draw()
    backgroundSquare.draw()
    fixation.draw()
    myWin.flip()  # show the empty context
    
    if thisTrial!=None:
        for paramName in thisTrial.keys():
            exec(paramName+'=thisTrial.'+paramName) #this looks strange but it is just mkes the variables more readable

    t = myClock.getTime() + 0.1   #to turn ITI from msec to sec
    
    backgroundCircle.draw()
    backgroundSquare.draw()
    #fixation.draw()
        Qpoints = [0,0,0,0,1,1,1,1,1]
    
    shuffle(Qpoints)

    for n in range(nDots):
            
            X = Xpos[n] #from the vector constructed above
            Y = Ypos[n] # from the vector constructed above

                        
            if Qpoints[n] == 1:
                myDot.setColor('black')
            elif Qpoints[n] == 0:
                myDot.setColor('white')
            
            Orientation = randint(1, 3)
            if Orientation== 1:
                myDot.setOri(45)
            elif Orientation == 2:
                myDot.setOri(0)
                
            Size = uniform(minDotSize, maxDotSize)
            myDot.setSize(Size)
                
            myDot.setPos([X, Y])
            myDot.draw()

            if Type == 'Reflection':
                myDot.setPos([-X, - Y])
                myDot.draw()
                myDot.setPos([-X, Y])
                myDot.draw()
                myDot.setPos([X, -Y])
                myDot.draw()
           
            if Type == 'Random':
                
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myDot.setOri(45)
                elif Orientation == 2:
                        myDot.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myDot.setSize(Size)
                myDot.setPos([-X, - Y])
                myDot.draw()

                
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myDot.setOri(45)
                elif Orientation == 2:
                        myDot.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myDot.setSize(Size)
                myDot.setPos([-X, Y])
                myDot.draw()
               
                Orientation = randint(1, 3)
                if Orientation== 1:
                        myDot.setOri(45)
                elif Orientation == 2:
                        myDot.setOri(0)
                Size = uniform(minDotSize, maxDotSize)
                myDot.setSize(Size)
                myDot.setPos([X, - Y])
                myDot.draw()
                
    while myClock.getTime() < 0.1:#do nothing for an interval that lasts ITI seconds
        pass
    myWin.flip(clearBuffer = True)# draw the stimuli
    myWin.getMovieFrame()
    if event.getKeys(["escape"]):
        core.quit()
        event.clearEvents()
        myWin.close

    
#save all data
trials.saveAsExcel(filename+'.xlsx', sheetName='trials',
    stimOut=['Type','History','ITI', 'Version', 'Block'],
    dataOut=['all_raw'])myWin.saveMovieFrames('j.png') # useful  screen saver system 
myWin.close()
core.wait(2)
core.quit()


