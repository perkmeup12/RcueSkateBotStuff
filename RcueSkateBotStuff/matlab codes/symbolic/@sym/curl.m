function C = curl(V,varargin)
%CURL Curl of a vector field.
%   C = CURL(V,X) computes the curl of the three dimensional vector field v 
%   with respect to the three dimensional vector x, i.e., the vector with 
%   components dv(3)/dx(2)-dv(2)/dx(3), dv(1)/dx(3)-dv(3)/dx(1) and 
%   dv(2)/dx(1)-dv(1)/dx(2). 
%
%   C = CURL(V) computes the curl of the three dimensional vector field V  
%   with respect to X, where X is determined using symvar(V,3). Note that  
%   an error is raised telling the user to specify a vector with three 
%   variables as second argument if V contains less than three variables. 
%
%   Example:
%       syms x y z; curl([x*y 2*y z], [x y z]) 
%       returns  [0; 0; -x]
%
%       curl([x^2*y 2*y z])
%       returns  [0; 0; -x^2]
%
%   See also SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN, 
%   SYM/JACOBIAN, SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, HESSIAN,
%   JACOBIAN, LAPLACIAN, VECTORPOTENTIAL

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(V,varargin{:});
Vsym = formula(args{1});

if nargin == 2 
    Xsym = formula(args{2});
else
    Xsym = sym([]);
end

if ~isvector(Vsym) || numel(Vsym) ~=3 
    error(message('symbolic:sym:curl:VectorsMustBe3Dimensional'));
end

if isempty(Xsym) 
    Xsym = symvar(Vsym,3);
    if size(Xsym,2) ~= 3 
        error(message('symbolic:sym:curl:UseSecondArgument'));
    end
elseif ~isvector(Xsym) || numel(Xsym) ~= 3 || ~isAllVars(Xsym)
    error(message('symbolic:sym:curl:SecondArgumentMustBeVectorOfVariables'));
end

res = privBinaryOp(Vsym,Xsym,'symobj::curl');

if isa(V,'symfun')
    C = symfun(rewriteToD(res), argnames(V));
else 
    C = res;
end

