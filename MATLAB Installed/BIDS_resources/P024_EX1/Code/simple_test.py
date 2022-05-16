import gazepoint

import time


import gazepoint

gp3 = gazepoint.EyeTracker()



print gp3.isConnected()
gp3.setRecordingState(True)

time.sleep(5)

gp3.setRecordingState(False)


time.sleep(5)

gp3.close()