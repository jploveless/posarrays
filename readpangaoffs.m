function offs = readpangaoffs(name)
% readpangaoffs  Reads offset dates from PANGA file.
%   offs = readpangaoffs(name) reads the offset decimal year
%   dates from a station's .lon file, using the station name. 
%   The offsets are returned as a vector of floating point 
%   numbers. 
%

% Construct file name from station name
fname = [name '.lon'];
% Read file as text
fc = fileread(fname);
% Construct regular expression and find
expr = 'OFFSET\s\d+.\d+';
ioff = regexp(fc, expr);
noffs = length(ioff);
offs = zeros(noffs, 1);
% Convert text to numbers
for i = 1:noffs
   offs(i) = str2num(fc(ioff(i)+(7:16)));
end