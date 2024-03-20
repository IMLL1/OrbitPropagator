function dx = dynamics(t, XC, mu) 
%DYNAMICS Simulate the dynamics of the satellite
%   Simulates the dynamics of a system through matrix vector derivatives.
%   The fundamental basis of this calculation is finding some matrix F that
%   transforms X' onto X, where X is the state vector and X' is its time
%   derivative.
pos = XC(1:3); x = XC(1); y=XC(2); z=XC(3);
r = norm(pos);
% topLt = -mu * [2*x.^2-y.^2-z.^2, 3*x*y,             3*x*z;...
%               3*x*y,            -x.^2+2*y.^2-z.^2,  3*y*z;...
%               3*x*z,            3*y*z,             -x.^2-y.^2+2*z.^2] ./ r.^5;
% jacobian = [zeros(3,3), eye(3);topLt,zeros(3,3)]; % EKF method
% phi = expm(dynMtx .* t);
% dSigma = phi * Sigma * inv(phi) - eye(6);
dynMtx = [zeros(3,3), eye(3);-mu/r.^3 * eye(3),zeros(3,3)];   % naive method
dx = dynMtx * XC;
end