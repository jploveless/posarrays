function y = nzmean(x,dim)
%MEAN   Average or mean value, excluding zeros.
%   For vectors, NZMEAN(X) is the mean value of the elements in X,
%   excluding zero valued entries. For matrices, NZMEAN(X) is a row
%   vector containing the mean value of each column.  For N-D arrays,
%   NZMEAN(X) is the mean value of the elements along the first 
%   non-singleton dimension of X.
%
%   NZMEAN(X,DIM) takes the mean along the dimension DIM of X. 
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   then nzmean(X,1) is [3 2.5 3.5] and mean(X,2) is [1.5
%                                                     4]
%
%   Class support for input X:
%      float: double, single
%
%   See also MEDIAN, STD, MIN, MAX, VAR, COV, MODE.

if nargin==1, 
  % Determine which dimension SUM will use
  dim = min(find(size(x)~=1));
  if isempty(dim), dim = 1; end

  y = sum(x)./max(sum((x~=0),dim), 1);
else
  y = sum(x,dim)./max(sum((x~=0),dim), 1);
end
