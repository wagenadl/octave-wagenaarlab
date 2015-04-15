function cc = colorconvert(cc, varargin)
% COLORCONVERT - Convert between various color spaces
%    cc = COLORCONVERT(cc, 'from', SPC1, 'to', SPC2) converts from
%    color space SPC1 to color space SPC2.
%    Recognized spaces are: 
%      srgb -   The familiar gamma-corrected sRGB
%               See http://en.wikipedia.org/wiki/SRGB
%      linearrgb - Linear RGB; simply sRGB with the gamma correction 
%                  taken out
%      ciexyz - CIE XYZ
%               See http://en.wikipedia.org/wiki/CIE_1931_color_space
%      cielab - CIE L*a*b* (L* is lightness; a*, b* are chromaticities)
%               L* ranges 0..100; a* ranges -500..+500; b* ranges -200..+200
%               See http://en.wikipedia.org/wiki/Lab_color_space
%      cielch - Cylindrical version of CIE L*a*b* (Lightness, Chroma, Hue)
%               L* ranges 0..100, C* ranges 0..200 or so; h ranges 0..2*pi.
%      cieluv - CIE L*u*v* (L* is lightness; u*, v* are chromaticities)
%               L* ranges 0..100; u* and v* range approx -100..+100.
%               See http://en.wikipedia.org/wiki/CIELUV
%      cielchuv - Cylindrical version of CIE L*u*v*
%               L* ranges 0..100, C* ranges 0..100 or so; h ranges 0..2*pi.
%      lshuv -  As cielchuv, but with C* replaced by saturation s.
%               See http://en.wikipedia.org/wiki/Colorfulness#Saturation
%      lshab -  As cielch, but with C* replaced by saturation s.
%      hcl   -  Alternative to cielch proposed by Sarifuddin and Missaoui.
%               See http://w3.uqo.ca/missaoui/Publications/TRColorSpace.zip
%
%    cc = COLORCONVERT(cc, k, v, ...) specifies additional parameters:
%      whitepoint: whitepoint for cielab to/from ciexyz conversion. 
%            (Either an XYZ triplet or one of 'd50', 'd55', 'd65', 'a', 'c'.)
%      clip: how to deal white clipped values.
%            (0: don't clip; 1: hard clip; 2: proportional clip;
%             nan: set to nan.)

kv = getopt('from=''ciexyz'' to=''ciexyz'' whitepoint=''d65'' clip=0', ...
    varargin);

if strcmp(kv.from, kv.to)
  return;
end

% Work our way from source to XYZ
if strcmp(kv.from, 'cielch')
  cc = cielchtocielab(cc);
  kv.from = 'cielab';
elseif strcmp(kv.from, 'cielchuv')
  cc = cielchtocielab(cc); % yes, really
  kv.from = 'cieluv';
elseif strcmp(kv.from, 'lshab')
  cc = lshuvtocieluv(cc);  % yes, really
  kv.from = 'cielab';
elseif strcmp(kv.from, 'lshuv')
  cc = lshuvtocieluv(cc);
  kv.from = 'cieluv';
elseif strcmp(kv.from, 'srgb')
  cc = srgbtolinearrgb(cc);
  kv.from = 'linearrgb';
elseif strcmp(kv.from, 'hcl')
  cc = hcltolinearrgb(cc);
  kv.from = 'linearrgb';
end

if strcmp(kv.from, kv.to)
  return;
end

if strcmp(kv.from, 'linearrgb')
  cc = linearrgbtociexyz(cc);
  kv.from = 'ciexyz';
elseif strcmp(kv.from, 'cielab')
  cc = cielabtociexyz(cc, kv.whitepoint, kv.clip);
  kv.from = 'ciexyz';  
elseif strcmp(kv.from, 'cieluv')
  cc = cieluvtociexyz(cc, kv.whitepoint, kv.clip);
  kv.from = 'ciexyz';  
end

if ~strcmp(kv.from, 'ciexyz')
  error('Unknown source color space');
end

post = [];
if strcmp(kv.to, 'srgb')
  post = @linearrgbtosrgb;
  kv.to = 'linearrgb';
elseif strcmp(kv.to, 'hcl')
  post = @linearrgbtohcl;
  kv.to = 'linearrgb';
elseif strcmp(kv.to, 'cielch')
  post = @cielabtocielch;
  kv.to = 'cielab';
elseif strcmp(kv.to, 'cielchuv')
  post = @cielabtocielch;
  kv.to = 'cieluv';
elseif strcmp(kv.to, 'lshab')
  post = @cieluvtolshuv;
  kv.to = 'cielab';
elseif strcmp(kv.to, 'lshuv')
  post = @cieluvtolshuv;
  kv.to = 'cieluv';
end

if strcmp(kv.to, 'linearrgb')
  cc = ciexyztolinearrgb(cc, kv.clip);
  kv.from = 'linearrgb';
elseif strcmp(kv.to, 'cielab')
  cc = ciexyztocielab(cc, kv.whitepoint);
  kv.from = 'cielab';
elseif strcmp(kv.to, 'cieluv')
  cc = ciexyztocieluv(cc, kv.whitepoint);
  kv.from = 'cieluv';
end

if ~strcmp(kv.from, kv.to)
  error('Unknown destination color space')
end

if ~isempty(post)
  cc = post(cc);
end

  