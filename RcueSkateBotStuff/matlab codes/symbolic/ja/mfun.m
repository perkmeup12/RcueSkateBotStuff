%MFUN  Maple 関数の数値評価
%
%   MFUN('fun', p1, p2, ..., pk) は、'fun' が Maple の関数名で、p が funs の
%   パラメータに対応する数値量です。最後に指定するパラメータには、行列を与える
%   ことができます。その他のすべてのパラメータは、Maple 関数で指定されたタイプで
%   なければなりません。MFUN は、指定したパラメータを使って 'fun' を数値的に
%   評価し、MATLAB 倍精度数値を返します。'fun' 内の特異点は、NaN として返されます。
%
%   例:
%      x = 0:0.1:5.0;
%      y = mfun('FresnelC',x)
%
%   MFUN は Student Version では使用できません。
%
%   参考 MFUNLIST, MHELP.


%   Copyright 1993-2008 The MathWorks, Inc.
