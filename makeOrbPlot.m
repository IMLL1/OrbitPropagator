function [fig, animatedPt, bodyObj] = makeOrbPlot(img, Xeci)
%MAKEGNDTRPLOT Creates the 3d orbit plot
%   Sets up the 3d orbit plot, returning the figure handle, animated point
%   hangle, and handle for the body to be rotated
c=[0.025 0.025 0.025];
fig = figure('name', 'Orbit', 'Color',c);
view(3);

[Ex, Ey, Ez] = sphere(25);
bodyObj = warp(Ex*earthRadius('m'), Ey*earthRadius('m'), Ez*earthRadius('m'), imresize(img, 0.5));
set(gca, 'YDir', 'normal');

hold on; axis equal;
xlabel("ECI x [m]"); ylabel("ECI y [m]"); zlabel("ECI z [m]");
title('Orbit Propagator', 'Color', 'w'); subtitle("", 'Color', 'w');
set(gca,'Color',c);set(gca,'GridColor','w');set(gca,'XColor','w');set(gca,'YColor','w');set(gca,'ZColor','w');
grid on;

plot3(Xeci(:,1),Xeci(:,2),Xeci(:,3), '-c');
animatedPt = animatedline('Marker','.', 'LineStyle','none','MarkerSize',25,'MarkerEdgeColor','r','MaximumNumPoints',1);
end

