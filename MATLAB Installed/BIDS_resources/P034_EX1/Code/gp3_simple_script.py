#test gazepoint

import gazepoint
import time


filename = 'test_file.csv'



measures = ['type', 'CNT','FPOGID','FPOGX', 'FPOGY', 'FPOGV','USER', 'TIME']

header = 'type,CNT,FPOGID,FPOGX,FPOGY,FPOGV,USER,TIME'

# Connect to Eyetracker#
gp3 = gazepoint.EyeTracker()
print 'Is eyetracker online? {0}\n\n'.format(gp3.isConnected())

# Not recording yet, should return False
print 'Is GP3 set to recording state? {0}'.format(gp3.isRecordingEnabled())

data = ''
d = ''

for trial in range(3):
    t1 = time.time()
    t2 = time.time()
    #
    gp3.setRecordingState(True)
    # Should be recording andreturn True
    print 'Is GP3 set to recording state? {0}'.format(gp3.isRecordingEnabled())
    #
    #
    #
    # Send a message to the GP3 Eyetracker 
    gp3.sendMessage(trial)
    while t2-t1 < 3.0:
        current_data = gp3.getData()
        if current_data:
            for i in measures:
                if d == '':
                    d = current_data[i]
                else:
                    d = '{0},{1}'.format(d, current_data[i])
            print '################## 1 Sample of data ##########################'
            print d
            print '##############################################################'
            if data == '':
                data = '{0}\n{1}'.format(header,d)
            else:
                data = '{0}\n{1}'.format(data,d)
            d=''
        t2 = time.time()
    gp3.setRecordingState(False)
    # Stopped recording, should return False
    print 'Is GP3 set to recording state? {0}'.format(gp3.isRecordingEnabled())
    time.sleep(1.0)


# Disconnect from GP3
gp3.setConnectionState(False)

# Should return False
print gp3.isConnected()


#save data
myFile = open(filename,'w')
myFile.write(data)
myFile.close()

print 'Bye!'

