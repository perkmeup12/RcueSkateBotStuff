function [g,c,d] = gcd(a,b,x)
%GCD    Greatest common divisor.
%   G = GCD(A,B) is the symbolic greatest common divisor of A and B.
%   G = GCD(A,B,X) uses variable X instead of SYMVAR(A,1).
%   [G,C,D] = GCD(A,B,...) also returns C and D so that G = A*C + B*D.
%
%   Example:
%      syms x
%      gcd(x^3-3*x^2+3*x-1,x^2-5*x+4) 
%      returns x-1
%
%   See also SYM/LCM.

%   Copyright 1993-2011 The MathWorks, Inc.
 
args = privResolveArgs(a, b);
if nargin < 3
    x = symvar(args{1},1);
    if ~isequal(x,symvar(args{2},1))
        error(message('symbolic:sym:gcd:errmsg1'))
    end
end
if isempty(x) && nargout <= 1
    gSym = mupadmex('gcd', args{1}.s, args{2}.s);
    g = privResolveOutput(gSym, args{1});
else
    if isempty(x)
        [gSym,cSym,dSym] = mupadmexnout('symobj::igcdex', args{1}.s, args{2}.s);
    else
        if ischar(x), x = sym(x); end
        [gSym,cSym,dSym] = mupadmexnout('symobj::gcdex', args{1}.s, args{2}.s, x);
    end
    g = privResolveOutput(gSym, args{1});
    c = privResolveOutput(cSym, args{1});
    d = privResolveOutput(dSym, args{1});
end
