function ssetimeseries(sse, corr, i, dname)
% ssetimeseries   Plots raw and corrected position time series
%   ssetimeseries(s, corr, sta, dirname) plots raw and corrected
%   position time series, currently only the east component. Raw
%   position time series are contained in the structure s, as 
%   constructed from pangaarrays.m. corr is a structure of position
%   time series that have been corrected for the effects of slow
%   slip events, using removesse.m. sta specifies the station to 
%   plot, either as a 4-character name or as its row index in the
%   fields of s and corr. dirname is an optional argument giving 
%   the path to a directory in which a PDF copy of the figure 
%   will be exported. If no directory name is given, no PDF is 
%   created. 
%

% Check whether station was specified with a name or index
if ischar(i)
   i = strmatch(i, sse.name);
end

% Preprocessing and identifying subset of dates to plot
cnzdates = corr.date(i, :) ~= 0;
firstday = min(corr.date(i, cnzdates));
[~, firstidx] = ismember(firstday, sse.date(i, :));
%sse.date = sse.date(:, firstidx:end);
%sse.sde = sse.sde(:, firstidx:end);
%sse.sselogical = sse.sselogical(:, firstidx:end);
%sse.score = sse.score(:, firstidx:end);
nzdates = sse.date(i, :) ~= 0; % Get all nonzero dates

% Make figure
figure

subplot(2, 1, 1) % Position plot
plot(corr.date(i, cnzdates), corr.eastpos(i, cnzdates), '.', 'color', 'b')
hold on
plot(sse.date(i, nzdates), sse.sde(i, nzdates), '.k'); % Plot original positions 
plot(sse.date(i, sse.sselogical(i, :)), sse.sde(i, sse.sselogical(i, :)), '.r'); % Highlight SSE detections
% Axis limits
aa1 = [min(sse.date(i, nzdates)), max(sse.date(i, nzdates)), ...
       minmax([minmax(corr.eastpos(i, cnzdates)), minmax(sse.sde(i, nzdates))])];
% Dashed line indicating first day of corrections
line(firstday*[1 1], aa1(3:4), 'color', 'b', 'linestyle', '--'); % Line showing score threshold
% Tighten axis
axis(aa1)
% Plot title
title(sse.name(i, :))
% Show x-axis as years
datetick('x', 'yy', 'keeplimits')

subplot(2, 1, 2) % Score plot
axx = get(gcf, 'children');
plot(sse.date(i, nzdates), sse.score(i, nzdates), '.k') % Plot scores (daily velocities, mm/day)
hold on
aa2 = axis;
plot(sse.date(i, sse.sselogical(i, :)), sse.score(i, sse.sselogical(i, :)), '.r'); % Highlight SSE detections 
% Set x-axis limits to same as position plot
axis([aa1(1:2), aa2(3:4)])
line(axx(1).XLim, sse.scorethresh(i)*[1 1], 'color', 'r', 'linestyle', '--'); % Line showing score threshold
datetick('x', 'yy', 'keeplimits')

% Axis labeling, etc.

ylabel(axx(2), 'East position (mm)')
ylabel(axx(1), 'Daily velocity (mm/day)')
xlabel(axx(1), 'Year')
set(gcf, 'position', [30 607, 1000, 1000]); % Adjusted figure position
axx(1).Position = [axx(1).Position(1:3), 0.25];
axx(2).Position = [axx(2).Position(1), 0.38, axx(2).Position(3), 0.5];
axx(2).XTickLabel = [];

set(gcf, 'color', [1 1 1])
prepfigprint

% Print figure to PDF if a directory name was specified
if exist('dname', 'var')
   if ~isempty(which('export_fig'))
      export_fig(gcf, sprintf('%s/%s.pdf', dname, s.s.sname(i, :)), '-painters');
   else 
      print(gcf, sprintf('%s/%s.pdf', dname, s.s.sname(i, :)), '-dpdf', '-painters');    
   end      
end
