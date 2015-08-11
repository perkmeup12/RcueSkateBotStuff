function r = cumsum(varargin)
%CUMSUM   Symbolic cumulative sum of elements.
%   For vectors, CUMSUM(X) is a vector containing the cumulative sum of
%   the elements of SYM X. For matrices, CUMSUM(X) is a matrix the same 
%   size as X containing the cumulative sums over each column.  
%
%   CUMSUM(X,DIM) works along the dimension DIM.
%
%   Examples: 
%     X = sym([0, 1, 2; 3, 4, 5]); 
%
%     r = cumsum(X)
%     returns  r = [ 0, 1, 2; 3, 5, 7]
%
%     r = cumsum(X,2) 
%     returns  r = [ 0, 1, 3; 3, 7, 12]
%
%     syms x y; 
%     X = [x, 2*x+1, 3*x+2; 1/y, y, 2*y];
%  
%     r = cumsum(X)
%     returns r = [x, 2*x+1, 3*x+2; x+1/y, 2*x+y+1, 3*x+2*y+2]
%
%     r = cumsum(X,2) 
%     returns r = [x, 3*x+1, 6*x+3; 1/y, y+1/y, 3*y+1/y]
%
%   See also CUMPROD, PROD, SUM, SYMPROD, SYMSUM, SYM/INT.
 
%   Copyright 2012-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(varargin{:});
A = formula(args{1});

if nargin == 1 
    dim = sym(0);
else
    dim = args{2};
end

if nargin == 2 && strcmp(mupadmex('testtype',dim.s,'Type::PosInt',0),'FALSE')
    error(message('symbolic:sym:cumsumprod:InvalidDimensionFlag'));
end

if length(size(A)) > 2 
    error(message('symbolic:sym:cumsumprod:VectorsAndMatrices'));
end

r = mupadmex('symobj::cumsumprod',A.s,dim.s,'_plus');
r = privResolveOutput(r,args{1});