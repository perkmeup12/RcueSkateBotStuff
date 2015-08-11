function L = laplacian(f,varargin)
%LAPLACIAN of a function.
%   L = LAPLACIAN(f,x) computes the Laplacian the function f with respect
%   to the vector x, i.e. the scalar quantity d^2f/dx(1)^2 + d^2f/dx(2)^2 +
%   ... + d^2f/dx(n)^2.
%
%   L = LAPLACIAN(f) computes the Laplacian of the function f with respect
%   to the vector x = symvar(f). If f is a SYMFUN then x = argnames(f)
%   will be used.
%
%   Examples:
%       syms x y z;
%       laplacian(1/x + y^2 + z^3, [x y z])
%       returns  6*z + 2/x^3 + 2
%
%       laplacian(1/x^3 + y^2)
%       returns  12/x^5 + 2
%
%   See also SYM/CURL, SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN,
%   SYM/JACOBIAN, SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, HESSIAN,
%   JACOBIAN, VECTORPOTENTIAL, SUBS.

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(f,varargin{:});
Fsym = formula(args{1});

if nargin == 1
    if isa(f,'symfun')
        Xsym = argnames(f);
    else
        Xsym = symvar(Fsym);
    end
else 
    Xsym = formula(args{2});
end

if ~isvector(Xsym) || ~isAllVars(Xsym)
    error(message('symbolic:sym:laplacian:SecondArgumentMustBeVectorOfVariables'));
end  
if ~isscalar(Fsym) 
    error(message('symbolic:sym:laplacian:FirstArgumentMustBeScalar'));
end

res = privBinaryOp(Fsym,Xsym,'symobj::laplacian');

if isa(f,'symfun')
    L = symfun(rewriteToD(res), argnames(f));
else
    L = res;
end

