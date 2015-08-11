function G = gradient(f,varargin)
%GRADIENT gradient.
%   G = GRADIENT(f,x) computes the gradient of the scalar f with respect
%   to the vector x. Note that scalar x is allowed although this 
%   is just DIFF(f,x).
%
%   Example:
%       syms x y z; gradient(x*y + 2*z*x, [x, y, z])
%       returns  [y + 2*z; x; 2*x]
%
%   See also SYM/CURL, SYM/DIFF, SYM/HESSIAN, SYM/JACOBIAN, SYM/POTENTIAL, 
%   CURL, DIVERGENCE, HESSIAN, GRADIENT, JACOBIAN, LAPLACIAN, 
%   VECTORPOTENTIAL

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(f,varargin{:});
fsym = formula(args{1});

if nargin == 1
    if isa(f,'symfun')
        xsym = argnames(f);
    else
        xsym = symvar(f);
    end
else 
    xsym = formula(args{2});
end

if ~isvector(xsym) || ~isAllVars(xsym)
    error(message('symbolic:sym:gradient:SecondArgumentMustBeVectorOfVariables'));
end  

if ~isscalar(fsym)
    error(message('symbolic:sym:gradient:FirstArgumentMustBeScalar'));
end

res = mupadmex('symobj::gradient',fsym.s,xsym.s);

if isa(f,'symfun')
    G = symfun(rewriteToD(res), argnames(f));
else 
    G = res;
end