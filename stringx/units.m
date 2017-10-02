function [newval,ok] = units(oldval, oldunit, newunit)
% UNITS - Unit conversion
%   newval = UNITS(oldval, oldunit, newunit) converts the value OLDVAL
%   specified in units OLDUNIT to new units NEWUNIT and returns the result.
%   For instance, UNITS(2, 'inch', 'cm') returns 5.08.
%   As an alternative, you can call it as UNITS(oldvalunit, newunit),
%   for instance, UNITS('2 inch', 'cm').
%
%   The full syntax for unit specification is like this:
%
%   BASEUNIT = m | s | g | A
%   PREFIX = m | u | n | p | f | k | M | G | T
%   ALTUNIT = meter | meters | second | seconds | sec | secs |
%             gram | grams | gm | amp | amps | ampere | amperes | 
%             Amp | Ampere | Amperes
%   ALTPREFIX = milli | micro | nano | pico | femto | kilo |
%               mega | Mega | giga | Giga | tera | Tera
%   DERIVEDUNIT = in | inch | Hz | Hertz | hertz | cyc | cycles |
%                 V | volt | Volt | volts | Volts |
%                 N | newton | Newton | newtons | Newtons |
%                 Pa | pascal | bar | atm | torr |
%                 J | joule | joules | Joule | Joules |
%                 barn | 
%                 Ohm | Ohms | ohm | ohms | mho | Mho
%   UNIT = (PREFIX | ALTPREFIX)? (BASEUNIT | ALTUNIT | DERIVEDUNIT)
%   DIGITS = [0-9]
%   INTEGER = ('-' | '+')? DIGIT+
%   NUMBER = ('-' | '+')? DIGIT* ('.' DIGIT*)? ('e' ('+' | '-') DIGIT*)?
%   POWFRAC = INTEGER ('|' INTEGER)?
%   POWERED = UNIT ('^' POWFRAC)?
%   FACTOR = POWERED | NUMBER
%   MULTI = FACTOR (' ' MULTI)?
%   FRACTION = MULTI ('/' MULTI)?
%
%   Thus, the following would be understood:
%
%     'kg m / s^2' - That's a newton
%     'J / Hz^1|2' - Joules per root-Hertz
%
%   Note that fractions in exponents are written with '|' rather than '/'.
%   Note also that '/' binds most loosely, e.g,
%
%     'kg / m s' - kilogram per meter per second
%
%   A warning is printed if NEWUNIT and OLDUNIT are incompatible.
%   An error is generated if either OLDUNIT or NEWUNIT cannot be parsed.
%   That this can happen if UNITS doesn't know your perfectly 
%   reasonable unit names. (In that case, please improve the database.)
%   Syntax checking is not rigorous. Many invalid expressions will return
%   meaningless values without a reported error. This behavior is not
%   particularly predictable. For instance '1+1' returns NaN, while '1 + 1'
%   returns 1. (Note that UNITS does not support addition or subtraction at
%   all.)
%
%   [newval,ok] = UNITS(...) returns OK=1 if all is well, OK=0 if not.
%   This suppresses warnings and error generation. The NEWVAL will be NaN
%   if there is a real error, or defined (but possibly meaningless) if
%   there is a unit mismatch.
%
%   UNITS v. 0.10, Copyright (C) 2009 Daniel Wagenaar. 
%   This software comes with ABSOLUTELY NO WARRANTY. See code for details.

%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; version 2 of the License.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare unit database
baseunits = strtoks('m s g A mol');
altunits = { 'meter=meters=m', 
             'second=seconds=sec=secs=s', 
	     'gram=grams=gm=g',
	     'amp=amps=ampere=amperes=Amp=Ampere=Amperes=A',
	     'in=inch=2.54 cm',
	     'l=L=liter=liters=1e-3 m^3',
	     'Hz=Hertz=hertz=cyc=cycles=s^-1',
	     'C=Coulomb=coulomb=Coulombs=coulombs=A s',
	     'N=newton=Newton=newtons=Newtons=kg m s^-2',
	     'J=joule=joules=Joule=Joules=N m',
	     'W=watt=Watt=watts=Watts=J s^-1'
	     'V=Volt=volt=Volts=volts=W A^-1',
	     'Pa=pascal=Pascal=N m^-2',
	     'bar=1e5 Pa',
	     'atm=101325 Pa',
	     'torr=133.32239 Pa',
	     'Ohm=Ohms=ohm=ohms=V A-1',
	     'mho=Mho=Ohm^-1',
	     'barn=1e-28 m^2',
	     'M=molar=mol l^-1',
	     };

prefix = strtoks('d c m u n p f k M G T');
prefixval = 10.^[-1 -2 -3 -6 -9 -12 -15 3 6 9 12];
altprefix = { 'deci=d',
              'centi=c',
              'milli=m',
              'nano=u',
	      'pico=p',
	      'femto=f',
	      'kilo=k',
	      'mega=Mega=M',
	      'giga=Giga=G',
	      'tera=Tera=T'
	      };

allprefix = prefix;
allprefixval = prefixval;
for n=1:length(altprefix)
  bits = strtoks(altprefix{n},'=');
  for k=1:length(bits)-1
    allprefix{end+1} = bits{k};
    allprefixval(end+1) = prefixval(strmatch(bits{end},prefix,'exact'));
  end
end

unitcode = primes(2*2.^length(baseunits));
unitcode = unitcode(1:length(baseunits));
unitsrc = {};
unitrep = {};
for n=1:length(altunits)
  bits = strtoks(altunits{n},'=');
  for k=1:length(bits)-1
    unitsrc{end+1} = bits{k};
    unitrep{end+1} = bits{end};
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check arguments
if nargin==2
  newunit = oldunit;
  oldunit = oldval;
  oldval = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
  [oldmul, oldcode] = units_fracdecode(oldunit, ...
      allprefix, allprefixval, ...
      baseunits, unitcode, unitsrc, unitrep, '');
  
  [newmul, newcode] = units_fracdecode(newunit, ...
      allprefix, allprefixval, ...
      baseunits, unitcode, unitsrc, unitrep, '');
  
  newval = oldval * oldmul / newmul;
  ok = oldcode==newcode;
  if nargout<2
    if ~ok
      fprintf(1,'Warning: units "%s" do not match "%s" (%g != %g)\n',newunit,oldunit,newcode,oldcode);
    end
    clear ok
  end
catch
  if nargout<2
    error(lasterr);
  else
    ok = 0;
    newval = nan;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mul,code] = units_fracdecode(str, ...
    allprefix, allprefixval, ...
    baseunits, unitcode, unitsrc, unitrep, dep)
unit_dbg('%sunits_fracdecode("%s")\n',dep,str);
if isempty(str)
  str=' '; % Prevents warning about empty==scalar comparison
end
idx=find(str=='/');
if isempty(idx)
  numer = str;
  denom = '';
else
  numer = str(1:idx(1)-1);
  denom = str(idx(1)+1:end);
  idx = find(denom=='/');
  denom(idx)=' ';
end
multis = { numer, denom };
for q=1:2
  mul(q)=1;
  code(q)=1;
  factors = strtoks(multis{q},' ');
  for k=1:length(factors)
    fac = factors{k};
    head = fac(1);
    [mu, co] = units_decode(fac, allprefix, allprefixval, ...
	baseunits, unitcode, unitsrc, unitrep,[dep '  ']);
    mul(q) = mul(q)*mu;
    code(q) = code(q)*co;
  end
end
mul=mul(1)/mul(2);
code=code(1)/code(2);
unit_dbg('%s-> %g [%g]\n',dep,mul,code);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mu,co]  = units_decode(fac, ...
    allprefix, allprefixval, ...
    baseunits, unitcode, unitsrc, unitrep, dep)

unit_dbg('%sunits_decode("%s")\n',dep,fac);

head = fac(1);
if any('0123456789-+.'==head)
  % It's a number
  mu = str2double(fac);
  co = 1;
  unit_dbg('%s-> %g [%g]\n',dep,mu,co);
  return
end

% So it must be a POWERED
idx = find(fac=='^');
if ~isempty(idx)
  % Let's decode the POWFRAC
  pw=1;
  base=fac(1:idx(1)-1);
  for k=1:length(idx)
    powfrac = fac(idx(k)+1:end);
    id1 = find(powfrac=='|');
    if ~isempty(id1)
      powfrac = str2double(powfrac(1:id1(1)-1)) / ...
	  str2double(powfrac(id1(1)+1:end));
    else
      powfrac = str2double(powfrac);
    end
    pw=pw*powfrac;
  end
else
  base=fac;
  pw = 1;
end

% Let's decode the UNIT
idx = strmatch(base,baseunits,'exact');
if ~isempty(idx)
  % It's a baseunit without a prefix
  mu=1;
  co=unitcode(idx)^pw;
  unit_dbg('%s-> %g [%g] (pw=%g)\n',dep,mu,co,pw);
  return
end

idx = strmatch(base,unitsrc,'exact');
if ~isempty(idx)
  % It's a derived unit without a prefix
  [mu,co]=units_fracdecode(unitrep{idx}, ...
      allprefix, allprefixval, ...
      baseunits, unitcode, unitsrc, unitrep,[dep '  ']);
  mu=mu^pw; 
  co=co^pw;
  unit_dbg('%s-> %g [%g] (pw=%g)\n',dep,mu,co,pw);
  return;
end

% So we must have a prefix
L0=length(base);
for k=length(allprefix):-1:1
  prf=allprefix(k);
  L=length(prf);
  if L0>L && strcmp(base(1:L),prf)
    % Gotcha
    [mu,co] = units_decode(base(L+1:end), ...
	allprefix, allprefixval, ...
	baseunits, unitcode, unitsrc, unitrep,[dep '  ']);
    mu = mu*allprefixval(k);
    mu=mu^pw; 
    co=co^pw;
    unit_dbg('%s-> %g [%g] (pw=%g)\n',dep,mu,co,pw);
    return;
  end
end

% So nothing matched. This is an input error
error('units: I do not know any unit named "%s"',fac);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function unit_dbg(fmt,varargin)
%fprintf(1,fmt,varargin{:});
