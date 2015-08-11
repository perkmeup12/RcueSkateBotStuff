function J = jacobian(F,varargin)
%JACOBIAN Jacobian matrix.
%   JACOBIAN(f,v) computes the Jacobian of the scalar or vector f
%   with respect to the vector v. The (i,j)-th entry of the result
%   is df(i)/dv(j). Note that when f is scalar, the Jacobian of f
%   is the gradient of f. Also, note that scalar v is allowed,
%   although this is just DIFF(f,v).
%
%   Example:
%       syms x y z u v; jacobian([x*y*z; y; x+z],[x y z])
%       returns  [y*z, x*z, x*y; 0, 1, 0; 1, 0, 1] 
%
%       jacobian(u*exp(v),[u;v])
%       returns  [exp(v), u*exp(v)]
%
%   See also SYM/CURL, SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN,
%   SYM/POTENTIAL, CURL, DIVERGENCE, HESSIAN, LAPLACIAN, VECTORPOTENTIAL,
%   SUBS.

%   Copyright 1993-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(F,varargin{:});
Fsym = formula(args{1});

if nargin == 1
    if isa(F,'symfun')
        Xsym = argnames(F);
    else
        Xsym = symvar(Fsym);
    end
else 
    if isempty(varargin{1})
       J = sym([]);
       if isa(F,'symfun')
         J = symfun(rewriteToD(J), argnames(F));
       end
       return;
    end
    Xsym = formula(args{2});
end

if ~isvector(Xsym) || ~isAllVars(Xsym)
    error(message('symbolic:sym:jacobian:SecondArgumentMustBeVectorOfVariables'));
end  

if ~isvector(Fsym) 
    error(message('symbolic:sym:jacobian:FirstArgumentMustBeScalarOrVector'));
end

res = mupadmex('symobj::jacobian',Fsym.s,Xsym.s);

if isa(F,'symfun')
    J = symfun(rewriteToD(res), argnames(F));
else 
    J = res;
end
