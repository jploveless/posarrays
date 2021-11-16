function offs = detectoffs(s, sdm)
% detectoffs   Detects additional offsets in time series
%   offs = detectoffs(s, sdm) detects additional offsets in 
%   PANGA time series, given in structure s, which includes
%   position fields sde and sdn. New offsets are based on daily jumps
%   that exceed a specified multiple of standard deviations, sdm.
%

% Array sizes
[ns, nd] = size(s.sdate);
nzdates = s.sdate ~= 0;
fulldates = max(s.sdate);

% Allocate space
steps = zeros(ns, nd);
offs = steps;

% Loop through stations
for i = 1:ns
   ipt = findchangepts(s.sde(i, nzdates(i, :)), 'Statistic','std','MinThreshold',1200);
   ipt2 = findchangepts(s.sdn(i, nzdates(i, :)), 'Statistic','std','MinThreshold',1200);
   ipt = sort(unique([ipt, ipt2]));
   thesedates = s.sdate(i, nzdates(i, :));
   [~, idx] = ismember(thesedates(ipt), fulldates);
   steps(i, idx) = 1;
%   offs(i, :) = cumsum(steps(i, :));
  
%  Combine with existing offsets    
   osteps = [0 diff(s.offs(i, :))]; % Steps from offset array
   csteps = max([osteps; steps(i, :)], [], 1); % Combined offsets
   offs(i, :) = cumsum(csteps);
%   i
%   max(offs(i, :))

end