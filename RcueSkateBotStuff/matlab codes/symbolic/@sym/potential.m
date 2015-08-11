function P = potential(V,X,varargin)
%POTENTIAL of a function.
%   P = POTENTIAL(V,X) computes the potential of vector field V with
%   respect to X. V and X must be vectors of the same dimension. The vector
%   field V must be a gradient field. If the function POTENTIAL cannot
%   verify that V is a gradient field, it returns NaN.
%
%   P = POTENTIAL(V,X,Y) computes the potential of vector field V with
%   respect to X using Y as base point for the integration. If Y is not a
%   scalar, then Y must be of the same dimension as V and X. If Y is
%   scalar, then Y is expanded into a vector of the same size as X with
%   all components equal to Y.
%
%   Examples:
%       syms x y z; potential([x y z*exp(z)], [x y z])
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1).
%
%       syms x0 y0 z0; potential([x y z*exp(z)], [x y z], [x0 y0 z0])
%       returns x^2/2 - x0^2/2 + y^2/2 - y0^2/2 + exp(z)*(z - 1) -
%               exp(z0)*(z0 - 1)
%
%       potential([x y z*exp(z)], [x y z], [1,1,1])
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1) - 1
%
%       potential([x y z*exp(z)], [x y z], 1)
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1) - 1
%
%       potential([y -x], [x y])
%       returns NaN since the potential does not exist.
%
%   See also SYM/DIFF, SYM/JACOBIAN, SYM/GRADIENT, SYM/HESSIAN, SYM/CURL,
%   SYM/DIVERGENCE, SYM/LAPLACIAN, CURL, DIVERGENCE, GRADIENT, HESSIAN,
%   JACOBIAN, SUBS.

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(2,3);
args = privResolveArgs(V,X,varargin{:});
Vsym = formula(args{1});
Xsym = formula(args{2});

if nargin < 3 
    Ysym = sym([]);
else
    Ysym = formula(args{3});
end

if ~isvector(Vsym) 
    error(message('symbolic:sym:potential:FirstArgumentMustBeScalarOrVector'));
end

if ~isvector(Xsym) || ~isAllVars(Xsym)
    error(message('symbolic:sym:potential:SecondArgumentMustBeVectorOfVariables'));
end  

if numel(Vsym) ~= numel(Xsym)
    error(message('symbolic:sym:potential:SameDimension'));
end

if ~isempty(Ysym)
    if numel(Ysym) ~= numel(Xsym) && ~isscalar(Ysym)
        error(message('symbolic:sym:potential:SameDimensionOrScalar'));
    end
    res = privTrinaryOp(Vsym,Xsym,Ysym,'symobj::potential');
else
    res = privBinaryOp(Vsym,Xsym,'symobj::potential');
end

if isa(V,'symfun')
    P = symfun(rewriteToD(res), argnames(V));
else 
    P = res;
end
