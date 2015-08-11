function p = poly2sym(c,x)
%POLY2SYM Polynomial coefficient vector to symbolic polynomial.
%   POLY2SYM(C,V) is a polynomial in the symbolic variable V
%   with coefficients from the vector C.
% 
%   Example:
%       x = sym('x');
%       poly2sym([1 0 -2 -5],x)
%   is
%       x^3-2*x-5
%
%   See also SYM/SYM2POLY, POLYVAL.

%   Copyright 1993-2012 The MathWorks, Inc.

if ~isa(c,'sym'), c = sym(c); end
if isa(x,'sym')
    if builtin('numel',x) ~= 1,  x = normalizesym(x);  end
    cx = x.s;  
else
    cx = x;  
end
p = mupadmex('symobj::poly2sym',c.s,cx);

