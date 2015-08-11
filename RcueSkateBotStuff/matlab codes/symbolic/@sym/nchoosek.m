function c = nchoosek(n,k)
%NCHOOSEK Binomial coefficient for symbolic arguments N,K.
%    NCHOOSEK(N,K) returns N!/K!(N-K)!. N and K must be scalars.

%   Copyright 2011 The MathWorks, Inc.

args = privResolveArgs(n, k);
N = formula(args{1});
K = formula(args{2});
if ~isscalar(N) || ~isscalar(K) 
    error(message('symbolic:sym:nchoosek:ArgumentsMustBeScalar'));
end

if N == sym(inf) 
    % for compatibility with doubles
    if K == sym(0) 
        cSym = sym(1);
    elseif K == sym(1)
        cSym = sym(inf);
    else
        cSym = sym(NaN);
    end    
elseif ~isfinite(N) || ~isfinite(K)
    cSym = sym(NaN);
else
    cSym = mupadmex('binomial', N.s, K.s);
end    
c = privResolveOutput(cSym, args{1});
