%MLDIVIDE  シンボリック行列の左除算
%
%   MLDIVIDE(A, B) は、シンボリックな A \ B をオーバロードします。
%   X = A\B は、シンボリックな 1 次方程式 A*X = B を解きます。X が存在
%   しないか、固有でない場合、警告メッセージを生成します。
%   長方形行列 A を使うことができますが、式は整合性がなければなりません。
%   最小二乗解は計算されません。
%
%   参考 SYM/MRDIVIDE, SYM/LDIVIDE, SYM/RDIVIDE, SYM/QUOREM.


%   Copyright 1993-2008 The MathWorks, Inc.
