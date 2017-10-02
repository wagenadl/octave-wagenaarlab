function savejson(object, fn, ind)
% SAVEJSON - Save a variable to JSON file
%    SAVEJSON(var, fn) saves the named variable as a JSON file.
%    Based on Daniel de Torre Herrera's OBJECT2JSON code, (C) 2010.


%% Copyright (C) 2010 Torre Herrera, Daniel de
%%
%% This program is free software; you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation; either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%% details.
%%
%% You should have received a copy of the GNU General Public License along with
%% this program; if not, see <http://www.gnu.org/licenses/>.

%% Returns a valid json string that will describe object; the string will
%% be in a compact form (no spaces or line breaks).
%%
%% It will map simple octave values this way:
%%   function handles: string with the name of the function
%%   double (numbers): depends:
%%     If it's real it will map to a string representing that number
%%     If it's complex it will map to an object with the next properties:
%%       real: real part of the number
%%       imag: imaginary part of the number
%%   char: A string enclosed by double quotes representing that character
%% And will map more complex octave values this other way:
%%   struct: an object with properties equal to the struct's field names
%%     and value equal to the json counterpart of that field
%%   cell: it will be mapped depending on the value of the cell (for
%%     example {i} will be mapped to an object with real=0 and imag=1)
%%   vectors or cell arrays: it will map them to a corresponding js
%%     array (same size) with the values transformed to their json
%%     counterpart (Note: that in javascript all arrays are like octave's
%%     cells ,i.e. they can store different type and size variables)
%%   strings or char vectors: they will be mapped to the same string
%%     enclosed by double quotes
%% Other octave values will be mapped to a string enclosed by double
%% quotes with the value that the class() function returns
%% It can handle escape sequences and special chars automatically.
%% If they're valid in JSON it will keep them if not they'll be
%% escaped so they can become valid

%% object2json.m
%% Created: 2010-12-06
%% Updates:
%% 2011-01-23 Added support for especial chars and escaped sequences
%% 2011-04-01 Fixed error: Column vectors not working correctly
%% 2011-09-08 (Philip Nienhuis) layout & style changes cf. Octave coding style

if ischar(fn)
  fd = fopen(fn, 'w');
else
  fd = fn;
end
if nargin<3
  ind='';
end

ind = [ ind ' ' ];

s = size (object);
if (all (s==1))
  % It's not a vector so we must check how to map it
  % Depending on the class of the object we must do one or another thing
  switch (class (object))
    case 'function_handle'
      % For a function handle we will only print the name
      fun = functions (object);
      fprintf(fd, '%s', [ '"', fun.function, '"' ]);
      
    case 'struct'
      sep = 0;
      fields = sort(fieldnames (object));
      fprintf(fd, '{');
      for tmp=1:length(fields)
	savesep(sep, fd, ind);
	fprintf(fd,'"%s":', fields{tmp});
	savejson(object.(fields{tmp}), fd, ind);
	sep = 2;
      end
      fprintf(fd, '}');
    case 'cell'
      % We dereference the cell and use it as a new value
      savejson(object{1}, fd, ind);
    case 'double'
      if (isreal (object))
	fprintf(fd,'%g', object);
      else
	fprintf(fd,'{"real":%g,"image":%g}',real(object), imag(object));
      end
    case 'char'
      % Here we handle a single char
      % JSON only admits the next escape sequences:
      % \", \\, \/, \b, \f, \n, \r, \t and \u four-hex-digits
      % so we must be sure that every other sequence gets replaced
      fprintf(fd, '"%s"', replace_non_JSON_escapes (object));
    otherwise
      % We don't know what is it so we'll put the class name
      fprintf(fd, '"%s"', class(object));
  end
else
  % It's a vector/array so it maps to a list of some sort
  sep = 0;
  if numel(s) > 2 % High dimensional
    fprintf(fd, '[');
    for (tmp=1:s(1))
      savesep(sep, fd, ind);
      savejson(reshape(object(tmp, :), s(2:end)), fd, ind);
      sep = 2;
    end
    fprintf(fd, ']');
  else
    % We can have three cases here:
    % Object is a row -> array with all the elements
    % Object is a column -> each element is an array in it's own
    % Object is a 2D matrix -> separate each row
    if s(1)==1
      % Object is a row
      if ischar(object)
	% If it's a row of chars we will take it as a string
	% JSON only admits the next escape sequences:
	% \", \\, \/, \b, \f, \n, \r, \t and \u four-hex-digits
	% so we must be sure that every other sequence gets replaced
	fprintf(fd, '"%s"', replace_non_JSON_escapes(object));
      else
	fprintf(fd,'[');
	sep = 0;
	for tmp=1:s(2)
	  savesep(sep, fd, ind);
	  savejson(object(1, tmp), fd, ind);
	  if ismatrix(object(tmp)) && numel(object(tmp))==1
	    sep = 1;
	  else
	    sep = 2;
	  end
	end
	fprintf(fd,']');
      end
    elseif (s(2) == 1)
      % Object is a column
      fprintf(fd, '[');
      sep = 0;
      for tmp=1:s(1)
	savesep(sep, fd, ind);
	fprintf(fd, '[');	
        savejson(object(tmp, 1), fd, ind);
	fprintf(fd, ']');
	if ismatrix(object(tmp)) && numel(object(tmp))==1
	  sep = 1;
	else
	  sep = 2;
	end
      end
      fprintf(fd,']');
    else
      % Object is a 2D matrix
      fprintf(fd, '[');
      sep = 0;
      for tmp=1:s(1)
	savesep(sep, fd, ind);
	savejson(object(tmp, :), fd, ind);
	sep = 2;
      end
      fprintf(fd, ']');
    end
  end
end
if ischar(fn)
  fclose(fd);
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function savesep(sep, fd, ind)
switch sep
  case 0
  case 1
    fprintf(fd, ', ');
  case 2
    fprintf(fd, ',\n%s', ind);
end

% JSON only admits the next escape sequences:
% \", \\, \/, \b, \f, \n, \r, \t and \u four-hex-digits
% This function replace every escaped sequence that isn't on that list
% with a compatible version
% Note that this function uses typeinfo so it may need to be updated
% with each octave release

function object = replace_non_JSON_escapes (object)

if (strcmp (typeinfo (object), 'string'))
  % It's a double quoted string so newlines and other chars need
  % to be converted back into escape sequences before anything
  object = undo_string_escapes (object);
end
  
% This first regex handles double quotes and slashes that are not
% after a backslash and thus aren't escaped
object = regexprep (object, '(?<!\\)(["/])', "\\$1");
% This regex handle double quotes and slashes that are after an even
% number of backslashes and thus aren't escaped
object = regexprep (object, '(?<!\\)(\\\\)*(["/])', "$1\\$2");
% This last one regexp handle any other valid JSON escape sequence
object = regexprep (object, '(?<!\\)\\(?=(\\\\)*(?!([\"\\\/bfnrt]|([u][0-9A-Fa-f]{4}))+?))', "\\\\");


