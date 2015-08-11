function y = reshape(x,varargin)
%RESHAPE Change size of symbolic array.
%    RESHAPE(X,M,N) returns the M-by-N matrix whose elements
%    are taken columnwise from X.  An error results if X does
%    not have M*N elements.
%
%    RESHAPE(X,M,N,P,...) returns an N-D array with the same
%    elements as X but reshaped to have the size M-by-N-by-P-by-...
%    M*N*P*... must be the same as PROD(SIZE(X)).
%
%    RESHAPE(X,[M N P ...]) is the same thing.
%
%    RESHAPE(X,...,[],...) calculates the length of the dimension
%    represented by [], such that the product of the dimensions
%    equals PROD(SIZE(X)). PROD(SIZE(X)) must be evenly divisible
%    by the product of the known dimensions. You can use only one
%    occurrence of [].
%
%    In general, RESHAPE(X,SIZ) returns an N-D array with the same
%    elements as X but reshaped to the size SIZ.  PROD(SIZ) must be
%    the same as PROD(SIZE(X)).
%
%    See also SQUEEZE, SHIFTDIM, COLON.

%   Copyright 2009-2013 The MathWorks, Inc.

xsym = privResolveArgs(x);
x = xsym{1};
    
narginchk(2,inf);
args = varargin;
for k=1:nargin-1
    arg = checkArg(args{k});
    args{k} = arg;
end
ySym = mupadmex('symobj::reshape',x.s,args{:});
y = privResolveOutput(ySym, x);

function arg = checkArg(arg)
    if isempty(arg)
        arg = '#COLON';
    elseif isnumeric(arg)
        if ~all(isreal(arg))
            error(message('symbolic:reshape:BadDim'));
        end
        if isscalar(arg)
            arg = int2str(arg);
        elseif ~isvector(arg) 
            error(message('symbolic:reshape:VectorShape'));
        else
            arg = num2str(arg(:).','%d,');
            arg = ['[' arg(1:end-1) ']'];
        end
    end
