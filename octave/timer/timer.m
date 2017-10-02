classdef timer
% TIMER - Class wrapper around the timer_ functions
  properties
    TimerID
    Period
    ExecutionMode
    TimerFcn
  end
  methods
    function self = timer(varargin)
      kv = getopt('TimerFcn=[] ExecutionMode=''SingleShot'' Period=1', ...
	  varargin);
      if startswith('singleshot', tolower(kv.executionmode))
	mode = 1;
      elseif startswith('fixedrate', tolower(kv.executionmode))
	mode = 0;
      else
	error('Illegal execution mode');
      end
      
      self.TimerID = timer_new(kv.period, mode, kv.timerfcn);
    end

    function fcn = get.TimerFcn(self)
      fcn = timer_getfunction(self.TimerID);
    end

    function set.TimerFcn(self, fcn)
      timer_setfunction(self.TimerID, fcn)
    end
    
    function set.Period(self, per)
      timer_settimeout(self.TimerID, per)
    end

    function per = get.Period(self)
      per = timer_gettimeout(self.TimerID)
    end

    function md = get.ExecutionMode(self)
      switch timer_getmode(self.TimerID)
	case 0
	  md = 'FixedRate';
	case 1
	  md = 'SingleShot';
	otherwise
	  error('Illegal execution mode');
      end
    end

    function set.ExecutionMode(self, md)
      if startswith('singleshot', tolower(md))
	mode = 1;
      elseif startswith('fixedrate', tolower(md))
	mode = 0;
      else
	error('Illegal execution mode');
      end
      
      timer_setmode(self.TimerID, mode)
    end

    function x = isRunning(self)
      x = timer_isrunning(self.TimerID);
    end

    function start(self)
      timer_start(self.TimerID)
    end
    
    function stop(self)
      timer_stop(self.TimerID)
    end
    
    function delete(self)
      % This is not actually called in Octave 4.0.0. Hmm.
      printf('Deleting timer %i\n', self.TimerID);
      try
        timer_kill(self.TimerID)
      catch
        fprintf(2, 'timer_kill failed on %i\n', self.TimerID);
      end
    end
  end
end

	