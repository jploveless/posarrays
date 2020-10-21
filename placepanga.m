function panga = placepanga(coords, fulldate)
% placepanga  Places PANGA observations into time series arrays.
%   panga = placepanga(coordsfile) reads the reference coordinates
%   from coordsfile, then uses the station names to read all available
%   .lon, .lat, .rad files in the same directory. These coordinates are
%   then placed into arrays of size nStations-by-nDays, where nDays is 
%   the total date span of all files. 
%

if ischar(coords)
   % Read reference coordinate file
   fid = fopen(coords, 'r');
   c = textscan(fid, '%s %f %f\n');
   name = char(c{1});
   refn = c{2};
   refe = wrapTo360(c{3});
   % Get path of coords. file
   [p, f] = fileparts(coords);
   if isempty(p)
      p = '.';
   end
else
   name = coords.name;
   refn = coords.lat;
   refe = coords.lon;
end

if ~exist('p', 'var')
   p = '.';
end

% Set up arrays for placement
if ~exist('fulldate', 'var')
   fulldate = datenum('1/1/1993'):datenum(date); % Date vector that definitely spans time series
end
ndate = zeros(length(name), length(fulldate));
nde = ndate;
ndn = ndate;
ndu = ndate;
nse = ndate;
nsn = ndate;
nsu = ndate;

% Read in PANGA files and place observations into new arrays
% PANGA time series files assumed to be in same directory as coords file
for i = 1:length(name)
   if exist([p filesep name(i, :) '.lon'], 'file')
      [dates, de, se, dn, sn, du, su] = readpanga([p filesep name(i, :)]);
      [~, didx] = ismember(dates, fulldate);
      ndate(i, didx(didx ~= 0)) = dates(didx ~= 0);
      nde(i, didx(didx ~= 0)) = de(didx ~= 0);
      ndn(i, didx(didx ~= 0)) = dn(didx ~= 0);
      ndu(i, didx(didx ~= 0)) = du(didx ~= 0);
      nse(i, didx(didx ~= 0)) = se(didx ~= 0);
      nsn(i, didx(didx ~= 0)) = sn(didx ~= 0);
      nsu(i, didx(didx ~= 0)) = su(didx ~= 0);
   end
end

% Check for blank rows
keep = sum(ndate, 2) ~= 0;

% Create structure with consistent field names
panga.sname = name(keep, :);
panga.srefe = refe(keep);
panga.srefn = refn(keep);
panga.sdate = ndate(keep, :);
panga.sde = nde(keep, :);
panga.sdn = ndn(keep, :);
panga.sdu = ndu(keep, :);
panga.sse = nse(keep, :);
panga.ssn = nsn(keep, :);
panga.ssu = nsu(keep, :);

keep = sum(panga.sdate) > 0;
% Check for blank columns
panga.sdate = panga.sdate(:, keep);
panga.sde   = panga.sde  (:, keep);
panga.sdn   = panga.sdn  (:, keep);
panga.sdu   = panga.sdu  (:, keep);
panga.sse   = panga.sse  (:, keep);
panga.ssn   = panga.ssn  (:, keep);
panga.ssu   = panga.ssu  (:, keep);

