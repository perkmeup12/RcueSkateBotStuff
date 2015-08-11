function [X,Y,Z] = chol(A,varargin)
% chol   Cholesky factorization.
%   R = chol(A) produces an upper triangular R so that R'*R = A if A is 
%   a Hermitian positive definite matrix. If A is not Hermitian positive 
%   definite, an error message is printed.
% 
%   R = chol(A,'upper') returns the same result as R = chol(A). 
% 
%   L = chol(A,'lower') returns a lower triangular matrix L so that 
%   L*L' = A. If A is not Hermitian positive definite, an error message  
%   is printed. 
%
%   [R,p] = chol(A), with two output arguments, does not error if A 
%   is not Hermitian positive definite. If A is Hermitian positive 
%   definite or option 'noCheck' is used, then p = 0 is returned. If A 
%   is not recognized to be Hermitian positive definite, then p is a 
%   positive integer and R is an upper triangular matrix of order q = p-1 
%   so that R'*R = A(1:q,1:q).  
%
%   [L,p] = chol(A,'lower'), works as described above, only a lower
%   triangular matrix L is produced. 
% 
%   [R,p,S] = chol(A) returns a permutation matrix S such that R'*R = 
%   S'*A*S, when p = 0. If p is a positive integer (i.e., A is not 
%   recognized to be Hermitian positive definite), S = sym([]) is 
%   returned. 
% 
%   [R,p,s] = chol(A,'vector') returns the permutation information as
%   a vector s such that A(s,s) = R'*R, when p = 0. If p is a positive 
%   integer (i.e., A is not recognized to be Hermitian positive definite), 
%   s = sym([]) is returned. The flag 'matrix' may be used in place of 
%   'vector' to obtain the default behavior.
% 
%   [L,p,s] = chol(A,'lower','vector') returns a lower triangular 
%   matrix L and a permutation vector s such that A(s,s) = L*L', 
%   when p = 0. If p is a positive integer (i.e., A is not recognized to
%   be Hermitian positive definite), s = sym([]) is returned. As above, 
%   'matrix' may be used in place of 'vector' to obtain a permutation 
%   matrix. 
%
%   R = chol(A,'noCheck') does not check whether A is Hermitian 
%   positive definite at all. This option can be useful when A has 
%   components containing symbolic parameters. In order to avoid having 
%   to set all kind of assumptions to make SYM/CHOL realize that A is 
%   Hermitian positive definite for all values of the parameters, 
%   option 'noCheck' can be used. Note that when using option 'noCheck' 
%   the identity R'*R = A may no longer hold if A is not Hermitian  
%   positive definite! 
%
%   R = chol(A,'real') uses real arithmetic. This option can be useful 
%   when A has components containing symbolic parameters. In order to 
%   avoid having to set all kind of assumptions to avoid complex 
%   conjugates, option 'real' can be used. 
%   The matrix A must either be symmetric or option 'noCheck' has to be 
%   used additionally. Note that when using option 'real', the identity 
%   R'*R = A in general will only hold for real symmetric positive 
%   definite A. 
% 
%   See also CHOL, SYM/LU, SYM/SVD, SYM/EIG, SYM/VPA, ASSUME, 
%   ASSUMEALSO.   
 
%   Copyright 1993-2012 The MathWorks, Inc.

if ~isa(A,'sym') 
    error(message('symbolic:sym:chol:FirstArgumentMustBeSYM'));
end

for i = 1:nargin-1
    if ~ischar(varargin{i}) || ... 
            ~any(strcmpi(varargin{i},{'lower','upper','vector',...
                                      'matrix','noCheck','real'}))
        error(message('symbolic:sym:chol:InvalidArgument'));
    end
end

options = 'null()';

if any(strcmpi('lower',varargin))
    options = [options ',"lower"'];
end

if any(strcmpi('lower',varargin)) && any(strcmpi('upper',varargin))
    error(message('symbolic:sym:chol:StringUpperOrLowerExpected'));
end

if any(strcmpi('vector',varargin)) && any(strcmpi('matrix',varargin))
    error(message('symbolic:sym:chol:StringVectorOrMatrixExpected'));
end

if any(strcmpi('vector',varargin))
    if nargout < 3 
        error(message('symbolic:sym:chol:VectorOnlySupportedInCaseOfThreeOutputs'));
    else
        options = [options ',"vector"'];
    end
end

if any(strcmpi('matrix',varargin))
    if nargout < 3 
        error(message('symbolic:sym:chol:MatrixOnlySupportedInCaseOfThreeOutputs'));
    else
        options = [options ',"matrix"'];    
    end
end

if any(strcmpi('noCheck',varargin))
    options = [options ',"noCheck"'];
end

if any(strcmpi('real',varargin))
    options = [options ',"real"'];
end

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end

sz = size(A);
if sz(1)~=sz(2)
    error(message('symbolic:sym:chol:MatrixMustBeSquare'));
end

if any(any(~isfinite(A)))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if isempty(A)
    X = sym([]);
    Y = sym([]);
    Z = sym([]);
    return;
else    
    [X,Y,Z] = mupadmexnout('symobj::chol',A,options);
    X = privResolveOutput(X,A);
    Y = privResolveOutput(Y,A);
    Z = privResolveOutput(Z,A);
    if nargout < 2 && Y == 1 && ~any(strcmpi('noCheck',varargin))
        error(message('symbolic:sym:chol:MatrixNotHermitianPositiveDefinite'));
    end
end
