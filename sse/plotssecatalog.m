function plotssecatalog(s, trem)

% Redefine some variable names
s.srefn = s.lat;
spikebeg = s.daterange(:, 1)';
spikeend = s.daterange(:, 2)';
spikedur = spikeend - spikebeg;
spikeday = spikebeg + round(spikedur/2);
fulldate = max(s.date);
[ns, nd] = size(s.date);
issse = s.sselogical;

% Visualize
figure
[~, latsort] = sort(s.srefn, 'descend');
% Event ranges
patch([spikebeg; spikeend; spikeend; spikebeg], repmat([min(s.srefn)-0.1; min(s.srefn)-0.1; max(s.srefn)+0.1; max(s.srefn)+0.1], size(spikeday)), [1 0.8 0.8], 'edgecolor', 'none');

hold on

% Gray dots for tremor
thisgray = 0.65*[1 1 1];
plot(trem.date, trem.lat, 'o', 'MarkerFaceColor', thisgray, 'MarkerSize', 1.2, 'MarkerEdgeColor', 'none')

plotdate = repmat(fulldate, ns, 1);
plotlat = s.srefn(latsort); plotlat = repmat(plotlat, 1, nd);
% Black dots indicating detections
plot(plotdate(issse(latsort, :)), plotlat(issse(latsort, :)), '.k', 'markersize', 1)
colormap(flipud(gray))
% Middle of each event
line(([spikeday; spikeday]), repmat([min(s.srefn)-0.1; max(s.srefn)+0.1], size(spikeday)), 'color', 'r')


xlabel('Date'); ylabel('Latitude')
% Axis limits
axis([min(fulldate(fulldate ~= 0)), max(fulldate(fulldate ~= 0)), min(s.srefn)-0.1, max(s.srefn)+0.1])
% Show x-axis as years
datetick('x', 'yy', 'keeplimits')