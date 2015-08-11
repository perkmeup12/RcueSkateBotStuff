function D = divergence(V,X)
%DIVERGENCE of a vector field.
%   D = DIVERGENCE(V,X) computes the divergence of the vector field v with
%   respect to the vector x, i.e., the scalar quantity dv(1)/dx(1) + 
%   dv(2)/dx(2) + ... + dv(n)/dx(n).  
%
%   Example:
%       syms x y z; divergence([x^2 2*y z], [x y z]) 
%       returns  2*x + 3
%
%   See also SYM/CURL, SYM/DIFF, SYM/GRADIENT, SYM/HESSIAN, SYM/JACOBIAN,
%   SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, HESSIAN, JACOBIAN,
%   LAPLACIAN, VECTORPOTENTIAL

%   Copyright 2011-2013 The MathWorks, Inc.

args = privResolveArgs(V, X);
Vsym = formula(args{1});
Xsym = formula(args{2});

if ~isvector(Vsym) || ~isvector(Xsym) 
    error(message('symbolic:sym:divergence:ArgumentsMustBeScalarsOrVectors'));
end

if ~isAllVars(Xsym)
    error(message('symbolic:sym:divergence:secondArgumentMustBeVectorOfVariables'));
end   

if numel(Vsym) ~= numel(Xsym) 
    error(message('symbolic:sym:divergence:vectorMustHaveSameDimension')); 
end

res = mupadmex('symobj::divergence', Vsym.s, Xsym.s);

if isa(V,'symfun')
    D = symfun(rewriteToD(res), argnames(V));
else 
    D = res;
end
