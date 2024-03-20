function [long,lat] = eci2ecef(X,theta)
%CALCECEF rotates x and y coordinates for the purpose of rotating from ECI
%into ECEF.
%   X is the position vectors, theta is a vector to rotate by
Xecef = 0*X;
for i = 1:length(X)
    Xecef(i,:) = [cosd(theta(i)), -sind(theta(i)), 0; sind(theta(i)), cosd(theta(i)), 0; 0, 0, 1] * X(i,:)';
end
long = atan2d(Xecef(:,2), Xecef(:,1));
R = vecnorm(Xecef(:,[1,2])');
lat = atan2d(Xecef(:,3), R');
jumpPts = find((abs(diff(lat)) > 30) + (abs(diff(long)) > 30)); % find any points where either long or lat jump by >30 deg
for a = jumpPts
    long(a+2:end+1) = long(a+1:end);  long(a+1) = nan;
    lat(a+1:end+1) = lat(a:end);    lat(a+1) = nan;
end
end