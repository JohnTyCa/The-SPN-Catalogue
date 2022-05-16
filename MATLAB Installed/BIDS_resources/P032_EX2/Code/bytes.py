import sys
import codecs
#from makebytes import b
#
#if sys.version_info < (3,):
#    def b(x):
#        return x
#else:
#    import codecs
#    def b(x):
#        return codecs.latin_1_encode(x)[0]
#        
#b('GIF89a')

infile = codecs.open('UTF-8.txt', 'r', encoding='UTF-8')
print(infile.read())

import locale

locale.setlocale(locale.LC_ALL, 'sv_SE.UTF-8')


import time 

parmod = True 
try: 
    import parallel 
except: 
    parmod = False 


class MyParPort: 
    """Wrapper class around parallel.Parallel. It handles the case 
when no 
    parallel port is available and also provides an option for 
debugging. 

    Most importantly, it provides a mean to control the pulse width: 
the same 
    code is repeated on the line for the requested duration (default 
5ms), so as 
    to give a chance to the EEG device to catch it. The line is then 
cleared 
    with a zero (although I am not sure this is necessary). 
    """ 

    def __init__(self, debug=False): 
        '''If debug is set to True (default is False), the code 
written to the 
        parallel port is also written to the standard output.''' 
        if parmod: 
            try: 
                self.pport = parallel.Parallel() 
            except: 
                self.pport = None 
        else: 
            self.pport = None 

        self.dbg = debug 

    def setData(self, d, pulseWidth=0.005): 
        '''Writes d to the parallel port. If dgb is set to True, then 
also print 
        to stdout. Optional parameter pulseWidth (default value is 
0.005) 
        controls the duration for which to maintain the data on the 
line. 
        Maintaining it for a long duration gives a chance to the EEG 
device to 
        read it. The duration depends on the sampling rate. With a 
sampling rate 
        of 256 Hz, the period is 4ms, hence a pulse width of 5ms is 
the minimum. 
        Note that the pulse is maintained by a timed loop. 
        ''' 

        if self.pport is not None: 
            self.pport.setData(d) 
            t0 = time.time() 
            while time.time() < t0 + pulseWidth: 
                self.pport.setData(d) 
            self.pport.setData(0) 
        if self.dbg: print 'parallel port:', d 