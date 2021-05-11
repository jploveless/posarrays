function [stnew, keep] = cleanssedisplacements(st, neard, nz, minunc, maxunc)
% cleanssedisplacements   Cleans an SSE displacement structure before inversion.
%   snew = cleanssedisplacements(s, neard, minunc, maxunc) cleans structure s, 
%   containing fields lon, lat, eastVel, northVel, eastSig, and northSig in 
%   preparation for slip estimation. Up to five filters are run: 
%   1) (Nearly) collocated stations are identified, and the one with the 
%      lowest uncertainty is retained. The distance threshold is specified 
%      in km as input variable neard.
%   2) Very low uncertainty stations (less than minunc) are removed
%   3) High uncertainty stations (greater than maxunc) are removed
%
%   Specify minunc and/or maxunc = 0 to filter solely by proximity.
%


% Keep array. Entries will be set as false as they fail tests
keep = true(length(st.lon), 4);

% Calculate magnitude of uncertainties
velmag = sqrt(st.eastVel.^2 + st.northVel.^2);

% Calculate magnitude of uncertainties
sigmag = sqrt(st.eastSig.^2 + st.northSig.^2);

% Edit nearly collocated stations
if neard ~= 0
   for i = 1:length(st.lon) % For each station,
      % Calculate distance to all other stations. It's okay that self-distance is zero
      dd = distance(st.lat(i), st.lon(i), st.lat, st.lon, almanac('earth', 'ellipsoid', 'kilometers'));
      % Identify close stations (suggest neard = 0.5 km)
      close = dd < neard;
      subset = find(close);
      % Find "regional average" displacement
      rclose = dd < 10*neard;
      eastav = mean(st.eastVel(rclose));
      nortav = mean(st.northVel(rclose));
      eastdif = st.eastVel(subset) - eastav;
      nortdif = st.northVel(subset) - nortav;
      % Find index of close stations that is closest to regional average
      [~, mi] = min(sqrt(eastdif.^2 + nortdif.^2));
      % Get rid of the others with higher uncertainties
      keep(setdiff(subset, subset(mi)), 1) = false;
   end
end

% Filter zero, NaN displacements
if nz ~= 0
   keep(:, 2) = velmag ~= 0 & ~isnan(velmag);
end   

% Filter very low uncertainty stations
if minunc ~= 0 % Min. can be set as zero if no stations should be filtered in this way
   keep(sigmag <= minunc, 3) = false;
end

% Filter high uncertainty stations
if maxunc ~= 0
   keep(sigmag >= maxunc, 4) = false;
end

% Make new station subset structure, keeping only stations that pass all 4 tests
stnew = structsubset(st, sum(keep, 2) == 4);
