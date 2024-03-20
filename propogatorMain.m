clc;clear;close all;
%% User input
show = "both";      % Must be either "orbit", "ground track", or "both"
tScale = 60*60;     % ratio of sim:real time (600 means 1sec irl = 10min in sim)
loop = true;        % Whether to propagate on to infinity. Only matters for ground track

% initial state vector [x;y;z;vx;vy;vz]
%x0 = [7000e3;0;0;0;4000;7200];
x0 = [5500000;0;-3700000;0;10090;3000];
%x0 = [5500000;0;-3900000;0;9090;-3300];

% Below are some more you could try out
%Geosynchronous:
%x0 = [42164140.1001;0;0;0;3074.66117598*cosd(35);3074.66117598*sind(35)];
%x0(1:2) = [cosd(-55), -sind(-55); sind(-55), cosd(-55);] * x0(1:2);
%x0(4:5) = [cosd(-55), -sind(-55); sind(-55), cosd(-55);] * x0(4:5);

%ISS orbit:
%x0 = [3483.495389397490 -2590.714176324950 5217.945310101760 5.55480922623849 5.15756058933294 -1.13973257161171]'*1e3;
%Molniya orbit
% x0 = [5511460;0;-4104085.01975;0;10050.1944425;0];
% 1/3-day period orbit
%x0 = [5511460;0;-3700000;0;10022;0];
%x0 = [8e6 0 0 0 7e3 0];
%% Change these to change the body you're orbiting
uvmap = 'earth.jpg';
bodyR = earthRadius('m');
mu = 3.986004418e14;        % body std grav param
omega = 360/86164.0905;
 
%% Propagate the orbit and calculate orbital elements
[eccen, sma, inc, ~, ~, period, specE, angMom] = calcOrbels(x0, mu);
aSci = [sma/10^floor(log10(sma)),floor(log10(sma))];
epsSci = [specE/10^floor(log10(specE)),floor(log10(specE))];
hSci = [angMom/10^floor(log10(angMom)),floor(log10(angMom))];
msg = sprintf("\\bf Elements\\rm\n"+...
    "Semi Major Axis: %.3f\\times10^{%d} m\n"+...
    "Inclination: %.4f\\circ\n"+...
    "Eccentricity: %.3f\n"+...
    "\n\\bf Characteristics\\rm\n"+...
    "Specific Energy: %.3f\\times10^{%d} J/kg\n"+...
    "Angular Momentum: %.3f\\times10^{%d} m^2/s\n"+...
    "Period: "+string(duration(0,0,period)), aSci, inc, eccen, epsSci, hSci);
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'modal';
msgbox(msg, "orbital elements",CreateStruct);

options = odeset('RelTol', 1e-10, 'AbsTol', 1e-11, 'MaxStep', 30, 'Stats', 'on', 'Events',@(t,x) detectCollide(t,x, bodyR));
[T,stateVec, te, xe, ie] = ode45(@(t,x) dynamics(t,x, mu), [0,period], x0, options);

Xeci = stateVec(:,1:3);
Veci = stateVec(:,4:6);

img = imread(uvmap);  img = img(end:-1:1,:,:);
show = lower(show);
%% Calculate ground track and create figure
if(show=="ground track" || show=="both")
    [long, lat] = eci2ecef(Xeci, -omega*T);
    [long, lat] = wrapLongLat(long, lat, 30);

    [gndTrFig, gndPt] = makeGndTrPlot(img, long, lat);
end
%% Draw orbit figure
if(show == "orbit" || show=="both")
    [orbFig, orbPt, planet] = makeOrbPlot(img,Xeci);
end

%% Define missing variables
if show == "ground track"
    orbFig = nan;
    orbPt = nan;
    planet = nan;
elseif show == "orbit"
    long = nan;
    lat = nan;
    gndTrFig = nan;
    gndPt = nan;
end
%% Animation
if(show == "both")
    animateBoth(long,lat, Xeci, Veci, gndPt, orbPt, gndTrFig, orbFig, tScale, T, te, planet, omega, loop)
end
if(show == "orbit")
    animateOrb(Xeci, Veci, orbPt, orbFig, tScale, T, te, planet, omega, loop)
end
if(show == "ground track")
    animateGndTr(long,lat, gndPt, gndTrFig, tScale, T, te, omega, loop)
end