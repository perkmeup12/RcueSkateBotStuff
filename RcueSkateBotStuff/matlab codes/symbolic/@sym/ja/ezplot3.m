% EZPLOT3   3次元パラメトリック曲線の簡単なプロット
%
% EZPLOT3(x, y, z) は、デフォルトの領域 0 < t < 2*pi に、空間的な曲線 
% x = x(t), y = y(t), z = z(t) をプロットします。
%
% EZPLOT3(x, y, z, [tmin, tmax]) は、tmin < t < tmax に、曲線 x = x(t), 
% y = y(t), z = z(t) をプロットします。
%
% EZPLOT3(x, y, z, 'animate')、または、
% EZPLOT(x, y, z, [tminm, tmax], 'animate') は、曲線のアニメーション化した
% 軌跡を作成します。
%   
% 例題：
% 
%   syms t
%   ezplot3(sin(t),cos(t),t)
%   ezplot3(sin(t),cos(t),t,[0,6*pi])
%   ezplot3(sin(3*t)*cos(t),sin(3*t)*sin(t),t,[0,12],'animate')
%   ezplot3((4+cos(1.5*t))*cos(t),(2+cos(1.5*t))*sin(t),....
%   sin(1.5*t),[0,4*pi])
%
%  参考 EZPLOT, EZSURF, EZPOLAR, PLOT, PLOT3


%   Copyright 1993-2004 The MathWorks, Inc.
