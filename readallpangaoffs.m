function snew = readallpangaoffs(s)
% readallpangaoffs   Wrapper function for reading PANGA 
%                    offsets from position file headers
%
%  snew = readallpangaoffs(s) uses the station name and date
%  information from structure s (fields s.sname and s.sdate, 
%  respectively) to read offset date information from the 
%  headers of position files, using functions readpangaoffs
%  and placepangaoffs. 
%

s.offs = zeros(size(s.sdate)); % Allocate space for offsets
for i = 1:length(s.sname) % For each station,
   if exist(['raw/' panga.sname(i, :) '.lon'])
      offs = readpangaoffs(panga.sname(i, :)); % Read header offsets
      % Place offsets into date array format
      s.offs(i, :) = placepangaoffs(offs, max(panga.sdate, [], 1));
   end
end
