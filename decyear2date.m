function dn = decyear2date(dy);
% DECYEAR2DATE  Converts a decimal year to DATENUM format.
%    DECYEAR2DATE(DY) converts decimal year values DY to Matlab's
%    DATENUM format.  DY can be any size array.
% 
%    DN = DECYEAR2DATE(DY) returns the DATENUM values to DN.
%

year = floor(dy); % Get integer year
ly = rem(year, 4) == 0; % Find leap year values
dy(ly) = 366*(dy(ly) - year(ly)); % Decimal day (leap years)
dy(~ly) = 365*(dy(~ly) - year(~ly)); % Decimal day (non-leap years)
yd = datenum(year, ones(size(year)), ones(size(year))); % Number of days since 0000
dn = dy + yd; % Total datenum