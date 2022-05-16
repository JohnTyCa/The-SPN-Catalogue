from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy as np
from psychopy import gui, visual, core, data, event, clock
import os  # handy system and path functions
import visualExtra

#expName='ElenaStereo'
#expInfo={'name':'','number':1}
#dlg=gui.DlgFromDict(dictionary=expInfo,title=expName) #dictionary for defining input fields, almost arbitraty values
#if dlg.OK:
#    print(expInfo)
#else:
#    print ('User cancelled')
#    core.quit() #user pressed cancel
    
#store info about the experiment
if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/datafile'

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
random.seed(seedN)

verticalSize = 1080
disp = 8
myWin = visual.Window(allowGUI=False, units='pix', size=(800,verticalSize), allowStencil=True, viewScale=[1.0, 1.0], fullscr= False, screen = 1)

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='red')#this is a gray cross for the fixation
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp2 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp3 = visual.GratingStim (myWin, tex=myTexture, size =[512,512])
temp = visual.ShapeStim (myWin, lineColor= 'red', fillColor=None)
tempLine = visual.Line (myWin, lineColor = 'green', start = [0,0], end = [0, 360])
#print (stencil.vertices)
myClock = core.Clock()#this creates and starts a clock which we can later read

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
        
        print (peri, nConcave)
        
    newcoords = visualExtra.rotateVertices(vertices = coords, a = numpy.rad2deg(increment/2))

    return newcoords

#def createContour(symmetry):
#    
#    d = 80
#    height = 84
#    nSteps = 14
#    step = height * 2  /nSteps
#    
#    c1 = []
#    c2 = []
#        
#    for i in range(nSteps +1):
#        y = step * i - height
#        j = int((height - abs(y)) /2)
#        x = -d + random.randint(-j,j)
#        c1.append([x,y])
#
#    for i in range(nSteps +1):
#        y = step * (nSteps -i ) - height
#        j = int((height - abs(y)) /2)
#        if symmetry == "sym":
#            x = -c1[nSteps -i][0]
#        else:
#            x = d + random.randint(-j,j)
#        c2.append([x,y])
#    print (c2)
#    c2.reverse()
#    print (c2)
#    return c1 + c2

    
# This long loop runs through the trials
def mainLoop():

    #set up handler to look after randomisation of trials etc
    trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('book.xlsx')) 
    upshift = verticalSize/2 #upshift value
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        cond = figureground + str(plane)
        #print (cond, symmetry)
        #cond = 'figure1' #debug only showing specified trials   
        nV = 32 #number of Vertices
        v = makePattern(0, 0, 'circle', nV, 200, 2)
        stencil = visual.Aperture(myWin, units="pix", shape= v)
        stencil.enabled = False
        
        temp.vertices = v
        temp.draw()
#        a = (360./nV)/2.
#        while a<360:
#            tempLine.setOri(a)
#            a = a + 360./nV
#            tempLine.draw()
#        myWin.flip()
#        event.waitKeys() 
        #continue
    
        myTexture = numpy.random.randint(0,2,(128,128))-0.5
        rdp1.tex = myTexture
        myTexture = numpy.random.randint(0,2,(128,128))-0.5
        rdp2.tex = myTexture
        myTexture = numpy.random.randint(0,2,(128,128))-0.5
        rdp3.tex = myTexture

        t = myClock.getTime() + 0.6     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
            
#depth plane -1
#        if cond == 'figure0' or cond == 'ground0':
#            rdp1.setPos([disp, -upshift])
#            rdp1.draw()
#            rdp1.setPos([0, upshift])
#            rdp1.draw()
#            
#depth plane 0
        if cond == 'figure0':  
            stencil.enabled = True
            stencil.inverted = False
            rdp2.setPos([0, -upshift])
            stencil.setPos ([0, -upshift])
            rdp2.draw()
            rdp2.setPos([0, upshift])
            stencil.setPos ([0, upshift])
            rdp2.draw()
            
        elif cond == 'ground0':
            stencil.enabled = True
            stencil.inverted = True   
            rdp2.setPos([0, -upshift])
            stencil.setPos ([0, -upshift])
            rdp2.draw()
            rdp2.setPos([0, upshift])
            stencil.setPos ([0, upshift])
            rdp2.draw()
            
        elif cond == 'figure1' or 'ground1':
            stencil.enabled = False
            rdp2.setPos([0, -upshift])
            rdp2.draw()
            rdp2.setPos([0, upshift])
            rdp2.draw()
        stencil.enabled = False

#depth plane 1
        if cond == 'figure1':
            stencil.enabled = True
            stencil.inverted = False
        
        elif cond == 'ground1':
            stencil.enabled = True
            stencil.inverted = True  
        if cond == 'figure1' or cond == 'ground1':
            rdp3.setPos([-disp, -upshift])
            stencil.setPos ([-disp, -upshift])
            rdp3.draw()
            rdp3.setPos([0, upshift])
            stencil.setPos ([0, upshift])
            rdp3.draw()
        stencil.enabled = False

        fixation.setPos([-disp, -upshift/2])
        fixation.draw()
        fixation.setPos([0, upshift/2])
        fixation.draw()
        myWin.flip()
            
        timenow = myClock.getTime()
        responseKeyOri = event.waitKeys(keyList=['a', 'l','escape'])
        respRT = myClock.getTime()-timenow #time taken to respond
        
        if responseKeyOri[0] == 'escape':
            core.quit()
        trials.addData('responseCond', responseKeyOri)
        trials.addData('respRt', respRT)
        
    #save all data
    trials.saveAsWideText(filename+'.txt')
    trials.saveAsExcel(filename+'.xlsx', sheetName= '', dataOut=['all_raw'])

mainLoop()
myWin.close()
core.quit()





