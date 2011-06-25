function P_W = candela2watt(br_cd, diam_deg, wavelength_nm)
% CANDELA2WATT - Convert brightness of light in candelas to power in watts
%   P = CANDELA2WATT(br_cd, diam_deg, wavelength_nm) converts the 
%   brightness of a lightsource BR_CD (measured in candelas) to the power P
%   contained in the beam (in watts), given the angular divergence of the beam
%   DIAM_DEG (in degrees) and the wavelength of the beam WAVELENGTH_NM
%   (in nanometers; default: 555 nm).
%   The diameter of the beam is nominally 2*theta_(1/2); i.e. the full angle
%   at which light intensity has dropped to 50% from central peak.
%   This function assumes that the light intensity drops of as
%   exp(-1/2 theta^4/THETA0^4).


if nargin<3
  wavelength_nm = 555;
end

% We assume that BR_CD is measured at 0 degrees, and that the intensity
% drops of with exp(-alpha theta^4), where alpha is found by equating
% exp(-alpha (radius_rad)^4) = 0.5, so:

pwr=4;
radius_rad = .5*diam_deg * pi/180;
alpha = -log(.5) / radius_rad.^pwr;

da_deg=.1;
meas_ang_deg = [da_deg/2:da_deg:90];

da_rad = da_deg * pi/180;
meas_ang_rad = meas_ang_deg * pi/180;
ringlets_st = da_rad*2*pi*sin(meas_ang_rad);

br_local_cd = br_cd*exp(-alpha*meas_ang_rad.^pwr);

br_intg_lumen = sum(ringlets_st.*br_local_cd);

crv=load('vl1924e.txt');
eff = interp1(crv(:,1),crv(:,2),wavelength_nm,'linear');

P_W = br_intg_lumen / eff / 683;
