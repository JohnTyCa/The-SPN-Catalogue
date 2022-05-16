from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, gui #these are the psychopy libraries
from pyglet.gl import * #a graphic library
import math

envelopeHeight = 400 # how tall do you want the envelope of the stimulus to be?
practiceDuration =20# This has to match the practice trials in the Excel file (not very elegant)

minDotSize = 20
maxDotSize = 80
envelopeHeight2 = math.sqrt((envelopeHeight*envelopeHeight)*2)#to make the square fit inside the circle (not important)
dotSize = envelopeHeight/8
nDots = 9
Xpos = zeros(nDots)    #creates and fills an array with zeros
Ypos = zeros(nDots)

myWin = visual.Window(allowGUI=False, units='pix', fullscr= False, size = (600,600))
myClock = core.Clock()
myDot = visual.Rect(myWin, size=(dotSize,dotSize), interpolate=True, fillColor = 'black',lineColor ='black')#this we call myDot is a dot we use to produce a pattern 
fixation=visual.TextStim(myWin, ori=0, text='+', pos=[0, 0], height=60, color='Grey')#this is a gray cross for the fixation
backgroundCircle = visual.Circle(myWin, edges = 512,interpolate=True,radius= envelopeHeight2/2, fillColor= 'black',lineColor ='black')#a background circle
backgroundSquare = visual.Rect(myWin, size=(envelopeHeight, envelopeHeight), interpolate=True, fillColor= 'white',lineColor ='white', ori = 45)#a background square

     
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



trials=data.TrialHandler(nReps=1, method='sequential', trialList=data.importConditions('StimMaker.xlsx'))

# This long loop runs through the trials
for thisTrial in trials:
    if thisTrial!=None:
        for paramName in thisTrial.keys():
            exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals()) #Python 3 string formatting #this looks strange but it is just mkes the variables more readable
    
    backgroundCircle.draw()
    backgroundSquare.draw()
    fixation.draw()
    myWin.flip()  # show the empty context
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
            elif Type == 'Rotation':
                myDot.setPos([-X, -Y])
                myDot.draw()
                myDot.setPos([-Y, X])
                myDot.draw()
                myDot.setPos([Y, -X])
                myDot.draw()
            elif Type == 'Random':
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
    myWin.flip()# draw the stimuli
    myWin.getMovieFrame()
    n= "%s%s%s" %(Type,counter,'.png')
    myWin.saveMovieFrames(n)
    if event.getKeys(["escape"]):
        core.quit()
        event.clearEvents()
        myWin.close

    
myWin.close()
core.quit()





