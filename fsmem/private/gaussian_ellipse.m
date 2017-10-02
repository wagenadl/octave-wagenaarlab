function xy = gaussian_ellipse(mu,sig,npts)
% xy = GAUSSIAN_ELLIPSE(mu,sig,npts) returns an array of points
% describing the 2 sigma ellipse of a gaussian with mean mu and
% covariance matrix sig. The ellipse is represented by npts points.
% Input: mu: 2x1 vector of means
%        sig: 2x2 covariance matrix
%        npts: integer
% Output: npts x 2 point matrix
% Typical use of result: plot(xy(:,1),xy(:,2));
% Algorithm: modified by Daniel Wagenaar from Sam Roweis' plotGauss.
% Coding: DW

% Copyright: Do with this whatever you like, but note Sam Roweis' msg below.

% Copyright msg from Sam Roweis' plotGauss:
% This code was written by Sam Roweis, roweis@cns.caltech.edu.
% PLEASE DO NOT REDISTRIBUTE. TELL PEOPLE TO GET A COPY THEMSELVES
% FROM THE FTP SITE AT hope.caltech.edu in pub/roweis/EM
% You are free to use this code for any research BUT NOT COMMERCIAL purpose.


step = 2*pi/npts;
t = 0:step:2*pi;
x = cos(t);
y = sin(t);
[ v, d ] = eig(sig);
a = real(v*sqrt(d));
xy = [ x', y' ] * a' * 2;
xy(:,1) = xy(:,1) + mu(1);
xy(:,2) = xy(:,2) + mu(2);

