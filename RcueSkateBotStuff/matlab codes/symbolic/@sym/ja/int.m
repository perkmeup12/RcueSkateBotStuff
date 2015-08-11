%INT  積分
%
%   INT(S) は、FINDSYM で定義されるようなシンボリック変数についての S の
%     不定積分です。S は、シンボリックオブジェクト (行列またはスカラ) です。
%     S が定数の場合、積分は、'x' について計算されます。
%   INT(S, v) は、v についての S の不定積分です。v は、スカラのシンボリック
%     オブジェクトです。
%   INT(S,a,b) は、そのシンボリック変数についての a から b までの S の定積分
%     を定義します。a と b は、それぞれ double またはシンボリックなスカラです。
%   INT(S, v, a, b) は、v についての a から b までの S の定積分です。
%
%   例:
%     syms x x1 alpha u t;
%     A = [cos(x*t),sin(x*t);-sin(x*t),cos(x*t)];
%     int(1/(1+x^2)) は atan(x) を返します。
%     int(sin(alpha*u),alpha) は -cos(alpha*u)/u を返します。
%     int(besselj(1,x),x) は -besselj(0,x) を返します。
%     int(x1*log(1+x1),0,1) は 1/4 を返します。
%     int(4*x*t,x,2,sin(t)) は -2*t*cos(t)^2 - 6*t を返します。
%     int([exp(t),exp(alpha*t)]) は [ exp(t), exp(alpha*t)/alpha] を返します。
%     int(A,t) は [sin(t*x)/x, -cos(t*x)/x] を返します。
%                 [cos(t*x)/x,  sin(t*x)/x]


%   Copyright 1993-2009 The MathWorks, Inc.
