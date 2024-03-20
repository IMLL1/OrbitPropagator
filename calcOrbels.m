function [eccen, sma, inc, raan, argp, period, specE, angMom] = calcOrbels(stateVec,mu)
%CALCORBELS Calculates orbital elements
%   Calculates the period (in seconds), eccentricity, semi-major axis (in
%   meters), inclination (in degrees), RAAN (in degrees), argument of
%   periapsis (in degrees), period (in seconds), specific energy (in
%   Joules/kg), and angular momentum (scalar, in m^2/s)
R = stateVec(1:3);
V = stateVec(4:6);
angMom = cross(R,V);
inc = acosd(dot(angMom, [0;0;1])/norm(angMom));
inc = wrapTo180(2*inc)/2;
raan = 0;

angMom = norm(angMom);
specE = 0.5 * norm(V)^2 - mu / norm(R);
sma = -mu / (2*specE);
period = sqrt(4*pi^2*sma^3/mu);
eccen = sqrt(1 - angMom^2 / (sma*mu));
argp = 0;
end
