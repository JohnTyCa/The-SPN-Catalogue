from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import core, data, event, visual, sound, gui, parallel
from pyglet.gl import * #a graphic library
import math
import OpenGL.GL, OpenGL.GL.ARB.multitexture, OpenGL.GLU
from OpenGL import GLUT


size=32
sizedot =16
ndots =10
stimDuration = 2 
screenWidth = 600
screenHeight = 600
blockDuration = 36 
baselineMin = 1.5
baselineMax = 2.0
practice = 1

parallel.setData(0)

#store info about the experiment
expName='PracticeCongruenceEEG'#from the Builder filename that created this script
expInfo={'participant':'', 'session':001,'order':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)


if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'data/%s_%s_order%s' %(expInfo['participant'], expInfo['date'],expInfo['order'])

if not os.path.isdir('data'):
    os.makedirs('data')#if this fails (e.g. permissions) we will get error  


myWin = visual.Window(allowGUI=False, size=[screenWidth,screenHeight], units='pix', fullscr= True)
def chooseTrialbook(choice, practice):
    global trialbook
    if choice == '1':
        if practice == 1:
            trialbook = 'Practicet1.xlsx'
        else:
            trialbook = 't1.xlsx'
    elif choice == '2':
        if practice == 1:
            trialbook = 'Practicet2.xlsx'
        else:
            trialbook = 't2.xlsx'
    elif choice == '3':
        if practice == 1:
            trialbook = 'Practicet3.xlsx'
        else:
            trialbook = 't3.xlsx'
    elif choice== '4':
        if practice == 1:
            trialbook = 'Practicet4.xlsx'
        else:
            trialbook = 't4.xlsx'
    elif choice== '5':
        if practice == 1:
            trialbook = 'Practicet5.xlsx'
        else:
            trialbook = 't5.xlsx'
    elif choice== '6':
        if practice == 1:
            trialbook = 'Practicet6.xlsx'
        else:
            trialbook = 't6.xlsx'
    else:
        print 'error: order should be 1 to 6'
        core.quit()
def responseScreen(respScreenType,Valence,Regularity, warnOn):
    global respCorr
    squareSize = (size*ndots)
    square = visual.Rect(myWin, width =  squareSize, height = squareSize, fillColor = 'white')
    warn=visual.TextStim(myWin, text = 'WRONG', height=20, color='Red')
    square.draw()
    responseScreen1=visual.TextStim(myWin, ori=0, text='reflection           random', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
    responseScreen2=visual.TextStim(myWin, ori=0, text='random           reflection', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
    responseScreen3=visual.TextStim(myWin, ori=0, text='positive            negative', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
    responseScreen4=visual.TextStim(myWin, ori=0, text='negative            positive', pos=[0, 0], height=30, color='Black', colorSpace='rgb', units= 'pix')
    if respScreenType == 'RefRand':
        responseScreen1.draw()
        if Regularity == 'Reflection':
            correctKey =  'a' 
        elif Regularity == 'Random':
            correctKey = 'l'
    elif respScreenType == 'RandRef':
        responseScreen2.draw()  
        if Regularity == 'Reflection':
            correctKey = 'l'
        elif Regularity == 'Random':
            correctKey = 'a'
    elif respScreenType == 'PosNeg':
        responseScreen3.draw()
        if Valence == 'pos':
            correctKey = 'a'
        elif Valence == 'neg':
            correctKey = 'l'
    elif respScreenType == 'NegPos':
        responseScreen4.draw()
        if Valence == 'pos':
            correctKey = 'l'
        elif Valence == 'neg':
            correctKey = 'a'
    myWin.flip()
    responseKey = event.waitKeys(keyList=['a', 'l']) 
    respCorr =(correctKey==responseKey[0])
    if warnOn == 1:
        if respCorr == 0:
            
            square.draw()
            warn.draw()
            myWin.flip()
            core.wait(1)
            

        
def wordStim(word):
    drawRect(0,0,(sizedot*6),(sizedot))
    drawRect(0,0,(sizedot),(sizedot*6))
    word=visual.TextStim(myWin, text = word, height=30, color='White')
    word.draw()
    
def baseline():
    squareSize = (size*ndots)
    square = visual.Rect(myWin, width =  squareSize, height = squareSize, fillColor = 'white')
    square.draw()
    fixation=visual.TextStim(myWin, text='+', height=30, color='Black')
    fixation.draw()
    
    
def message(Type):
    if Type == 'HelloValence':
        message = ('Welcome to the Experiment. You will see LOTS of patterns with words on top. Your task is to classify the words as positive or negative. Press spacebar to start')
    elif Type == 'HelloRegularity':
        message = ('Welcome to the Experiment. You will see LOTS of patterns with words on top. Your task is to classify the patterns as reflection or random. Press spacebar to start')
    elif Type == 'HelloBoth':
        message = ('Welcome to the Experiment. You will see LOTS of patterns with words on top. Your task is to classify the patterns as reflection or random and to classfiy the words as positive or negative. You may be asked to report either Press spacebar to start')
    elif Type == 'Goodbye':
        message = ('End of practice')
    elif Type == 'Break':
        message = 'Break. Wait for experimenter to check electrodes!'
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
   
        
def drawRect(x, y, width, height, filled=True):
    
    if filled==True:
        glBegin(GL_POLYGON);
    else: 
        glBegin(GL_LINE_LOOP);

    glVertex2f(x -width, y -height)  # we use vertex2f since we are  working in 2d. 
    glVertex2f(x -width, y +height)
    glVertex2f(x +width, y +height)
    glVertex2f(x +width, y -height)
#glVertex2f(x -width/2., y -height/2.);
    glEnd();
    
def drawCircle(x, y, r, starting, ending, filled=True):
    step = 6.283/r   #the radius determines the step
    end_arc   =(ending * 3.1415)     # ending is the multiple of pi, starting on the right 
    start_arc =(starting * 3.1415)  # starting is the multiple of pi, starting on the right

    glPushMatrix()
    glTranslatef(x, y, 0)

    if filled==True:
        glBegin(GL_TRIANGLE_FAN)
    else:
        glBegin(GL_LINE_STRIP)

#    glVertex2i(0, 0);
    for i in arange(start_arc,end_arc,step):      #float i=start_arc; i<end_arc; i+=step)  
        glVertex2f(cos(i)*r, sin(i)*r)

    glEnd()
    glPopMatrix()

def drawItem(x,y,s):
    drawRect(x, y, s, s)
    #    drawCircle(x, y, s, 0., 2.)


def pattern_rot(angle):
    
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)
    m=array([memory[0:5],memory[5:10],memory[10:15],memory[15:20],memory[20:25]])

    glColor3f(1.,1.,1.)
    glRecti(-(size*7),-(size*7),size*7,size*7)
    
    i=j=0
#    glColor3f(1.,0.,0.)
    glColor3f(1.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    i=j=0
    glRotatef(angle , 0., 0., 1. )
    glColor3f(0.,1.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    i=j=0
    glRotatef(angle , 0., 0., 1. )
    glColor3f(0.,0.,1.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    i=j=0
    glRotatef(angle , 0., 0., 1. )
    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1

    i=j=0
    glRotatef(angle , 0., 0., 1. )
    glColor3f(0.4,0.4,0.4)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1



def pattern_hv():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)

    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    
    i=0
    
    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
    #        if randint(1, 3)==1:
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
    i=0
#    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1
            
    memory.reverse()
    i=0
    #glColor3f(0.,0.,0)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    i=0
    #glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1



def pattern_cc():
    
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)
    m=array([memory[0:5],memory[5:10],memory[10:15],memory[15:20],memory[20:25]])

    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    i=j=0
#    glColor3f(1.,0.,0.)
    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(m[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    n=rot90(m)
    i=j=0
#    glColor3f(0.,1.,0.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(n[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    i=j=0
    nn=rot90(n)
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(-(size*5), 0, size):
            if(nn[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
    
    i=j=0
    nnn=rot90(nn)
#    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
            if(nnn[i,j] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
        i=0
        j=j+1
                    

    
def pattern_c():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)

    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    i=0
    
    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
    memory.reverse()
    i=0
#    glColor3f(0.,1.,0.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    shuffle(memory)
    i=0
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    memory.reverse()
    i=0
#    glColor3f(0.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    

def pattern_h():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)
    
    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    i=0

    glColor3f(0.,0.,0.)
#    glColor3f(1.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
    i=0
#    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                        drawItem(x-size/2, y+size/2, sizedot)
            i=i+1
    
    shuffle(memory)
    i=0
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    i=0
#    glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1    
            


def pattern_v():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    shuffle(memory)

    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    i=0

    glColor3f(0.,0.,0.)
#    glColor3f(1.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
            
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
    i=0
#    glColor3f(0.,1.,0.)
    for x in range(-(size*5), 0, size):
        for y in range((size*5), 0, -size):
            if(memory[i] ==1):
                        drawItem(x+size/2, y-size/2, sizedot)
            i=i+1
    
    shuffle(memory)
    
    i=0
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
    i=0
#    glColor3f(0.,0.,0.)
    for x in range(0,(size*5), size):
        for y in range(0,-(size*5), -size):
            if(memory[i] ==1):
                        drawItem(x+size/2, y-size/2, sizedot)
            i=i+1
            
 

def pattern_a():
    a=[0]
    b=[1]
    memory =(a*(25-ndots))+(b*ndots)      # 25 cells of which 8 are black
    memory =(a*(100-ndots*4)+(b*ndots*4))
    shuffle(memory)
    
    glColor3f(1.,1.,1.)
    glRecti(-(size*5),-(size*5),size*5,size*5)
    
    i=0

    glColor3f(0.,0.,0.)
#    glColor3f(1.,0.,0.)
    for x in range(-(size*5), 0, size):
        for y in range(-(size*5), 0, size):
    #        if randint(1, 3)==1:
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
                    
#    glColor3f(0.,1.,0.)
    for x in range((size*5), 0, -size):
        for y in range(-(size*5), 0, size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1
            
#    glColor3f(0.,0.,1.)
    for x in range(0, (size*5), size):
        for y in range(0,(size*5), size):        
            if(memory[i] ==1):
                    drawItem(x+size/2, y+size/2, sizedot)
            i=i+1
    
#    glColor3f(0.,0.,0.)
    for x in range(0,-(size*5), -size):
        for y in range(0,(size*5), size):
            if(memory[i] ==1):
                    drawItem(x-size/2, y+size/2, sizedot)
            i=i+1




def runBlock():
    trialCounterOne = 0
    trialCounterTwo = 0
    myClock = core.Clock()
    chooseTrialbook(expInfo['order'],practice)
    trials=data.TrialHandler(nReps=1, method='random', trialList=data.importConditions(trialbook))
    
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        trialCounterOne = trialCounterOne + 1
        trialCounterTwo = trialCounterTwo + 1
        if trialCounterOne > blockDuration:
                message('Break')
                event.waitKeys(keyList=['g'])
                trialCounterOne = 0
        baseline()
        myWin.flip()
        ITI = uniform(baselineMin,baselineMax)
        core.wait(ITI)
        seed(expInfo['session']*seedNo)
        myWin.setScale(units='pix')
        if Regularity== 'Reflection':
            pattern_hv()
            wordStim(Word)
        elif Regularity == 'Random':
            pattern_a()
            wordStim(Word)
        t = myClock.getTime() + stimDuration
        parallel.setData(Trigger)
        myWin.flip()
        parallel.setData(0)
        while myClock.getTime() < t:
            if event.getKeys(["escape"]): 
                    core.quit()
                    event.clearEvents()
                    myWin.close
        
        responseScreen(respScreenType,Valence,Regularity,1)# 1 means warning word on
        trials.addData('respCorr', respCorr)


    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials',
        #stimOut=['Trigger','Regularity','Word','correctKey'],
        dataOut=['all_raw'])


if expInfo['order'] in ('1','2'):
    message('HelloBoth')
elif expInfo['order'] in ('3','4'):
    message('HelloValence')
elif expInfo['order'] in ('5','6'):
     message('HelloRegularity')
event.waitKeys('Space')
runBlock()
message('Goodbye')
core.wait(2)
myWin.close
