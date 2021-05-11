function snew = densetimeseries(s, thresh)
% densetimeseries  Creates a subset of temporally dense times series
%   snew = densetimeseries(s, thresh) determines the "temporal density"
%   of observations in the time series structure, s, and retains only
%   those stations that exceed a density threshold. 
%
%   Temporal density is defined as the number of position observations
%   normalized by the total time span of the time series (day of first
%   observation to day of last observation).
%

% Default threshold, if need be
if ~exist('thresh', 'var')
   thresh = 0.5;
end

% Determine first and last day of each station's observations
datesleft = shiftcols(s.sdate);
firstday = datesleft(:, 1);
datesright = shiftcols(s.sdate, -1);
lastday = datesright(:, end);

% Sum number of observations and normalize by TS duration
nobsperday = sum(s.sdate ~= 0, 2)./(lastday - firstday);

% Retain only those above specified threshold
keep = nobsperday > thresh;

% Remove those with less than a year of observations
keep((lastday - firstday) < 365) = false;
snew = structsubset(s, keep);