function flux = pda36a(volt, gain, wavelength)
% PDA36A - Convert PDA36A output voltage to photon flux
%    flux = PDA36A(volt, gain, wavelength), where VOLT is the (background-
%    subtracted) voltage output by the PDA36A, GAIN is its gain setting
%    (one of 0, 10, 20, ..., 70), and WAVELENGTH is the center wavelength
%    of the light used (in nanometers), returns the corresponding photon
%    flux (in photons/cm2/s).

switch gain
  case 0
    vpera = 1.51e3;
  case 10
    vpera = 4.75e3;
  case 20
    vpera = 1.5e4;
  case 30
    vpera = 4.75e4;
  case 40
    vpera = 1.51e5;
  case 50
    vpera = 4.75e5;
  case 60
    vpera = 1.5e6;
  case 70
    vpera = 4.75e6;
  otherwise
    error('PDA36A knows gain factors of 0, 10, ..., 70 dB only.');
end

aperw = pda36a_sensitivity(wavelength);

area_cm2 = 3.6e-1 * 3.6e-1;

watt = volt/vpera/aperw;
J_per_cm2_per_s = watt/area_cm2;

h = 6.626e-34; % Js
c = 2.998e8; % m/s
E_photon = h*c/(wavelength*1e-9);

flux = J_per_cm2_per_s/E_photon;
