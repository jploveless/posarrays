function offmat = placepangaoffs(offs, dates)
% placepangaoffs  Places PANGA offsets into an existing date array.
%   offmat = placepangaoffs(offs, dates) places the PANGA offsets in 
%   offs (as returned from readpangaoffs) into a vector of size equal 
%   to that of dates, which a consecutive set of datenum values. The 
%   resulting output, offmat, will be a stepped array with values 
%   from 0 to length(offs).
%

% Convert decimal years to datenums
date = decyear2date(offs);
date = datevec(date); % Convert to datevec
date = datenum(date(:, 1:3)); % Use y, m, d only to convert

% Find placement in dates vector
tf = ismember(dates, date);
offmat = cumsum(tf);