function snew = removelargeunc(s, thresh)
% removelargeunc  Removes time series observations with large uncertainty
%   snew = removelargeunc(s, thresh) cleans a time series in structure s 
%   by setting to zero entries of the "sdate" field corresponding to 
%   uncertainty magnitudes that exceed the specified threshold.  
%

% Define default threshold if not specified
if ~exist('thresh', 'var')
   thresh = 10;
end

% Calculate uncertainty magnitude
uncmag = sqrt(s.sse.^2 + s.ssn.^2);

% Copy time series structure
snew = s;

% Set sdate entries to zero for large uncertainty days
% This does not remove any stations or positions, but
% by setting the date to zero, these days will not be
% considered in other posarrays functions
snew.sdate(uncmag >= thresh) = 0;
