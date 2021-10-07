function varargout = xyz2enu(lon, lat, varargin)
% XYZ2ENU converts from Cartesian to geographic coordinates.
%    ENU = XYZ2ENU(LON, LAT, XYZ) converts the X, Y, Z coordinates
%    contained in the n-by-3 array XYZ to E, N, U components, returned
%    to the n-by-3 array ENU, using the point at LON, LAT as a basis.
%
%    [E, N, U] = XYZ2ENU(LON, LAT, X, Y, Z) allows specification of 
%    input and output argument as separate arrays.  Inputs and outputs
%    can be any combination of components or matrices.
%

% Check inputs
if nargin == 3 % Array was specified
   x = varargin{:}(:, 1);
   y = varargin{:}(:, 2);
   z = varargin{:}(:, 3);
else
   x = varargin{1}(:);
   y = varargin{2}(:);
   z = varargin{3}(:);
end

% Construct the matrix components
r11 = -sind(lat(:)).*cosd(lon(:));
r12 = -sind(lat(:)).*sind(lon(:));
r13 = cosd(lat(:));
r21 = -sind(lon(:));
r22 = cosd(lon(:));
r23 = 0;
r31 = cosd(lat(:)).*cosd(lon(:));
r32 = cosd(lat(:)).*sind(lon(:));
r33 = sind(lat(:));

% Do the conversion
n = r11.*x + r12.*y + r13.*z;
e = r21.*x + r22.*y + r23.*z;
u = r31.*x + r32.*y + r33.*z;

% Check outputs
if nargout == 3
   varargout(1) = {e(:)};
   varargout(2) = {n(:)};
   varargout(3) = {u(:)};
else
   varargout(1) = {[e(:) n(:) u(:)]};
end