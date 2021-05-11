function sf = pangaspatialfilter(s, sc, vc)
% pangaspatialfilter   Filters PANGA time series structure.
%   sf = pangaspatialfilter(s, sc, vc) filters the PANGA time series
%   structure contained in s based on two categories of spatial 
%   filter: First, all stations that lie outside a 1-degree
%   buffer around the surface projection of the Juan de Fuca
%   slab from 0--50 km depth are discarded. These buffer coordinates
%   are given as the n-by-2 array sc. 
%
%   Second, all stations within 25 km of an active volcano, whose
%   coordinates are given in the m-by-2 arrays vc, are discarded.
%
%   The new structure is returned to sf.
%

keep = true(size(s.srefe));

% Filter structure based on slab proximity
in = inpolygon(s.srefe, s.srefn, sc(:, 1), sc(:, 2));
keep(~in) = false;

% Filter structure based on volcano proximity
for i = 1:size(vc, 1)
   vdist = distance(s.srefn, s.srefe, vc(i, 2), vc(i, 1), almanac('earth', 'ellipsoid', 'kilometers'));
   keep(vdist < 25) = false;
end

sf = structsubset(s, keep);