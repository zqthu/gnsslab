function Rx = geo_spinx(phi)
% GEO_SPINX returns the rotation matrix about the x-axis.
%
% SYNTAX:
%   Rx = geo_spinx(phi);
%
% INPUT:
%   phi - rotation angle about the x-axis, anticlockwise as seen looking
%         towards the origin from positive x.(radians, 1x1xn);
%
% OUTPUT:
%   Rx  - teh rotation matrix about the x-axis. (3x3xn)
%
% See also GEO_RY, GEO_RZ.

% validate number of input arguments
narginchk(1,1);

% set the rotation matrix
% Rx = [1, 0, 0; 0, cos(phi), sin(phi); 0, -sin(phi), cos(phi)];
Rx = zeros([3,3,length(phi)]);
Rx(1,1,:) = 1;
Rx(2,2,:) = cos(phi);
Rx(2,3,:) = sin(phi);
Rx(3,2,:) = -Rx(2,3,:);
Rx(3,3,:) = Rx(2,2,:);

end

