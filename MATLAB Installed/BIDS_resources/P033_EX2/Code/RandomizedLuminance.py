# Solid Poly Randomized Luminance Adam
from numpy import * #many different maths functions
from numpy.random import * #maths randomisation functions
import os #handy system and path functions
from psychopy import visual,core, data, event, gui,sound, parallel
from pyglet.gl import * #a graphic library
import math


parallel.PParallelInpOut32
parallel.setPortAddress(address=0xE010)
parallel.setData(0)
fixationSize = 10
expName='Solid Poly Randomized Luminance'#from the Builder filename that created this script
expInfo={'participant':'','responseScreenVersion':''}
dlg=gui.DlgFromDict(dictionary=expInfo,title=expName)
if dlg.OK==False: core.quit() #user pressed cancel
expInfo['date']=data.getDateStr()#add a simple timestamp
expInfo['expName']=expName
filename= 'dataRandomizedLuminance/%s_%s_%s' %(expInfo['participant'], expInfo['date'],expInfo['responseScreenVersion'])
if not os.path.isdir('dataRandomizedLuminance'):
    os.makedirs('dataRandomizedLuminance')#if this fails (e.g. permissions) we will get error  

backgroundColor = [0.071,0.071,0.071]

myWin = visual.Window(size = [1920,1080], allowGUI=False, monitor = 'EEG lab participant LCD', units = 'pix', fullscr= True, color=backgroundColor) # change for new monitor
s = visual.ImageStim(myWin, mask=None, pos=(0.0, 0.0), ori=0.0, color=(1.0, 1.0, 1.0), colorSpace='rgb', contrast=1.0, opacity=1.0, depth=0, interpolate=True, flipHoriz=False, flipVert=False, texRes=128, name=None, autoLog=None, maskParams=None)
responseScreen=visual.TextStim(myWin, ori=0, pos=[0, 0], height=30, color='blue', colorSpace='rgb', units= 'pix')
fixation1 = visual.Line(myWin, start=(-0, -fixationSize/2), end=(0, fixationSize/2),lineColor = 'blue')
fixation2 = visual.Line(myWin, start=(-fixationSize/2, 0), end=(fixationSize/2, 0),lineColor = 'blue')
myClock = core.Clock()


totalTrials = 256
blockDuration = 16



duration = 1.5
 #Dry run Debug
#baselineDuration = 0.1
#duration = 0.1


def message(Type, nBlocksToGo = 1):
    
    if Type == 'HelloPractice':
        message = ('Welcome to the Practice Experiment. You will see LOTS of patterns. Your task is to classify them as black or white')
    elif Type == 'HelloMain':
        message = ('Now for the real thing, its the same, but much longer. Try not to blink, and keep your eyes on the central fixation point')
    elif Type == 'Goodbye':
        message = ('Thank you for taking part in the Experiment')
    elif Type == 'Break':
        message = '%d Blocks to go: Wait for experimenter to check electrodes!' %nBlocksToGo
    Instructions=visual.TextStim(myWin, ori=0, text=message, pos=[0, 0], height=30, color='white', colorSpace='rgb', units= 'pix')
    Instructions.draw()
    myWin.flip()
    



def pictureShuffle(n,regType,firstImage):
    iList = [] # It is essential to have 0 in this box to begin with
    for r in range(n):
        p = '%.0f' %(r+firstImage)
        n= "%s%s%s" %(regType,p,'.png')
        iList.append(n)
    #print iList
    shuffle(iList)
    #print iList
    return iList 
    
#    
#a = pictureShuffle(20,'REF')
#b = a[19]
#print b
#core.quit()

def responseCollectCol(Color,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('Black          White')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'black'
            if Color == 'Black':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'white'
            if Color == 'White':
                respCorr = 1
                
                
    elif responseScreenVersion == 2:
        responseScreen.setText('White          Black')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'white'
            if Color == 'White':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'black'
            if Color == 'Black':
                respCorr = 1
    return respCorr, choice

def responseCollectReg(Reg,responseScreenVersion):
    event.clearEvents()
    respCorr = 0# this stops the participants hacking through by pressing both a and l at the same time
    choice = 'na'
    if responseScreenVersion == 1:
        responseScreen.setText('Random          Symmetry')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a','l']) 
        if responseKey == ['a']:
            choice = 'random'
            if Reg == 'Rand':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'symmetry'
            if Reg == 'Ref':
                respCorr = 1
                
                
    elif responseScreenVersion == 2:
        responseScreen.setText('Symmetry          Random')
        responseScreen.draw()
        myWin.flip()
        responseKey = event.waitKeys(keyList=['a', 'l']) 
        if responseKey == ['a']:
            choice = 'symmetry'
            if Reg == 'Ref':
                respCorr = 1
        elif responseKey == ['l']:
            choice = 'random'
            if Reg == 'Random':
                respCorr = 1
    return respCorr, choice

def runBlock(trialbook,Reps,blockDuration,nBlocksToGo):
    parallel.setData(107) # One data set identifier right at the start in case we need to do some emergency back check
    core.wait(0.01)
    parallel.setData(0)
    firstImage = 1
    nImages = 32 # can use first half of the images in folders for the randomized block, or vice versa. 
    
    RandBlack00List = pictureShuffle(nImages,'RandBlack00/TCRandBlack00',firstImage)  
    RandWhite00List = pictureShuffle(nImages,'RandWhite00/TCRandWhite00',firstImage)  
    RefBlack00List = pictureShuffle(nImages,'RefBlack00/TCRefBlack00',firstImage)  # this is a shuffled list of Reflection image names
    RefWhite00List = pictureShuffle( nImages,'RefWhite00/TCRefWhite00',firstImage)    
    
    firstImage = 1
    nImages = 8
    RandBlackl60u15List = pictureShuffle(nImages,'RandBlack6015/TCRandBlack6015',firstImage)  
    RandWhitel60u15List = pictureShuffle(nImages,'RandWhite6015/TCRandWhite6015',firstImage)  
    RefBlackl60u15List = pictureShuffle(nImages,'RefBlack6015/TCRefBlack6015',firstImage)  
    RefWhitel60u15List = pictureShuffle(nImages,'RefWhite6015/TCRefWhite6015',firstImage) 

    RandBlackl60d15List = pictureShuffle(nImages,'RandBlack60-15/TCRandBlack60-15',firstImage)  
    RandWhitel60d15List = pictureShuffle(nImages,'RandWhite60-15/TCRandWhite60-15',firstImage)  
    RefBlackl60d15List = pictureShuffle(nImages,'RefBlack60-15/TCRefBlack60-15',firstImage)  
    RefWhitel60d15List = pictureShuffle(nImages,'RefWhite60-15/TCRefWhite60-15',firstImage)  

    RandBlackr60u15List = pictureShuffle(nImages,'RandBlack-6015/TCRandBlack-6015',firstImage)  
    RandWhiter60u15List = pictureShuffle(nImages,'RandWhite-6015/TCRandWhite-6015',firstImage)  
    RefBlackr60u15List = pictureShuffle(nImages,'RefBlack-6015/TCRefBlack-6015',firstImage)  
    RefWhiter60u15List = pictureShuffle(nImages,'RefWhite-6015/TCRefWhite-6015',firstImage) 

    RandBlackr60d15List = pictureShuffle(nImages,'RandBlack-60-15/TCRandBlack-60-15',firstImage)  
    RandWhiter60d15List = pictureShuffle(nImages,'RandWhite-60-15/TCRandWhite-60-15',firstImage)  
    RefBlackr60d15List = pictureShuffle(nImages,'RefBlack-60-15/TCRefBlack-60-15',firstImage)  
    RefWhiter60d15List = pictureShuffle(nImages,'RefWhite-60-15/TCRefWhite-60-15',firstImage)  


    RandBlack00Counter = -1
    RandWhite00Counter = -1
    RefBlack00Counter = -1
    RefWhite00Counter = -1
    
    RandBlackl60u15Counter = -1
    RandWhitel60u15Counter = -1
    RefBlackl60u15Counter = -1
    RefWhitel60u15Counter = -1

    RandBlackl60d15Counter = -1
    RandWhitel60d15Counter = -1
    RefBlackl60d15Counter = -1
    RefWhitel60d15Counter = -1

    RandBlackr60u15Counter = -1
    RandWhiter60u15Counter = -1
    RefBlackr60u15Counter = -1
    RefWhiter60u15Counter = -1

    RandBlackr60d15Counter = -1
    RandWhiter60d15Counter = -1
    RefBlackr60d15Counter = -1
    RefWhiter60d15Counter = -1

    

    trialCounter = 0
    
    
 
   
    trials=data.TrialHandler(nReps=Reps, method='random', trialList=data.importConditions(trialbook))
    for thisTrial in trials:
        if thisTrial!=None:
            for paramName in thisTrial.keys():
                exec(paramName+'=thisTrial.'+paramName)
        
        if trialCounter == blockDuration:
                nBlocksToGo = nBlocksToGo - 1
                message('Break',nBlocksToGo = nBlocksToGo)
                event.waitKeys(keyList=['g'])
                trialCounter = 0
        trialCounter = trialCounter + 1
       
        
        fixation1.draw()
        fixation2.draw()
        w = myClock.getTime() + duration
        myWin.flip()
    
    
        Stim= "%s%s%s%s" %(Reg,Color,viewAngleX,viewAngleY)
        i = 'crashit'
        if Stim == 'RandBlack00':
            RandBlack00Counter = RandBlack00Counter+1
            i =  RandBlack00List[RandBlack00Counter]
        elif Stim == 'RandWhite00':
            RandWhite00Counter = RandWhite00Counter+1
            i =  RandWhite00List[RandWhite00Counter]
        elif Stim == 'RefBlack00':
            RefBlack00Counter = RefBlack00Counter+1
            i =  RefBlack00List[RefBlack00Counter]
        elif Stim == 'RefWhite00':
            RefWhite00Counter = RefWhite00Counter+1
            i =  RefWhite00List[RefWhite00Counter]

        elif Stim == 'RandBlack6015':
            RandBlackl60u15Counter = RandBlackl60u15Counter+1
            i =  RandBlackl60u15List[RandBlackl60u15Counter]
        elif Stim == 'RandWhite6015':
            RandWhitel60u15Counter = RandWhitel60u15Counter+1
            i =  RandWhitel60u15List[RandWhitel60u15Counter]
        elif Stim == 'RefBlack6015':
            RefBlackl60u15Counter = RefBlackl60u15Counter+1
            i =  RefBlackl60u15List[RefBlackl60u15Counter]
        elif Stim == 'RefWhite6015':
            RefWhitel60u15Counter = RefWhitel60u15Counter+1
            i =  RefWhitel60u15List[RefWhitel60u15Counter]

        if Stim == 'RandBlack60-15':
            RandBlackl60d15Counter = RandBlackl60d15Counter+1
            i =  RandBlackl60d15List[RandBlackl60d15Counter]
        elif Stim == 'RandWhite60-15':
            RandWhitel60d15Counter = RandWhitel60d15Counter+1
            i =  RandWhitel60d15List[RandWhitel60d15Counter]
        elif Stim == 'RefBlack60-15':
            RefBlackl60d15Counter = RefBlackl60d15Counter+1
            i =  RefBlackl60d15List[RefBlackl60d15Counter]
        elif Stim == 'RefWhite60-15':
            RefWhitel60d15Counter = RefWhitel60d15Counter+1
            i =  RefWhitel60d15List[RefWhitel60d15Counter]

        elif Stim == 'RandBlack-6015':
            RandBlackr60u15Counter = RandBlackr60u15Counter+1
            i =  RandBlackr60u15List[RandBlackr60u15Counter]
        elif Stim == 'RandWhite-6015':
            RandWhiter60u15Counter = RandWhiter60u15Counter+1
            i =  RandWhiter60u15List[RandWhiter60u15Counter]
        elif Stim == 'RefBlack-6015':
            RefBlackr60u15Counter = RefBlackr60u15Counter+1
            i =  RefBlackr60u15List[RefBlackr60u15Counter]
        elif Stim == 'RefWhite-6015':
            RefWhiter60u15Counter = RefWhiter60u15Counter+1
            i =  RefWhiter60u15List[RefWhiter60u15Counter]
        
        elif Stim == 'RandBlack-60-15':
            RandBlackr60d15Counter = RandBlackr60d15Counter+1
            i =  RandBlackr60d15List[RandBlackr60d15Counter]
        elif Stim == 'RandWhite-60-15':
            RandWhiter60d15Counter = RandWhiter60d15Counter+1
            i =  RandWhiter60d15List[RandWhiter60d15Counter]
        elif Stim == 'RefBlack-60-15':
            RefBlackr60d15Counter = RefBlackr60d15Counter+1
            i =  RefBlackr60d15List[RefBlackr60d15Counter]
        elif Stim == 'RefWhite-60-15':
            RefWhiter60d15Counter = RefWhiter60d15Counter+1
            i =  RefWhiter60d15List[RefWhiter60d15Counter]
            
        s.setImage(i)
        s.draw()
        fixation1.draw()
        fixation2.draw()
        while myClock.getTime() < w:
            pass
        
 
        w = myClock.getTime() + duration
        myWin.flip() 
        parallel.setData(trigger) # THIS IS Better after the win flip
        core.wait(0.01)
        parallel.setData(0)
        while myClock.getTime() < w:
            if event.getKeys(["escape"]): 
                core.quit()
                event.clearEvents()
                myWin.close
        
        
        respCorr, choice = responseCollectCol(Color, responseScreenVersion)
#        
#        # Dry run
#        respCorr = 0
#        choice = 0
#       
        trials.addData('image',i)
#        

#        trials.addData('RandBlack00Counter',RandBlack00Counter)
#        trials.addData('RandWhite00Counter',RandWhite00Counter)
#        trials.addData('RefBlack00Counter',RefBlack00Counter)
#        trials.addData('RefWhite00Counter',RefWhite00Counter)
#        
#        trials.addData('RandBlackl60u15Counter',RandBlackl60u15Counter)
#        trials.addData('RandWhitel60u15Counter',RandWhitel60u15Counter)
#        trials.addData('RefBlackl60u15Counter',RefBlackl60u15Counter)
#        trials.addData('RefWhitel60u15Counter',RefWhitel60u15Counter)
#
#        trials.addData('RandBlackl60d15Counter',RandBlackl60d15Counter)
#        trials.addData('RandWhitel60d15Counter',RandWhitel60d15Counter)
#        trials.addData('RefBlackl60d15Counter',RefBlackl60d15Counter)
#        trials.addData('RefWhitel60d15Counter',RefWhitel60d15Counter)
#
#        trials.addData('RandBlackr60u15Counter',RandBlackr60u15Counter)
#        trials.addData('RandWhiter60u15Counter',RandWhiter60u15Counter)
#        trials.addData('RefBlackr60u15Counter',RefBlackr60u15Counter)
#        trials.addData('RefWhiter60u15Counter',RefWhiter60u15Counter)
#        
#        trials.addData('RandBlackr60d15Counter',RandBlackr60d15Counter)
#        trials.addData('RandWhiter60d15Counter',RandWhiter60d15Counter)
#        trials.addData('RefBlackr60d15Counter',RefBlackr60d15Counter)
#        trials.addData('RefWhiter60d15Counter',RefWhiter60d15Counter)
        
        trials.addData('respCorr',respCorr)
        trials.addData('choice',choice)
    trials.saveAsExcel(filename+'.xlsx', sheetName= 'trials', dataOut=['all_raw'])


if expInfo['responseScreenVersion'] == '1':
    responseScreenVersion = 1
elif expInfo['responseScreenVersion'] == '2':
    responseScreenVersion = 2
else:
    myWin.close()
    core.quit()
    
message('HelloPractice')
event.waitKeys(keyList = ['g'])
runBlock('trialbook.xlsx',1,16,2)
message('HelloMain')
event.waitKeys(keyList = ['g'])
nBlocksToGo = totalTrials/blockDuration
runBlock('trialbook.xlsx',8,blockDuration,nBlocksToGo) # 8 blocks of 32 trials
message('Goodbye')
core.wait(2)
myWin.close()
core.quit()
