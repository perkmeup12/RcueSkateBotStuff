function r = cumprod(varargin)
%CUMPROD   Symbolic cumulative product of elements.
%   For vectors, CUMPROD(X) is a vector containing the cumulative product
%   of the elements of SYM X.  For matrices, CUMPROD(X) is a matrix the 
%   same size as X containing the cumulative products over each column.  
%
%   CUMPROD(X,DIM) works along the dimension DIM.
%
%   Example: 
%     X = sym([0, 1, 2; 3, 4, 5]);
%
%     r = cumprod(X)  
%     returns  r = [0, 1, 2; 0, 4, 10]
%
%     r = cumprod(X,2) 
%     returns  r = [0, 0, 0; 3, 12, 60]
%
%     syms x y; 
%     X = [x, 2*x+1, 3*x+2; 1/y, y, 2*y];
%  
%     r = cumprod(X)
%     returns r = [x, 2*x+1, 3*x+2; x/y, y*(2*x+1), 2*y*(3*x+2)]
%
%     r = cumprod(X,2) 
%     returns r = [x, x*(2*x+1), x*(2*x+1)*(3*x+2); 1/y, 1, 2*y]
%
%   See also CUMSUM, PROD, SUM, SYMPROD, SYMSUM, SYM/INT. 
 
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

r = mupadmex('symobj::cumsumprod',A.s,dim.s,'_mult');
r = privResolveOutput(r,args{1});