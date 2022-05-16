import os #handy system and path functions
from psychopy import core, data, event, sound, visual, gui#, parallel #these are the psychopy libraries
import random, math
import visualExtra

saveImage = False  #a flag for the saving of static images

#parallel.PParallelInpOut32
#parallel.setPortAddress(address=0xE010)
#parallel.setData(0) #these are the psychopy libraries

import random, math
import visualExtra

saveImage = True  #a flag for the saving of static images

#store info about the experiment
#if not os.path.isdir('dataB'):      #folder data
#    os.makedirs('dataB')       #if this fails (e.g. permissions) we will get error
#expInfo={'participant':'','number':0}
#dlg=gui.DlgFromDict(dictionary=expInfo, title='RotationBaseline')
#if dlg.OK==False: core.quit() #user pressed cancel
#expInfo['date']=data.getDateStr()#add a simple timestamp
#expInfo['expName']='rotationBaseline'

if saveImage:
    myWin = visual.Window(allowGUI=False, units='pix', size =(800,800), fullscr=False)#creates a window using pixels as units
    orderTrials = 'sequential'
else:
    myWin = visual.Window(allowGUI=False, units='pix', size =(800,800), fullscr=False)#creates a window using pixels as units
    orderTrials = 'random'

colPoly =[-.4,-.4,-.4]
colTop =[-.3,-.4,-.4]
#these lines are very powerful, they create all stimuli using the special functions of psychopy
#fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='red')#this is a gray cross for the fixation
#stim1 = visual.ImageStim(myWin, image='symm.png')      #import an image from a file
polyL = visual.ShapeStim(myWin, lineColor=None, fillColor=None)
polyR = visual.ShapeStim(myWin, lineColor=None, fillColor=None)
polyL2 = visual.ShapeStim(myWin, lineColor=None, fillColor=colPoly)
polyR2 = visual.ShapeStim(myWin, lineColor=None, fillColor=colPoly)
polyTop = visual.ShapeStim(myWin, lineColor=None, fillColor=colTop)
contour =visual.ShapeStim(myWin, lineColor='black', fillColor=None)
contourFill =visual.ShapeStim(myWin, lineColor=None, fillColor=colPoly)
frame = visual.Rect(myWin, lineColor='blue', fillColor=None, width = 240, height=400)
fixation = visual.Circle(myWin, lineColor=None, fillColor='red', radius = 10)
dot = visual.Circle(myWin, lineColor='red', fillColor=None, radius = 12)
occluder = visual.ShapeStim(myWin, fillColor='white', lineColor=None, vertices=[[0,300],[200,300],[200,-300],[0,-300]])
occluderTop = visual.ShapeStim(myWin, fillColor=[1,.9,.9], lineColor=None, vertices=[[0,300],[200,300],[200,0],[0,0],[0,300]])
gaborSize = 32
gabor = visual.GratingStim(myWin, tex="sin", mask="gauss", texRes=256,  pos=[0,-300], units='pix', size=[gaborSize,gaborSize], contrast=0.5, phase=0.5, sf=[0.125,0.125], ori=0)
gaborBig = visual.GratingStim(myWin, tex="sin", mask="gauss", texRes=256,  pos=[0,0], units='pix', size=[160,160], contrast=0.5, phase=0.5, sf=[0.125,0.125], ori=0)
myClock = core.Clock()#this creates adn starts a clock which we can later read
responseScreen=visual.TextStim(myWin, ori=0, pos=[0,0], height=24, color='white', units= 'pix')   #font='Times New Roman')
warn = sound.Sound(value='C',secs=0.6,sampleRate=44100)#, bits=16)

nsteps = 16
height = 200
width =120
ystep = 2. * height / nsteps # 40
jitter =46

def message(type, nBlocksToGo = 1):
    if type == 'Practice1':
        message = 'Welcome to the Practice. You will see a rotating pattern. Your task is to decide whether the grey object has a reflection'
    if type == 'Practice2':
        message = 'A bit more practice, now with just two presentations. Your task is again to decide whether the grey object has a reflection'
    elif type == 'Experiment':
        message = 'Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point'
    elif type == 'Goodbye':
        message ='Thank you for taking part in the Experiment'
    elif type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
#    if not type == 'Break':
    myWin.flip()
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', units= 'pix')
    Instructions.draw()
    myWin.flip()
    event.waitKeys(keyList=['g'])

def collectResponse(regularity, responseScreenVersion, startPos, practice):
    event.clearEvents()
    if startPos=='left':
        responseScreen.setPos([0,-100])
    elif startPos=='right':
        responseScreen.setPos([0,100])
    
    if responseScreenVersion == 1:
        responseScreen.setText('reflection  random')
        responseScreen.draw()
        myWin.flip()  # 

        responseKey = event.waitKeys(keyList=['a', 'l'])[0]
        if responseKey == 'a':
            choice = 'ref'
        elif responseKey == 'l':
            choice = 'ran'
        if regularity== choice:
            respCorr = 1
        else:
            respCorr = 0
    elif responseScreenVersion == 2:
        responseScreen.setText('random  reflection')
        responseScreen.draw()
        myWin.flip()
        
        responseKey = event.waitKeys(keyList=['a', 'l'])[0]
        if responseKey == 'l':
            choice = 'ref'
        elif responseKey == 'a':
            choice = 'ran'
        if regularity== choice:
            respCorr = 1
        else:
            respCorr = 0
            
    if respCorr==0 and practice==True:
        warn.play()
    return respCorr, choice
    
def rotateObject(obj, deg):
    
    v = obj.vertices
    visualExtra.rotateVertices(vertices= v, a=deg)
    obj.vertices = v

def drawGabors(coordsGL, coordsGR, oriGL, oriGR, direction):

    gaborBig.setOri(direction)
    coordsGR = visualExtra.rotateVertices(vertices= coordsGR, a=direction)
    coordsGL = visualExtra.rotateVertices(vertices= coordsGL, a=direction)
    
    gaborBig.draw()

#    for i in range(len(coordsGR)):
#        gabor.setPos(coordsGR[i])
#        gabor.setOri(oriGR[i][0])
#        gabor.draw()
#        gabor.setPos([-40,0],"+")
#        gabor.setOri(oriGR[i][0])
#        gabor.draw()
#    for i in range(len(coordsGL)):
#        gabor.setPos(coordsGL[i])
#        gabor.setOri(oriGL[i][0])
#        gabor.draw()
#        gabor.setPos([+40,0],"+")
#        gabor.setOri(oriGL[i][0])
#        gabor.draw()


def prepareOri(regularity):
    
    oriGR = []
    oriGL = []
    
    for i in range(1, nsteps):
            oriGR.append([random.uniform(0,180),random.uniform(0,180)])
#            oriG.append(random.uniform(0,180))
#            oriG.append(random.uniform(0,180))
            
    if regularity =='ref':
        oriGL= [[-i[0],-i[1]] for i in oriGR]
#                oriG.append(-oriG[10 -i])
#                oriG.append(oriG[10 -i])
    elif regularity=='ran':
        for i in range(1, nsteps):
            oriGL.append([random.uniform(0,180),random.uniform(0,180)])
#            oriG.append(random.uniform(0,180))
#            oriG.append(random.uniform(0,180))

    return oriGR, oriGL
    
def prepareCoords(regularity):

    coordsL =[]
    coordsR =[]
    coordsGL =[]
    coordsGR =[]
    
    coordsR.append([0,-height])
    y = -height
    for i in range(nsteps+1):
#        if i < 
        x = width + random.uniform(-jitter,jitter)
        coordsR.append([x,y])
        y = y + ystep
    coordsR.append([0,height])
    coordsR.append([0,ystep*2])
    
    coordsL.append([0,-height])
    y = -height
    if regularity =='ref':
        for i in range(1,nsteps+2):
            x = -coordsR[i][0]
            coordsL.append([x,y])
            y = y + ystep
    elif regularity=='ran':
        for i in range(1, nsteps +2):
            x = -width + random.uniform(-jitter,jitter)
            coordsL.append([x,y])
            y = y + ystep
    coordsL.append([0,height])
    coordsL.append([0,ystep*2])
    
    for i in range(2, nsteps+ 1):
            coordsGR.append([coordsR[i][0] -20, coordsL[i][1]])
#            coordsGR.append([coordsR[i][0] -20-gaborSize, coordsR[i][1]])
#            coordsG.append([coords[i][0] -20-gaborSize*2, coords[i][1]])
    for i in range(2, nsteps+ 1):        
            coordsGL.append([coordsL[i][0] +20, coordsL[i][1]])
#            coordsGL.append([coordsL[i][0] +20+gaborSize, coordsL[i][1]])
#            coordsG.append([coords[i][0] +20+gaborSize*2, coords[i][1]])

    return coordsL, coordsR, coordsGL, coordsGR

def drawGreyPolys(v):

    c = []
    for i in range(1,17):
        c.append(v[i])
        c.append(v[i+1])
        c.append(v[36-i-1])
        c.append(v[36-i])
        c.append(v[i])
        contourFill.setVertices(c)
        if i==12:
            contourFill.setFillColor(colTop)
        contourFill.draw()
        c =[]

    contourFill.setFillColor(colPoly)

def drawPolys(coordsL, coordsR, direction):

    coordsR = visualExtra.rotateVertices(vertices= coordsR, a=direction)
    coordsL = visualExtra.rotateVertices(vertices= coordsL, a=direction)

    polyR.setVertices(coordsR)
    polyL.setVertices(coordsL)
    
#    polyR.draw()
#    polyL.draw()

#    position =nsteps /2 + 3    # for nsteps 10 this is 7 for nsteps 16 this is 10
#    v = list(coordsL[position:])
#    polyTop.setVertices(v)
#    polyTop.draw()
#    v = list(coordsR[position:])
#    polyTop.setVertices(v)
#    polyTop.draw()
    
    position = nsteps +2     # if nsteps is 10 this shoudl be 12 for nsteps 16 this is 18
    v1 = list(coordsR[:position])  
    v2 = coordsL[::-1]
    v = v1+v2[1:position+1]
    contour.setVertices(v)

    drawGreyPolys(v)
    contour.draw()
#    coordsR = [[i*.9,j*.9] for [i,j] in coordsR]
#    coordsL =[[i*.9,j*.9] for [i,j] in coordsL]
#
#    polyR.setVertices(coordsR)
#    polyL.setVertices(coordsL)
#    
#    polyR.draw()  # these are the smaller versions
#    polyL.draw()
#
#    v1 = list(coordsR[:12])  
#    v2 = coordsL[::-1]
#    v = v1+v2[1:13]
#    contour.setVertices(v)
#    contour.draw()

#def drawPolysTop(coordsL, coordsR, direction):
#    
#    coordsR = visualExtra.rotateVertices(vertices= coordsR, a=direction)
#    coordsL = visualExtra.rotateVertices(vertices= coordsL, a=direction)
#
#    polyR.setVertices(coordsR)
#    polyL.setVertices(coordsL)
#    
#    polyR.draw()
#    polyL.draw()


def runBlock(trialbook="", practice=True, repeti=1):
    
    trials=data.TrialHandler(nReps=repeti, method=orderTrials, trialList=data.importConditions(trialbook)) 
    blockDuration = 24
    nBlocksToGo = trials.nTotal / blockDuration  #336/24=14
    counter =0
    
    # This long loop runs through the trials
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
                #exec(paramName+'=thisTrial.'+paramName)
                

        if counter == blockDuration and practice=='exp':
                nBlocksToGo = nBlocksToGo - 1
                message('Break', nBlocksToGo = nBlocksToGo)
                counter = 0
        counter = counter +1
        
        
        fixation.draw()#draws fixation
        myWin.flip()    # fixation and nothing else

        occluder.vertices =([[0,300],[200,300],[200,-300],[0,-300],[0,300]])
        occluderTop.vertices =([[0,300],[200,300],[200,100],[0,100],[0,300]])
        v = occluder.vertices
        vTop = occluderTop.vertices
        if startPos =='left':
            v = [[-i[0],i[1]] for i in v]
            vTop = [[-i[0],i[1]] for i in vTop]            
        occluder.vertices = visualExtra.rotateVertices(vertices= v, pos=[0,0], a= direction)
        occluderTop.vertices = visualExtra.rotateVertices(vertices= vTop, pos=[0,0], a= direction)
        
    #    regularity ='ref'    # debug
    #    direction = 45   # debug
            
#        t = myClock.getTime() + 0.5     # fixation for this much time
#        while myClock.getTime() < t:
#            pass #do nothing

        occluder.draw()
        occluderTop.draw()
        fixation.draw()    #draws fixation
        myWin.flip()     # fixation and occluder
        
        t = myClock.getTime() + 1.5     # occluder for this much time
        while myClock.getTime() < t:
            pass #do nothing
    
        coordsL, coordsR, coordsGL, coordsGR =prepareCoords(regularity)
        oriGL, oriGR = prepareOri(regularity)
    
        drawPolys(coordsL, coordsR, direction)
#        drawGabors(coordsGL, coordsGR, oriGL, oriGR, direction)
        
        occluder.draw()
        occluderTop.draw()
        fixation.draw()#draws fixation
        myWin.flip()   # firts interval
        #parallel.setData(trigger)
        t = myClock.getTime() + .5     # first image for this much time
        while myClock.getTime() < t:
            pass #do nothing
        #parallel.setData(0)
        
        

        myWin.getMovieFrame()
        myWin.getMovieFrame()
        n= "%s%s%s" %(regularity,startPos,'T1.png')
        myWin.saveMovieFrames(n)
    
        t = myClock.getTime() + firstHalfDuration     # first image for this much time
        while myClock.getTime() < t:
            pass #do nothing

        if False:  #practice =='practice1':
            drawPolys(coordsL, coordsR, direction-90)
    #        drawGabors(coordsGL, coordsGR, oriGL, oriGR, direction+90)
#            v = occluder.vertices
#            vTop = occluderTop.vertices
            v2 = visualExtra.rotateVertices(vertices= v, pos=[0,0], a=-45)  #occluder.vertices
            vTop2 = visualExtra.rotateVertices(vertices= vTop, pos=[0,0], a=-45) #occluderTop.vertices

            occluder.vertices =v2
            occluderTop.vertices = vTop2
            occluder.draw()
            occluderTop.draw()
            fixation.draw()#draws fixation
            myWin.flip()  # extra interval for the practice
            core.wait(0.1)

        drawPolys(coordsL, coordsR, direction)
        v3 = visualExtra.rotateVertices(vertices= v, pos=[0,0], a=-direction)  #occluder.vertices
        vTop3 = visualExtra.rotateVertices(vertices= vTop, pos=[0,0], a=-direction) #occluderTop.vertices
        v3 = [[-i[0],i[1]] for i in v3]
        vTop3 = [[-i[0],i[1]] for i in vTop3]            
        occluder.vertices =v3
        occluderTop.vertices = vTop3
#        occluder.vertices = visualExtra.rotateVertices(vertices= v, pos=[0,0], a=0)
#        occluderTop.vertices = visualExtra.rotateVertices(vertices= vTop, pos=[0,0], a=0)

        occluder.draw()
        occluderTop.draw()
        fixation.draw()#draws fixation
        myWin.flip()  # second interval
        
        myWin.getMovieFrame()
        myWin.getMovieFrame()
        n= "%s%s%s" %(regularity,startPos,'T2.png')
        myWin.saveMovieFrames(n)
        
        t = myClock.getTime() + secondHalfDuration     # second image for this much time
        while myClock.getTime() < t:
            pass #do nothing

        drawPolys(coordsL, coordsR, direction)
        occluder.draw()
        occluderTop.draw()
        fixation.draw()#draws fixation
    
  #      timenow = myClock.getTime()
 #       correct, choice = collectResponse(regularity, responseScreenVersion, startPos, practice!='exp')
#        correct =1  #debug
#        choice ='ref' #debug
#        respRT = myClock.getTime()-timenow #time taken to respond
        
#        trials.addData('correct', correct)
#        trials.addData('choice', choice)
#        trials.addData('respRt', respRT)
        
        if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        
    #save all data
#    trials.extraInfo =expInfo
#    if not practice=='exp':
#        trials.saveAsWideText('dataB/rotationB.txt')
#        trials.saveAsExcel('dataB/rotationB.xlsx', sheetName= 'HorizontalVertical', dataOut=['all_raw'])
#    else:
#        trials.saveAsWideText('dataB/practiceB.txt')
#        trials.saveAsExcel('dataB/practiceB.xlsx', sheetName= 'HorizontalVertical', dataOut=['all_raw'])

#message('Practice1')
runBlock(trialbook='rotationBaselineBook.xlsx' , practice='practice1', repeti=1) # (24 trials: 8 conditions: 3l repetitions) .
#message('Practice2')
#runBlock(trialbook='rotationBaselineBook.xlsx' , practice='practice2', repeti=2) # (8 trials: 8 conditions: 1 repetitions) .
#message('Experiment')
#runBlock(trialbook='rotationBaselineBook.xlsx', practice='exp', repeti=42) # (336 trials: 8 conditions: 42 repetitions) . 
#message('Goodbye')
myWin.close()
core.quit()




