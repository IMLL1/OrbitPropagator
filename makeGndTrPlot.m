function [fig, animatedPt] = makeGndTrPlot(img, long, lat)
%MAKEGNDTRPLOT Creates the ground track plot
%   Creates a figure for ground track, and populates it with the texture
%   map and the first period of ground track. Returns the figure handle and
%   the handle for the animated point
fig = figure('name', 'Ground Track');
earthAx = imref2d(size(img),[-180,180],[-90,90]);
imshow(img,earthAx);
set(gca, 'YDir', 'normal');
hold on;
plot(long,lat, '-r');
title("Ground Track"); subtitle("");
xlabel("Longitude [deg]");
ylabel("Latitude [deg]");
grid on;
animatedPt = animatedline('Marker','.', 'LineStyle','none','MarkerSize',25,'MarkerEdgeColor','r','MaximumNumPoints',1);
end

