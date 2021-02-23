function [dslope, pos, unc, ltslope] = dailyslopes(s, np, comp)

warning('off', 'MATLAB:nearlySingularMatrix')   

% Define components of position, preallocate matricies
if comp == 1
   pos = s.sde; % East positions
   unc = s.sse; % East uncertainties
else
   pos = s.sdn; % North positions
   unc = s.ssn; % North uncertainties
end

% Get first and last days of observations for all stations
datesleft = shiftcols(s.sdate);
firstday = datesleft(:, 1);
datesright = shiftcols(s.sdate, -1);
lastday = datesright(:, end);

% Full vector of dates
[ns, nd] = size(s.sdate); % number of stations and dates
nzdates = s.sdate > 0; % Logical array identifying days on which observations exist
fulldate = max(s.sdate); % All real date numbers
ltslope = zeros(ns, 1); % Allocate space for long-term slopes
dslope = zeros(ns, nd); % and daily mean slope 

% Calculate long term velocities of stations
for i = 1:ns
   keep = nzdates(i, :); % Logical identifying days on which there is an observation
   % Design matrix for linear plus periodic fit 
   wslopemat = [s.sdate(i, keep)', ones(sum(keep), 1), ...
                sin(2*pi*(s.sdate(i, keep) - s.sdate(i, find(keep, 1)))/365.25)', ...
                cos(2*pi*(s.sdate(i, keep) - s.sdate(i, find(keep, 1)))/365.25)'];
   
   % Augment with offsets
   offs = offvecmat(s.offs(i, :)');
   offs = offs(keep, :);
   if ~isempty(offs)
      if offs(1) == 0
         wslopemat = [wslopemat, offs];
      end
   end
   
   % Convert uncertainties on positions to weights
   sigma = diag(1./unc(i, keep).^2);
   % Calculate model covariance using backslash
   wcov = (wslopemat'*sigma*wslopemat)\eye(size(wslopemat, 2));
   % Calculate model parameters
   wslope = wcov*wslopemat'*sigma*pos(i, keep)';
   perpos = wslopemat(:, 1:end)*wslope(1:end); % Predicted positions from model
   pos(i, keep) = pos(i, keep) - perpos'; % Correct positions by subtracting long term trend, steps, and periodic contributions
   ltslope(i) = wslope(1); % Retain first value of wslope (no intercept)

   % Calculate av. slope for window surrounding each day
   window = 1:(np + 1); %window of focus is size np
   lw = length(window);
   times = [window', ones(lw, 1)]; % template design matrix for slope estimates
   
   for j = np + 1:(nd - (np + 1)) %start evaluating at npth day, stop np before end
       bestfit = 0*window; % preallocate a window sized matrix for bestfit
       starts = j + (-np:0); %define all starts of best fit lines
       ends = j + (0:np); %define all ends of best fit lines
       for k = 1:lw %loop for all sets of np points in the window
           kpos = pos(i, starts(k):ends(k))'; % positions within window
           kkeep = kpos ~= 0; % indices on which there are actually data
           if sum(kkeep) > np/2 %if not enough days of data in window, skip that point j
              kpos = kpos(kkeep);
              time = times(kkeep, :);
              slope = time\kpos; % slope of best fit line using np days
              bestfit(k) = slope(1);
           end
       end
       % Define score for this day as average of slopes
       dslope(i, j) = nzmean(bestfit);
       % If >half the days have a missing daily slope, set score to zero
       if sum(bestfit ~= 0) < round(np/2)
          dslope(i, j) = 0;
       end
   end
   
   % Uncorrect positions, then recorrect to just subtract periodic and steps
%   pos(i, keep) = pos(i, keep) + perpos'; % Uncorrection
%   perpos = wslopemat(:, 3:end)*wslope(3:end); % Predicted positions from periodic and step contributions
%   pos(i, keep) = pos(i, keep) - perpos'; % Correct positions by subtracting periodic and step contributions
end