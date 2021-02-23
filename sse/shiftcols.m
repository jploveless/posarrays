function B = shiftcols(A, lr)
% shiftcols   Shifts non-zero values of each row to the left or right.
%   shiftcols(A) shifts the non-zero values of each row of A to the 
%   left. 
%
%   B = shiftcols(A) outputs the shifted array to B.
%
%   B = shiftcols(A, LR) allows specification of the shift direction
%   using variable LR. LR = 1 shifts to the left and LR = -1 shifts
%   to the right. 
%

% Set shift direction
if ~exist('lr', 'var')
   lr = 1;
end

% Get matrix size
sa = size(A);

nz = A ~= 0; % Non-zero values of A
snz = sum(nz, 2); % Sum across columns; number of non-zeros in each row
B = zeros(size(A)); % Empty matrix for B

rmat = repmat((1:sa(1))', 1, sa(2)); % Row indices
rmat = rmat(nz); % Retain only those row indices for non-zero values
cmat = cumsum(nz, 2) + (sign(lr) == -1)*sum(~nz, 2); % Column indices
cmat = cmat(nz); % Retain only those column indices for non-zero values

% Convert row and column indices to linear indices
lind = sub2ind(sa, rmat, cmat);

% Place non-zero values of A into appropriate locations of B
B(lind) = A(nz);