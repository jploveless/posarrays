function sn = structsubsetcols(s, idx, except)
% STRUCTSUBSETCOLS   Returns a subset of the columns of structure fields
%    SNEW = STRUCTSUBSETCOLS(S, I) returns a subset of the columns of 
%    fields of structure S. The subset is identified by the 1-by-m logical
%    vector IDX, which contains true values for columns that should be 
%    retained. Fields of S with width m will be trimmed; fields with a 
%    width different from m will not be modified.  
%

f = fieldnames(s);
if ~exist('except', 'var')
   except = {};
end   
f = setdiff(f, except);
sn = s;
for i = 1:length(f)
   d = getfield(s, f{i});
   if ismatrix(d)
      if size(d, 2) == length(idx)
         d = d(:, idx);
      end
   end
   sn = setfield(sn, f{i}, d);
end