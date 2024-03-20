function [long,lat] = wrapLongLat(long, lat, tol)
%WRAPANGLE Wraps longitude and latitude
%   Given a longitude and latitude vector as well as tolerances, binds the
%   longitude between -180 and 180 degrees, and the latitude between -90
%   and 90 degrees. So that the vectors can be displayed without lines
%   across the screen, it also adds a nan point between jumps. The
%   tolerance determines the magnitude of jump that indicates wrapping the
%   angle
long = rmmissing(long);
lat = rmmissing(lat);
long = wrapTo180(long);
lat = wrapTo180(2*lat)/2;
jumpPts = find((abs(diff(lat)) > tol) + (abs(diff(long)) > tol)); % find any points where either long or lat jump by >tol
for a = jumpPts
    long(a+2:end+1) = long(a+1:end);  long(a+1) = nan;
    lat(a+1:end+1) = lat(a:end);    lat(a+1) = nan;
end
end

