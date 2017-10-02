function b = pbox(varargin)
% PBOX  Construct a box with partially specified coordinates.
%    b = PBOX(key1,val1,...) augments the structure B with positioning 
%    constraints.
%    For example, b = pbox('left',10,'right',30,'top',40,'height',80);
%    Available KEYS are: 
%      left, right, width, center, 
%      bottom, top, height, middle.
%    b = PBOX(b,key1,val1,...) augments an existing box.
%    If all is well, output structure will have xstate==0 and ystate==0.
%    If there are too few values set (underdefined), *state=-1.
%    If there are too many values set (overdefined), *state=+1.

if isstruct(varargin{1})
  b = varargin{1};
  N=2;
else
  b = struct('left',[],'right',[],'width',[],'center',[],...
      'bottom',[],'top',[],'height',[],'middle',[]);
  N=1;
end
kv = getopt('left right width center bottom top height middle',...
    varargin{N:end});

% Copy new values in
if ~isempty(kv.left)
  b.left = kv.left;
end
if ~isempty(kv.right)
  b.right = kv.right;
end
if ~isempty(kv.center)
  b.center = kv.center;
end
if ~isempty(kv.width)
  b.width = kv.width;
end
if ~isempty(kv.bottom)
  b.bottom = kv.bottom;
end
if ~isempty(kv.top)
  b.top = kv.top;
end
if ~isempty(kv.height)
  b.height = kv.height;
end
if ~isempty(kv.middle)
  b.middle = kv.middle;
end

% Calculate missing x values
b.xstate = 0;
if isempty(b.left)
  if isempty(b.right)
    if isempty(b.width)
      b.xstate = -1;
    else
      if isempty(b.center)
	b.xstate = -1;
      else
	b.right = b.center + b.width/2;
	b.left = b.center - b.width/2;
      end
    end
  else
    if isempty(b.width)
      if isempty(b.center)
	b.xstate = -1;
      else
	b.width = (b.right - b.center) / 2;
	b.left = b.right - b.width;
      end
    else
      if isempty(b.center)
	b.left = b.right - b.width;
	b.center = b.left + b.width/2;
      else
	b.xstate = 1;
      end
    end
  end
else
  if isempty(b.right)
    if isempty(b.width)
      if isempty(b.center)
	b.xstate = -1;
      else
	b.width = (b.center - b.left) / 2;
	b.right = b.left + b.width;
      end
    else
      if isempty(b.center)
	b.right = b.left + b.width;
	b.center = b.left + b.width/2;
      else
	b.xstate = 1;
      end
    end
  else
    if isempty(b.width)
      if isempty(b.center)
	b.width = b.right - b.left;
	b.center = b.left + b.width/2;
      else
	b.xstate = 1;
      end
    else
      b.xstate = 1;
    end
  end
end

% Calculate missing y values
b.ystate = 0;
if isempty(b.bottom)
  if isempty(b.top)
    if isempty(b.height)
      b.ystate = -1;
    else
      if isempty(b.middle)
	b.ystate = -1;
      else
	b.top = b.middle + b.height/2;
	b.bottom = b.middle - b.height/2;
      end
    end
  else
    if isempty(b.height)
      if isempty(b.middle)
	b.ystate = -1;
      else
	b.height = (b.top - b.middle) / 2;
	b.bottom = b.top - b.height;
      end
    else
      if isempty(b.middle)
	b.bottom = b.top - b.height;
	b.middle = b.bottom + b.height/2;
      else
	b.ystate = 1;
      end
    end
  end
else
  if isempty(b.top)
    if isempty(b.height)
      if isempty(b.middle)
	b.ystate = -1;
      else
	b.height = (b.middle - b.bottom) / 2;
	b.top = b.bottom + b.height;
      end
    else
      if isempty(b.middle)
	b.top = b.bottom + b.height;
	b.middle = b.bottom + b.height/2;
      else
	b.ystate = 1;
      end
    end
  else
    if isempty(b.height)
      if isempty(b.middle)
	b.height = b.top - b.bottom;
	b.middle = b.bottom + b.width/2;
      else
	b.ystate = 1;
      end
    else
      b.ystate = 1;
    end
  end
end

if b.xstate>=0 & b.ystate>=0
  b.xywh = [b.left b.bottom b.width b.height]; % e.g. for 'position' property.
  b.lrbt = [b.left b.right b.bottom b.top]; % e.g. for AXIS.
end
