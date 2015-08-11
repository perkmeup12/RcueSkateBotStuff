function H = hessian(f,varargin)
%HESSIAN Hessian matrix.
%   HESSIAN(f,x) computes the Hessian of the scalar f with respect
%   to the vector x. The (i,j)-th entry of the resulting matrix is
%   (d^2f/(dx(i)dx(j)). Note that scalar x is allowed although this
%   is just DIFF(f,x,2).
%
%   Example:
%       syms x y z; hessian(x*y + 2*z*x, [x, y, z])
%       returns  [0, 1, 2; 1, 0, 0; 2, 0, 0]
%
%   See also SYM/CURL, SYM/DIFF, SYM/GRADIENT, SYM/JACOBIAN, SYM/DIVERGENCE,
%   SYM/POTENTIAL, CURL, DIVERGENCE, HESSIAN, JACOBIAN, LAPLACIAN,
%   VECTORPOTENTIAL, SUBS.

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
    error(message('symbolic:sym:hessian:SecondArgumentMustBeVectorOfVariables'));
end  

if ~isscalar(fsym)
    error(message('symbolic:sym:hessian:FirstArgumentMustBeScalar'));
end

res = mupadmex('symobj::hessian',fsym.s,xsym.s);

if isa(f,'symfun')
    H = symfun(rewriteToD(res), argnames(f));
else
    H = res;
end
