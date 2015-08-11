function C = rem(A,B)
%REM    Symbolic remainder after division.
%   REM(x,y) is x - n.*y where n = fix(x./y) if y ~= 0.  If y is not an
%   integer and the quotient x./y is within roundoff error of an integer,
%   then n is that integer. The inputs x and y must be real arrays of the
%   same size, or real scalars.
% 
%   See also MOD, QUOREM.
    
%   Copyright 2009-2011 The MathWorks, Inc.

[~,C] = quorem(A,B);
