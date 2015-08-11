%MRDIVIDE  シンボリック行列の右除算
%
%   MRDIVIDE(B, A) は、シンボリックな B / A をオーバロードします。
%   X = B/A は、シンボリックな線形方程式 X*A = B を解きます。
%   X が存在しないか、固有でない場合、警告メッセージを生成します。
%   長方形行列 A を使うことができますが、式は整合性がなければなりません。
%   最小二乗解は計算されません。
%
%   参考 SYM/MLDIVIDE, SYM/RDIVIDE, SYM/LDIVIDE, SYM/QUOREM.


%   Copyright 1993-2008 The MathWorks, Inc.
