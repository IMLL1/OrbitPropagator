function [inSpace,isterminal,direction] = detectCollide(t,stateVec, R)
%CALCTFIN Detects collisions with the surface
%   Detects when the object passes from above the radius of the planet to
%   below the radius, so that the propagator knows to cease propagation.
    inSpace = norm(stateVec(1:3)) <= R;
    isterminal = 1;
    direction = 1;
end