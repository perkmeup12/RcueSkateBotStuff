function [U,S,V] = svd(A,varargin)
%SVD    Symbolic singular value decomposition.
%   With one output argument, SIGMA = SVD(A) is a symbolic vector 
%   containing the singular values of a symbolic matrix A.
%
%   With three output arguments, [U,S,V] = SVD(A) returns numeric unitary 
%   matrices U and V whose columns are the singular vectors and a diagonal 
%   matrix S containing the singular values.  Together, they satisfy
%   A = U*S*V'.  The singular vector computation uses variable precision
%   arithmetic and requires the input matrix to be numeric. Symbolic 
%   singular vectors are not available.
%
%   [U,S,V] = SVD(X,0) produces the "economy size"
%   decomposition. If X is m-by-n with m > n, then only the
%   first n columns of U are computed and S is n-by-n.
%   For m <= n, SVD(X,0) is equivalent to SVD(X).
%
%   [U,S,V] = SVD(X,'econ') also produces the "economy size"
%   decomposition. If X is m-by-n with m >= n, then it is
%   equivalent to SVD(X,0). For m < n, only the first m columns 
%   of V are computed and S is m-by-m.
%
%   NOTE:   The use of second arguments for producing "economy 
%   size" decompositions only influences the shape of the matrices 
%   returned as results. The options do not affect the performance 
%   of the computations.
%
%   Examples:
%      A = sym(magic(4))
%      svd(A)
%      svd(vpa(A))
%      [U,S,V] = svd(A)
%
%      syms t real
%      A = [0 1; -1 0]
%      E = expm(t*A)
%      sigma = svd(E)
%      simplify(sigma)
%
%      A = sym([1 1;2 2; 2 2]);
%      B = A';
%      [U,S,V] = svd(A,0)      
%      [U,S,V] = svd(B,'econ')      
%
%   See also SVD, SYM/EIG, SYM/VPA.
  
%   Copyright 1993-2012 The MathWorks, Inc.

if nargin > 2 
    error(message('symbolic:sym:svd:TooManyInputArguments'));
end

p = inputParser;

p.addRequired('A', @(x) isa(A,'sym')); 
p.addOptional('opt', sym([]), @(x) ~isempty(x));  
p.parse(A,varargin{:});
A = p.Results.A;
opt = p.Results.opt;
                                 
if ~isempty(opt) 
    if ischar(opt) && strcmpi(opt,'econ') 
        opt = '"econ"';
    elseif (isnumeric(opt) && opt==0)     
        opt = '"0"';        
    else 
        error(message('symbolic:sym:svd:InvalidSecondArgument')) 
    end
end

Asym = privResolveArgs(A);
Asym = Asym{1};

if any(any(~isfinite(Asym)))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargout == 3 && strcmp(mupadmex('symobj::isfloatable',Asym.s,0),'FALSE') 
    error(message('symbolic:sym:svd:InputsMustBeConvertibleToFloatingPointNumbers'));
end   

if nargout < 2
    if ~isempty(Asym) 
        Usym = mupadmex('symobj::svdvals',Asym.s);
        U = privResolveOutput(Usym, A);
    else
        U = sym([]);
    end
else
    if ~isempty(Asym) 
        [Usym,Ssym,Vsym] = mupadmexnout('symobj::svdvecs',Asym,opt);
        U = privResolveOutput(Usym, A);
        S = privResolveOutput(Ssym, A);
        V = privResolveOutput(Vsym, A);
    else
        U = sym([]);
        S = sym([]);
        V = sym([]);
    end
end
