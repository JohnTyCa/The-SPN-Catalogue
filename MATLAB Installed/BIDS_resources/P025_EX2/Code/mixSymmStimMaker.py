from psychopy import core, gui, visual, event, os, data
import visualExtra # 
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
axes = 4


pPreserved = 0.875
np = int(pPreserved*100)
ndotsTotal = 64
ndotsStim1 = ndotsTotal*pPreserved

print(ndotsStim1)


dotSize = 17
orientation = 0
radius = 63 # 1.75 raidus =  3.5 diameter degrees wide
minimumDist = 5.3
gap = 3

myWin = visual.Window(size = [200,200], allowGUI=False, monitor = 'EEGlab_3d', units = 'pix', fullscr= False, color=[-1,-1,-1], screen=2)
border =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')
border2 =visual.Circle(myWin,  edges = 512, radius = radius+dotSize, interpolate=True, fillColor=[0.2, 0.2 ,0.2], lineColor=[0.2,0.2,0.2], units= 'pix')


myTexture = zeros([4,4])-1
gaborBlack = visual.GratingStim(myWin, tex=myTexture, mask="gauss", contrast = 0.5, units='pix', size=[dotSize,dotSize])
myTexture = zeros([4,4])+1
gaborGreen = visual.GratingStim(myWin, tex=myTexture, mask="gauss", color=(-1,-0.2,-1), units='pix', size=[dotSize,dotSize])



def prepareStim(ndots, total, radius):
    stim1 = visualExtra.generateSymmetry(symmetry='r', axes=axes, ndots=ndots, radius=radius, minDist=minimumDist, gapAxis=minimumDist)
    stim2 = visualExtra.generateSymmetry(symmetry='r', axes=axes, ndots=(total - ndots), radius=radius, minDist=minimumDist, gapAxis=minimumDist)
    while visualExtra.overlapCoords(stim1, stim2, minDist=minimumDist):
        stim2 = visualExtra.generateSymmetry(symmetry='r', axes=axes, ndots=(total - ndots), radius=radius, minDist=minimumDist, gapAxis=minimumDist)
        
    stim3 = visualExtra.generateSymmetry(symmetry='r', axes=axes, ndots=(total - ndots), radius=radius, minDist=minimumDist, gapAxis=minimumDist)
    foo = stim1 + stim2

    while visualExtra.overlapCoords(stim3, foo, minDist=minimumDist):
        stim3 = visualExtra.generateSymmetry(symmetry='r', axes=axes, ndots=(total - ndots), radius=radius, minDist=minimumDist, gapAxis=minimumDist) 
    
    return stim1, stim2, stim3

# draw the stimuli
def drawStim(shape1, shape2, orientation1, orientation2,bColor = 'none'):
    v1 = [visualExtra.polar2cartesian(i[0],i[1]) for i in shape1]    # get cartesian coordinates
    v2 = [visualExtra.polar2cartesian(i[0],i[1]) for i in shape2]    # get cartesian coordinates
    
    border.draw()
    if bColor == 'red' or bColor == 'blue':
        border2.setLineColor(bColor)
        border2.draw()
        
    for i in v2:
        gaborGreen.setPos(i)
        gaborGreen.draw()
    for i in v1:
        gaborGreen.setPos(i)
        gaborGreen.draw()
        
#    fixationCircle.draw()

for i in range(120):
    
    
    
    stim1, stim2, stim3 = prepareStim(ndotsStim1, ndotsTotal, radius)
    drawStim(stim1, stim2, 0, 0)
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s%s" %(np,'redSample',i,'.png')
    myWin.saveMovieFrames(n)
    
    drawStim(stim1, stim3, 0, 0,'red')
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s%s" %(np,'redTest',i,'.png')
    myWin.saveMovieFrames(n)

    stim1, stim2, stim3 = prepareStim(ndotsStim1, ndotsTotal, radius)
    drawStim(stim1, stim2, 0, 0)
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s" %('100redSample',i,'.png')
    myWin.saveMovieFrames(n)

    drawStim(stim1, stim2, 0, 0,'red')
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s" %('100redTest',i,'.png')
    myWin.saveMovieFrames(n)
    
    
    stim1, stim2, stim3 = prepareStim(ndotsStim1, ndotsTotal, radius)
    drawStim(stim1, stim2, 0, 0)
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s%s" %(np,'blueSample',i,'.png')
    myWin.saveMovieFrames(n)
    
    drawStim(stim1, stim3, 0, 0,'blue')
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s%s" %(np,'blueTest',i,'.png')
    myWin.saveMovieFrames(n)

    stim1, stim2, stim3 = prepareStim(ndotsStim1, ndotsTotal, radius)
    drawStim(stim1, stim2, 0, 0)
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s" %('100blueSample',i,'.png')
    myWin.saveMovieFrames(n)
    
    drawStim(stim1, stim2, 0, 0,'blue')
    myWin.flip()
    myWin.getMovieFrame()
    n= "%s%s%s" %('100blueTest',i,'.png')
    myWin.saveMovieFrames(n)

myWin.close()
core.quit()
