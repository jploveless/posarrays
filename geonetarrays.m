function posarrays(posdir, outfile, varargin)
% POSARRAYS  Reads .pos files and places the data into large arrays.
%    POSARRAYS(DIREC, OUTFILE) reads .pos position files from DIREC (or
%    its subdirectories) and places the data into a structure containing
%    large arrays, which is written to the output .mat OUTFILE.  DIREC 
%    can be a master directory containing yearly directories of .pos files,
%    or it can be one of the yearly folders itself.  The arrays will be sized
%    dynamically, such that the maximum size is nStations-by-nDays. Zeros 
%    indicate a day of no data collection on that day.
%

maxSta = 1500;
dayOne = datenum(1994, 1, 1); % some arbitrarily early date

% Get files or directories
contents = dir(posdir);

if strmatch(contents(1).name, '.DS_Store')
   contents(1) = [];
end
id = [contents.isdir];
if sum(id) > 0 % If there are subdirectories...
   if strmatch(contents(1).name, '..')
      id(1) = false;
   end
   contents = contents(id); % just keep the directories
   numDir = numel(contents); % ...we have that many directories to search
else
   numDir = 1; % Otherwise, we have one directory...
   clear contents
   contents(1).name = posdir; % ...and it's the specified directory
   posdir = '.'; % blank the input name, for use later
end

% Determine the maximum number of possible columns
maxObs = ceil((str2num(contents(end).name) - 1994 + 1)*365.25);

% Allocate space for each array
sname = char(zeros(maxSta, 6));
[syear, smonth, sday, sdate,...
 sx, sy, sz,...
 slon, slat, shgt] = deal(zeros(maxSta, maxObs));

% Get the .pos files from each directory
sname = char(zeros(0, 6));
file = char(zeros(0, 100));
for (i = 1:numDir)
   files = dir([posdir filesep contents(i).name filesep '*.pos']);
   names = char(files.name);
   five = strfind(names(:, 6)', '.');
   six = setdiff(1:size(names, 1), five);
   file = strvcat(file, [repmat([posdir filesep contents(i).name filesep], numel(files), 1) [names(five, :); names(six, :)]]);
   sname = strvcat(sname, names(five, 1:5), names(six, 1:6));
end
[sname, junk, staIdx] = unique(sname, 'rows');

badfiles = '';
% Read all files
for (i = 1:numel(staIdx))
   [year, month, day, hour, x, y, z, lat, lon, hgt] = ReadPosFile(strtrim(file(i, :)));
   if ~isempty(year)
      col = datenum(year(:), month(:), day(:)) - dayOne + 1; % Column into which data should be placed
      row = staIdx(i);
      syear(row, col) = year';
      smonth(row, col) = month';
      sday(row, col) = day';
      sdate(row, col) = datenum(year', month', day');
      sx(row, col) = x';
      sy(row, col) = y';
      sz(row, col) = z';
      slon(row, col) = lon';
      slat(row, col) = lat';
      shgt(row, col) = hgt';
   else
      badfiles = strvcat(badfiles, strtrim(file(i, :)));
   end
end


% Trim the arrays
firstCol = find(sum(syear, 1), 1); % First appearance of any date
lastCol  = find(sum(syear, 1), 1, 'last'); % Last appearance of any date
syear    = syear(1:size(sname, 1), firstCol:lastCol); % Going for all rows that correspond to unique stations
smonth   = smonth(1:size(sname, 1), firstCol:lastCol);
sday     = sday(1:size(sname, 1), firstCol:lastCol);
sdate    = sdate(1:size(sname, 1), firstCol:lastCol);
sx       = sx(1:size(sname, 1), firstCol:lastCol);
sy       = sy(1:size(sname, 1), firstCol:lastCol);
sz       = sz(1:size(sname, 1), firstCol:lastCol);
slon     = slon(1:size(sname, 1), firstCol:lastCol);
slat     = slat(1:size(sname, 1), firstCol:lastCol);
shgt     = shgt(1:size(sname, 1), firstCol:lastCol); 

save(outfile, 'sdate', 'sday', 'shgt', 'slat', 'slon', 'smonth', 'sname', 'sx', 'sy', 'sz', 'syear');

% Subfunction to read data from .pos files
function [year, month, day, hour...
          x, y, z, ...
          lat, lon, hgt]            = ReadPosFile(fileName)
data                                = char(textread(fileName, '%s', 'delimiter', '\n', 'headerlines', 20));
if ~isempty(data)
data                                = data(1:end-2, :);
data(:, [14 17])                    = []; % get rid of hour colons
data                                = str2num(data);
if size(data, 2) ~= 10
   keyboard
end
year                                = data(:, 1);
month                               = data(:, 2);
day                                 = data(:, 3);
hour                                = data(:, 4);
x                                   = data(:, 5);
y                                   = data(:, 6);
z                                   = data(:, 7);
lat                                 = data(:, 8);
lon                                 = data(:, 9);
hgt                                 = data(:, 10);
else
   [year, month, day, hour...
    x, y, z, ...
    lat, lon, hgt]                  = deal([]);
end