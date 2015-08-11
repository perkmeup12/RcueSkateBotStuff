function [X,R] = linsolve(A,B)
% linsolve Solve linear system A*X=B.
%   X = linsolve(A,B) solves the linear system A*X=B. 
% 
%   [X, R] = linsolve(A,B) solves the linear system A*X=B and returns R
%   the reciprocal of the condition number of A for square matrices,
%   and the rank of A if A is rectangular. 
%
%  Examples:
%  
%  syms a x y z;
%
%  A = [cos(a) 0 sin(a); 0 1 0; -sin(a) 0 cos(a)];
%  b = [x; y; z];
%  
%  X = linsolve(A,b)
%  [X,R] = linsolve(A,b)
%
%  A = [cos(a) 0 sin(a) 0; 0 1 0 0; -sin(a) 0 cos(a) 0];
%  [X,R] = linsolve(A,b)
% 
%  A = [x 2*x y; x*z 2*x*z y*z+z; 1 0 1]; 
%  B = [z y; z^2 y*z; 0 0];
%
%  X = linsolve(A,B) 
%  [X,R] = linsolve(A,B)
%
%   See also SYM/MLDIVIDE, SYM/SLASH, SYM/NULL, SYM/RANK.

%   Copyright 2011 The MathWorks, Inc.

p = inputParser;

p.addRequired('A'); 
p.addRequired('B'); 

p.parse(A,B);

A = p.Results.A;
B = p.Results.B;

if ~isa(A,'sym'), A = sym(A); end
if ~isa(B,'sym'), B = sym(B); end

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
if builtin('numel',B) ~= 1,  B = normalizesym(B);  end

if size(A,1)~=size(B,1) 
    error(message('symbolic:sym:linsolve:incompatibleDimensions'));
end

if ismatrix(A) && ismatrix(B)
    % for non-2D objects, error below
    if any(any(~isfinite(A))) || any(any(~isfinite(B)))
        error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
    end
end

if isempty(A) && isempty(B) 
    if nargout == 1 
        X = sym([]);
    elseif nargout == 2 
        X = sym([]);
        R = sym(Inf);
    end
else
    X = privBinaryOp(A,B,'symobj::mldivide');                    
    if nargout == 2 
        if size(A,1) == size(A,2) 
            R = 1/cond(A,1);
        else 
            R = privUnaryOp(A,'linalg::rank');                     
        end
   end
end




