function f = ifourier(F,varargin)
%IFOURIER Inverse Fourier integral transform.
%   f = IFOURIER(F) is the inverse Fourier transform of the sym F
%   with default independent variable w.  The default return is a
%   function of x.  The inverse Fourier transform is applied to a
%   function of w and returns a function of x: F = F(w) => f = f(x).
%   If F = F(x), then IFOURIER returns a function of t: f = f(t). By
%   definition, f(x) = 1/(2*pi) * int(F(w)*exp(i*w*x),w,-inf,inf) and the
%   integration is taken with respect to w.
%
%   f = IFOURIER(F,u) makes f a function of u instead of the default x:
%   IFOURIER(F,u) <=> f(u) = 1/(2*pi) * int(F(w)*exp(i*w*u,w,-inf,inf),
%   integration with respect to w.
%
%   f = IFOURIER(F,v,u) takes F to be a function of v instead of the
%   default w:  IFOURIER(F,v,u) <=>
%   f(u) = 1/(2*pi) * int(F(v)*exp(i*v*u,v,-inf,inf),
%   integration with respect to v.
%
%   Examples:
%    syms t u w x
%    ifourier(w*exp(-3*w)*heaviside(w)) returns 1/(2*pi*(i*x - 3)^2)
%
%    ifourier(1/(1 + w^2),u)   returns
%        ((pi*heaviside(u))/exp(u) + pi*heaviside(-u)*exp(u))/(2*pi)
%
%    ifourier(v/(1 + w^2),v,u) returns -(i*dirac(u, 1))/(w^2 + 1)
%
%    ifourier(fourier(sym('f(x)'),x,w),w,x)   returns   f(x)
%
%   See also SYM/FOURIER, SYM/ILAPLACE, SYM/IZTRANS, SUBS.

%   Copyright 2011 The MathWorks, Inc.

f = transform('ifourier', 'w', 'x', 't', F, varargin{:});
end
