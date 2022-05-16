import socket, time

class EyeTracker:
    '''
    class for implementing gp3 eyetracking into psychopy
    
    
    '''
    _recording=False
    __slots__=['_gp3','_rx_buffer']
    def __init__(self):
        self._gp3 = None
        self._rx_buffer=''
        self.setConnectionState(True)


    def setConnectionState(self, enable):
        """
        Connects or disconnects from the GP3 eye tracking hardware.
        type bool: indicates the current connection state to the eye tracking hardware.
        """
        if enable is True and self._gp3 is None:
            try:
                self._rx_buffer=''
                self._gp3 = socket.socket()
                address = ('127.0.0.1',4242)
                self._gp3.settimeout(10)
                self._gp3.connect(address)
                self._gp3.setblocking(False)
                init_connection_str='<SET ID="ENABLE_SEND_CURSOR" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_POG_LEFT" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_POG_RIGHT" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_USER_DATA" STATE="1"/>\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_PUPIL_LEFT" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_PUPIL_RIGHT" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_POG_FIX" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_POG_BEST" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_DATA" STATE="0" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_COUNTER" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_TIME" STATE="1" />\r\n'
                init_connection_str+='<SET ID="ENABLE_SEND_TIME_TICK" STATE="1" />\r\n'
                self._gp3.sendall(str.encode(init_connection_str))
                # block for upp to 1 second to get reply txt.
                strStatus = self._checkForNetData(1.0)
                if strStatus:
                    self._rx_buffer = ''
                    return True
                else:
                    return False

            except socket.error as e:
                if e.args[0]==10061:
                    print('***** Socket Error: Check Gazepoint control software is running *****')
                print('Error connecting to GP3 ', e)
        elif enable is False and self._gp3:
            try:
                if self._gp3:
                    self.setRecordingState(False)
                self._gp3.close()
                self._gp3 = None
                self._rx_buffer=''
            except:
                print('Problem disconnecting from device - GP3')
                self._rx_buffer=''
        return self.isConnected()
    def isConnected(self):
        """
        isConnected returns whether the GP3 is connected to the experiment PC
        and if the tracker state is valid. Returns True if the tracker can be 
        put into Record mode, etc and False if there is an error with the tracker
        or tracker connection with the experiment PC.

        Args:
            None
            
        Return:
            bool:  True = the eye tracking hardware is connected. False otherwise.

        """
        return self._gp3 is not None


    def sendMessage(self, message_contents):
        """
        The sendMessage method sends the message_contents str to the GP3.
        """
        try:
            if self._gp3 and self.isRecordingEnabled() is True:
                strMessage='<SET ID="USER_DATA" VALUE="{0}"/>\r\n'.format(message_contents)
                self._gp3.sendall(strMessage)
        except:
            print('Problems sending message: {0}'.FORMAT(message_contents))
        return True
    
    def getData(self):
        myDict = dict()
        x = self._gp3.recv(4096)
        if x:
            try:
                dataString = x[x.find('<')+1:x.find('/>')].strip()
                dataList = dataString.split()
                myDict['type'] = dataList[0]
                for field in dataList[1:]:
                    tkey, tval = field.split('=')
                    try:
                        myDict[tkey] = float(tval.strip('"'))
                    except:
                        myDict[tkey] = tval
                if myDict['type'] == 'REC':        
                    return myDict
                elif myDict['type'] == 'ACK':
                    print myDict
            except Exception as e:
                print 'incomplete data string: {0}'.format(e)
                


    def _checkForNetData(self, timeout = 0):
        self._gp3.settimeout(timeout)
        while True:
            try:
                rxdat = self._gp3.recv(4096)
                if rxdat:
                    self._rx_buffer += bytes.decode(rxdat).replace('\r\n','')
                    return self._rx_buffer
                else:
                    print('***** GP3 Closed Connection *****')
                    # Connection closed
                    self.setRecordingState(False)
                    self.setConnectionState(False)
                    self._rx_buffer=''
                    return None

            except socket.error, e:
                err = e.args[0]
                if err == errno.EAGAIN or err == errno.EWOULDBLOCK or err == 'timed out':
                    # non blocking socket found no data; it happens.
                    return self._rx_buffer
                else:
                    # a valid error occurred
                    print('***** _checkForNetData Error *****')
                    return self._rx_buffer
    def setRecordingState(self,recording):
        """
        setRecordingState is used to start or stop the recording of data from 
        the eye tracking device.
        
        args:
           recording (bool): if True, the eye tracker will start recordng available
              eye data and sending it to the experiment program if data streaming
              was enabled for the device. If recording == False, then the eye
              tracker stops recording eye data and streaming it to the experiment.
              
        If the eye tracker is already recording, and setRecordingState(True) is
        called, the eye tracker will simple continue recording and the method call
        is a no-op. Likewise if the system has already stopped recording and 
        setRecordingState(False) is called again.

        Args:
            recording (bool): if True, the eye tracker will start recordng data.; false = stop recording data.
           
        Return:trackerTime
            bool: the current recording state of the eye tracking device
        """
        current_state = self.isRecordingEnabled()
        if self._gp3 and recording is True and current_state is False:
            self._rx_buffer=''
            self._gp3.sendall(str.encode('<SET ID="ENABLE_SEND_DATA" STATE="1" />\r\n'))
            rxdat = self._checkForNetData(1.0)
            if rxdat is None:
                EyeTracker._recording=False
                return EyeTrackerDevice.enableEventReporting(self, False)
            EyeTracker._recording=True
        elif self._gp3 and recording is False and current_state is True:
            self._rx_buffer=''
            self._gp3.sendall(str.encode('<SET ID="ENABLE_SEND_DATA" STATE="0" />\r\n'))
            rxdat = self._checkForNetData(1.0)
            EyeTracker._recording=False
            #self._latest_sample=None
            #self._latest_gaze_position=None
        #return EyeTrackerDevice.enableEventReporting(self, recording)

    def isRecordingEnabled(self):
        """
        isRecordingEnabled returns the recording state from the eye tracking 
        device.

        Args:
           None
  
        Return:
            bool: True == the device is recording data; False == Recording is not occurring
        """
        if self._gp3:
            return self._recording
        return False
        
    def close(self):
        if self._gp3:
            try:
                self._gp3.close()
            except Exception as e:
                print 'problem closing connection: {}'.format(e)
        else:
            print 'not a valid object passed'
