function P = vectorPotential(V,varargin)
%VECTORPOTENTIAL of a function.
%   P = vectorPotential(V,X) computes the vector potential of the 
%   three-dimensional vector field V with respect to the vector X. 
%   The vector potential exists if and only if the divergence of 
%   V with respect to X is equal to zero. If the function vectorPotential 
%   cannot verify that V has a vector potential, it returns the vector 
%   with all three components equal to NaN.  
% 
%   P = vectorPotential(V) computes the vector potential of the 
%   three-dimensional vector field V with respect to X, where X is 
%   determined using symvar(V,3). Note that an error is raised telling 
%   the user to specify a vector with three variables as second argument 
%   if V contains less than three variables. 
%
%   Examples:
%       syms x y z; vectorPotential([x^2*y, -1/2*y^2*x, -x*y*z], [x y z]) 
%       returns [-(x*y^2*z)/2; -x^2*y*z; 0].  
%
%       vectorPotential([2*y^3-4*x*y; 2*y^2-16*z^2+18; -32*x^2-16*x*y^2])
%       returns [(2*z*(3*y^2-8*z^2+27))/3+(16*x*y*(y^2+6*x))/3; ...
%                 2*y*z*(2*x-y^2); 0]
%
%       vectorPotential([x^2, 2*y, z], [x y z]) 
%       returns [NaN NaN NaN]. 
%
%   See also SYM/CURL, SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN, 
%   SYM/JACOBIAN, SYM/LAPLACIAN, SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, 
%   HESSIAN, JACOBIAN 

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(1,2);
args = privResolveArgs(V,varargin{:});
Vsym = formula(args{1});

if nargin == 2 
    Xsym = formula(args{2});
else
    Xsym = sym([]);
end

if ~isvector(Vsym) || numel(Vsym) ~= 3  
    error(message('symbolic:sym:vectorPotential:VectorsMustBe3Dimensional')); 
end

if isempty(Xsym) 
    Xsym = symvar(Vsym,3);
    if size(Xsym,2) ~= 3 
        error(message('symbolic:sym:vectorPotential:UseSecondArgument'));
    end
elseif ~isvector(Xsym) || numel(Xsym) ~= 3 || ~isAllVars(Xsym) 
    error(message('symbolic:sym:vectorPotential:SecondArgumentMustBeVectorOfThreeVariables'));
end

res = privBinaryOp(Vsym,Xsym,'symobj::vectorPotential');

if isa(V,'symfun')
    P = symfun(rewriteToD(res), argnames(V));
else
    P = res;
end

