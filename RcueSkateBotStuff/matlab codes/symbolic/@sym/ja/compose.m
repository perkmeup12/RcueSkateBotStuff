%COMPOSE  関数の合成
%
%   COMPOSE(f,g) は、f(g(y)) を返します。ここで、f = f(x) と g = g(y) です。
%   x は FINDSYM で定義されるような f のシンボリック変数で、y は FINDSYM で
%   定義されるような g のシンボリック変数です。
%
%   COMPOSE(f,g,z) は f(g(z)) を返します。ここで、f = f(x) と g = g(y) です。
%   x と y は、FINDSYM で定義されるような f と g のシンボリック変数です。
%
%   COMPOSE(f,g,x,z) は、f(g(z)) を返し、x を f に対する独立変数とします。
%   すなわち、f = cos(x/t) の場合、COMPOSE(f,g,x,z) は、cos(g(z)/t) を返します。
%   一方、COMPOSE(f,g,t,z) は、cos(x/g(z)) を返します。
%
%   COMPOSE(f,g,x,y,z) は、f(g(z)) を返し、x と y をそれぞれ f と g に対する
%   独立変数とします。f = cos(x/t) と g = sin(y/u) の場合、COMPOSE(f,g,x,y,z) 
%   は cos(sin(z/u)/t) を返し、COMPOSE(f,g,x,u,z) は cos(sin(y/z)/t) を
%   返します。
%
%   例:
%    syms x y z t u;
%    f = 1/(1 + x^2); g = sin(y); h = x^t; p = exp(-y/u);
%    compose(f,g)        は  1/(sin(y)^2 + 1)  を返します。
%    compose(f,g,t)      は  1/(sin(t)^2 + 1)  を返します。
%    compose(h,g,x,z)    は  sin(z)^t          を返します。
%    compose(h,g,t,z)    は  x^sin(z)          を返します。
%    compose(h,p,x,y,z)  は  (1/exp(z/u))^t    を返します。
%    compose(h,p,t,u,z)  は  x^(1/exp(y/z))    を返します。
%
%   参考 SYM/FINVERSE, SYM/FINDSYM, SYM/SUBS.


%   Copyright 1993-2009 The MathWorks, Inc.
