function mat = offvecmat(vec)
% offvecmat  Converts an offset index vector to matrix.
%   mat = offvecmat(vec) converts the offset index vector, vec,
%   to a matrix, mat. vec is a length(m), one-dimensional vector with 
%   values 0:n, and mat is an m-by-n matrix with values of 0 and 1. 
%   As an example, 
%   vec = [0 0 1 1 2 2 2 3]
%   is converted to
%   mat = [0 0 1 1 1 1 1 1;
%          0 0 0 0 1 1 1 1;
%          0 0 0 0 0 0 0 1]
%

% Find vector size
[m, n] = size(vec);
% Allocate space for matrix
mat = zeros(m*n, max(vec));

% Find jumps in vector
dvec = [0 diff(vec(:)')];
jump = find(dvec == 1);
for i = 1:length(jump)
   mat(jump(i):end, i) = 1;
end   
   
if m < n % vec is a row vector
   mat = mat';
end