function d = det(A)
%DET    Symbolic matrix determinant.
%   DET(A) is the determinant of the symbolic matrix A.
%
%   Examples:
%       det([a b;c d]) is a*d-b*c.

%   Copyright 2013 The MathWorks, Inc.

sz = size(A);
if sz(1)~=sz(2)
    error(message('symbolic:det:SquareMatrix'));
end
d = privUnaryOp(A, 'symobj::det');
end
