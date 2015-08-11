%POLY2SYM  多項式係数ベクトルのシンボリック多項式への変換
%
%   POLY2SYM(C) は、ベクトル C で定義される係数を持つ 'x' に冠するシンボリック
%   多項式です。
%   POLY2SYM(C, 'V') と POLY2SYM(C, SYM('V')) は、2 番目の引数で設定された
%   シンボリック変数を使います。
%
%   例:
%       poly2sym([1 0 -2 -5]) は、以下のようになります。
%       x^3-2*x-5
%
%       poly2sym([1 0 -2 -5],'t')
%   と
%       t = sym('t')
%       poly2sym([1 0 -2 -5],t)
%   は、両方とも以下のようになります。
%       t^3-2*t-5
%
%   参考 SYM/SYM2POLY, POLYVAL.


%   Copyright 1993-2008 The MathWorks, Inc. 
