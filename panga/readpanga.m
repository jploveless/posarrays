function [date, de, se, dn, sn, du, su] = readpanga(sta)

% Read longitudes, extracting and processing dates
fid = fopen([sta, '.lon'], 'r');
ft = fgetl(fid); 
hl = 0;
while strmatch(ft(1), '#')
  ft = fgetl(fid);
  hl = hl + 1;
end
frewind(fid);
c = textscan(fid, '%f %f %f\n', 'headerlines', hl);
fclose(fid);

% Extract dates, converting to datenum
date = decyear2date(c{1});
ddate = round(diff(date)); % Rounded date differences; these should be close to 1 at minimum
zddate = find(ddate == 0); % Find duplicate dates
keep1 = setdiff(1:length(date), zddate); % Initial keep indices
keep2 = zeros(1, length(zddate));
for i = 1:length(zddate) % For duplicate dates, 
   [~, smu] = min(c{3}([zddate(i), zddate(i)+1])); % Find the minimum uncertainty
   keep2(i) = zddate(i) + smu - 1; % And keep that one for this date
end
keep = sort([keep1(:); keep2(:)]); % Full set of row indices to be retained
date1 = round(date(keep)); % Integer datenums 

% Extract position and error
lon = c{2}(keep);
slon = c{3}(keep);

% Read latitudes
fid = fopen([sta, '.lat'], 'r');
c = textscan(fid, '%f %f %f\n', 'headerlines', hl);
fclose(fid);

% Extract dates, converting to datenum
date = decyear2date(c{1});
ddate = round(diff(date)); % Rounded date differences; these should be close to 1 at minimum
zddate = find(ddate == 0); % Find duplicate dates
keep1 = setdiff(1:length(date), zddate); % Initial keep indices
keep2 = zeros(1, length(zddate));
for i = 1:length(zddate) % For duplicate dates, 
   [~, smu] = min(c{3}([zddate(i), zddate(i)+1])); % Find the minimum uncertainty
   keep2(i) = zddate(i) + smu - 1; % And keep that one for this date
end
keep = sort([keep1(:); keep2(:)]); % Full set of row indices to be retained
date2 = round(date(keep)); % Integer datenums 

% Extract position and error
lat = c{2}(keep);
slat = c{3}(keep);

% Read verticals
fid = fopen([sta, '.rad'], 'r');
c = textscan(fid, '%f %f %f\n', 'headerlines', hl);
fclose(fid);

% Extract dates, converting to datenum
date = decyear2date(c{1});
ddate = round(diff(date)); % Rounded date differences; these should be close to 1 at minimum
zddate = find(ddate == 0); % Find duplicate dates
keep1 = setdiff(1:length(date), zddate); % Initial keep indices
keep2 = zeros(1, length(zddate));
for i = 1:length(zddate) % For duplicate dates, 
   [~, smu] = min(c{3}([zddate(i), zddate(i)+1])); % Find the minimum uncertainty
   keep2(i) = zddate(i) + smu - 1; % And keep that one for this date
end
keep = sort([keep1(:); keep2(:)]); % Full set of row indices to be retained
date3 = round(date(keep)); % Integer datenums 

% Extract position and error
up = c{2}(keep);
sup = c{3}(keep);

% Make a date vector that encompasses all 3
mind = min([date1(1), date2(1), date3(1)]);
maxd = max([date1(end), date2(end), date3(end)]);
date = mind:maxd;

[~, idx1] = ismember(date1, date);
[~, idx2] = ismember(date2, date);
[~, idx3] = ismember(date3, date);
pos = zeros(size(date));

% Place positions and errors, leaving zeros for missing data
de = pos;
de(idx1) = lon;
se = pos;
se(idx1) = slon;

dn = pos;
dn(idx2) = lat;
sn = pos;
sn(idx2) = slat;

du = pos;
du(idx3) = up;
su = pos;
su(idx3) = sup;

% Set date vector to have zeros where there aren't both horizontal components
date(de == 0 | dn == 0) = 0;
