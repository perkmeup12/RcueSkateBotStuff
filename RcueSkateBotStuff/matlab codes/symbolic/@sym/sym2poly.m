function c = sym2poly(p)
%SYM2POLY Symbolic polynomial to polynomial coefficient vector.
%   SYM2POLY(P) returns a row vector containing the coefficients 
%   of the symbolic polynomial P.
%
%   Example:
%      sym2poly(x^3 - 2*x - 5) returns [1 0 -2 -5].
%
%   See also POLY2SYM, SYM/COEFFS.

%   Copyright 1993-2012 The MathWorks, Inc.

p = expand(p);
x = symvar(p);

if isempty(x)
   % constant case
   c = double(p);

elseif numel(x) > 1
   error(message('symbolic:sym:sym2poly:errmsg1'))

elseif isempty(p)
    c = [];
else
    [c,stat] = mupadmex('symobj::sym2poly',p.s,x.s);
    if stat ~= 0 || isempty(c) || isequal(c,evalin(symengine,'FAIL'))
      error(message('symbolic:sym:sym2poly:errmsg2'))
    else
        c = double(c(:).');
    end
end
