function ezmesh(f,varargin)
%EZMESH General surface-mesh plotter.
%   EZMESH(f) plots a graph of f(x,y) using MESH where f is a string
%   or a symbolic expression representing a mathematical function
%   involving two symbolic variables, say 'x' and 'y'.  The function
%   f is plotted over the default domain -2*pi < x < 2*pi, -2*pi < y <
%   2*pi.  The computational grid is chosen according to the amount of
%   variation that occurs.
% 
%   EZMESH(f,DOMAIN) plots f over the specified DOMAIN instead of the
%   default DOMAIN = [-2*pi,2*pi,-2*pi,2*pi].  The DOMAIN can be the
%   4-by-1 vector [xmin,xmax,ymin,ymax] or the 2-by-1 vector [a,b] (to
%   plot over a < x < b, a < y < b).
%
%   If f is a function of the variables u and v (rather than x and
%   y), then the domain endpoints umin, umax, vmin, and vmax are
%   sorted alphabetically.  Thus, EZMESH(u^2 - v^3,[0,1,3,6]) plots
%   u^2 - v^3 over 0 < u < 1, 3 < v < 6.
%
%   EZMESH(x,y,z) plots the parametric surface x = x(s,t), y = y(s,t),
%   and z = z(s,t) over the square -2*pi < s < 2*pi and -2*pi < t < 2*pi.
%
%   EZMESH(x,y,z,[smin,smax,tmin,tmax]) or EZMESH(x,y,z,[a,b]) uses the
%   specified domain.
%
%   EZMESH(...,fig) plots f over the default domain in the figure window
%   fig.
%
%   EZMESH(...,'circ') plots f over a disk centered on the domain.
%
%   Examples:
%    syms x y s t
%    f = 3*(1-x)^2*exp(-(x^2) - (y+1)^2) ... 
%       - 10*(x/5 - x^3 - y^5)*exp(-x^2-y^2) ... 
%       - 1/3*exp(-(x+1)^2 - y^2);
%    ezmesh(f,[-pi,pi])
%    ezmesh(x*exp(-x^2 - y^2))
%    ezmesh(x*y,'circ')
%    ezmesh(real(atan(x + i*y)))
%    ezmesh(exp(-x)*cos(t),[-4*pi,4*pi,-2,2])
%
%    ezmesh(s*cos(t),s*sin(t),t)
%    ezmesh(exp(-s)*cos(t),exp(-s)*sin(t),t,[0,8,0,4*pi])
%    ezmesh((s-sin(s))*cos(t),(1-cos(s))*sin(t),s,[-2*pi,2*pi])
%
%   See also EZPLOT, EZPLOT3, EZPOLAR, EZCONTOUR, EZCONTOURF, EZMESH, 
%            EZSURFC, EZMESHC, SURF.

%   Copyright 1993-2009 The MathWorks, Inc.

ezhelper(@ezmesh,f,varargin{:});
