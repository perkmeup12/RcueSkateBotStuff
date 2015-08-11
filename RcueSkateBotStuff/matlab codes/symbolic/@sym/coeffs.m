function [c,t] = coeffs(p,x)
%COEFFS Coefficients of a multivariate polynomial.
%   C = COEFFS(P) returns the coefficients of the polynomial P with
%   respect to all the indeterminates of P.
%   C = COEFFS(P,X) returns the coefficients of the polynomial P with
%   respect to X.
%   [C,T] = COEFFS(P,...) also returns an expression sequence of the
%   terms of P.  There is a one-to-one correspondence between the
%   coefficients and the terms of P.
%
%   Examples:
%      syms x
%      t = 2 + (3 + 4*x)^2 - 5*x;
%      coeffs(t) = [ 11, 19, 16]
%
%      syms x y
%      z = 3*x^2*y^2 + 5*x*y^3;
%      coeffs(z) = [5, 3]
%      coeffs(z,x) = [5*y^3, 3*y^2]
%      [c,t] = coeffs(z,y) returns c = [5*x, 3*x^2], t = [y^3, y^2]
%
%   See also SYM/SYM2POLY.

%   Copyright 1993-2011 The MathWorks, Inc.

if ~isa(p,'sym'), p = sym(p); end
if builtin('numel',p) ~= 1,  p = normalizesym(p);  end
if ~isscalar(p)
  error(message('symbolic:coeffs:FirstArgumentMustBeScalar'));
end
if nargin == 2
    x2 = sym(x);
    args = {x2.s};
else
    args = {};
end
if nargout < 2
    cSym = mupadmex('symobj::coeffs',p.s, args{:});
    c = privResolveOutput(cSym, p);
else
    [cSym,tSym] = mupadmexnout('symobj::coeffsterms', p, args{:});
    c = privResolveOutput(cSym, p);
    t = privResolveOutput(tSym, p);
end
