from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import math, numpy, random
import numpy
from psychopy import gui, visual, core, data, event, clock
import os  # handy system and path functions
import visualExtra

expName='ElenaStereo'
expInfo={'name':'','number':1}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: 
    core.quit() #user pressed cancel
    
#store info about the experiment
if not os.path.isdir('data'):      #folder data
    os.makedirs('data')#if this fails (e.g. permissions) we will get error
filename= 'data/datafile'

seedN =1000   #this way every subject sees the same stimuli, use subject number to have unique stimuli peer subject instead
#random.seed(seedN)

verticalSize = 1080
disp = 8
myWin = visual.Window(allowGUI=False, units='pix', size=(800,verticalSize), allowStencil=True, viewScale=[1.0, 0.5], fullscr= True, screen = 1)

#these lines are very powerful, they create all stimuli using the special functions of psychopy
fixation=visual.TextStim(myWin, text='+', pos=[0, 0], height=30, color='red')#this is a gray cross for the fixation
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp0 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
myTexture = numpy.random.randint(0,2,(256,256))-0.5
rdp1 = visual.GratingStim(myWin, tex=myTexture, size=[512,512])
temp = visual.ShapeStim (myWin, lineColor= 'red', fillColor=None) #drawing the stimuli outside the RDS
myClock = core.Clock()#this creates and starts a clock which we can later read
stencil = visual.Aperture(myWin, units="pix", shape = [[-60,-60],[-60,20],[40,0]])
stencil.enabled = False



    
# This long loop runs through the trials
def mainLoop():

    #set up handler to look after randomisation of trials etc
    trials=data.TrialHandler(nReps=10, method='random', trialList=data.importConditions('bookPreview.xlsx')) 
    upshift = verticalSize/2
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec('{} = thisTrial[paramName]'.format(paramName), locals(), globals())
        cond = figureground #+ str(plane)
#        vertices = [10, -10], [-10, -10], [-10, 10], [10, 10]
#        stencil.enabled = False
#        stencil.vertices = vertices        
        
      #  stencil.enabled = False
      # myTexture = numpy.random.randint(0,2,(128,128))*2-1   #between -1 and 1
       # rdp1.setTex(myTexture)
        #myTexture = numpy.random.randint(0,2,(64,64))-1    #between -0.5 and 0.5
        #rdp2.setTex(myTexture)
        #fixation.draw()#draws fixation
        #myWin.flip()#flipping the buffers is very important as otherwise nothing is visible

        #cc =visualExtra.generateSymmetry(symmetry='r', axes=1, ndots=16, radius=80, minDist=1, gapAxis=40)
        #cc = [visualExtra.polar2cartesian(i[0],i[1]) for i in cc]    # get cartesian coordinates
        #.shape=[[-20,-20],[-20,20],[40,0]]
        
        t = myClock.getTime() + 0.6     # fixation for this much time
        while myClock.getTime() < t:
            pass #do nothing
        
      #depth plane 0
            
        if cond == 'figure' or 'ground':
            stencil.enabled = False
            rdp0.setPos([0, -upshift])
            rdp0.draw()
            rdp0.setPos([0, upshift])
            rdp0.draw()
        stencil.enabled = False

#depth plane 1
        if cond == 'figure':
            stencil.enabled = True
            stencil.inverted = False
        
        elif cond == 'ground':
            stencil.enabled = True
            stencil.inverted = True  
        if cond == 'figure' or cond == 'ground':
            rdp1.setPos([-disp, -upshift])
            stencil.setPos ([-disp, -upshift])
            rdp1.draw()
            rdp1.setPos([0, upshift])
            stencil.setPos ([0, upshift])
            rdp1.draw()
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





