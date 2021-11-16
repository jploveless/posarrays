function prepfigprint(fig)
% PREPFIGPRINT  Prepares a figure for printing.
%   PREPFIGPRINT(FIG) prepares figure number FIG for printing.  
%

if ~exist('fig', 'var')
   fig = gcf;
end

fs = 12; % font size
lw = 1; % line width
tl = [0.008 0.008]; % tick length

aa = findobj(fig, 'type', 'axes');

for i = 1:length(aa)
   set(aa(i), 'fontsize', fs, 'linewidth', lw, 'ticklength', tl, 'layer', 'top', 'box', 'on');
   cc = findobj(aa(i), '-not', {'type', 'image', '-or', 'type', 'patch'});
%   set(cc, 'linewidth', lw);
end

set(fig, 'paperpositionmode', 'auto')