% DIAG   シンボリックな対角行列の作成、または、対角要素の抽出
% DIAG(V,K)は、VがN個の要素をもつ行、または、列ベクトルならば、K番目の対
% 角上にVの要素をもつN+ABS(K)次のシンボリックな正方行列を出力します。K =
% 0は、主対角を示します。K > 0であれば、主対角より上側を、K < 0であれば、
% 主対角より下側を示します。
% DIAG(V)は、Vを主対角要素とします。
%  
% DIAG(X,K)は、Xがシンボリック行列であれば、XのK番目の対角要素から形成さ
% れる列ベクトルを出力します。DIAG(X)は、Xの主対角要素です。 
%
% 例題 :
%
%      v = [a b c]
%
% diag(v)とdiag(v,0)は、
% 
%         [ a, 0, 0 ]
%         [ 0, b, 0 ]
%         [ 0, 0, c ]
%
% を出力し、(v,-2)は、
% 
%         [ 0, 0, 0, 0, 0 ]
%         [ 0, 0, 0, 0, 0 ]
%         [ a, 0, 0, 0, 0 ]
%         [ 0, b, 0, 0, 0 ]
%         [ 0, 0, c, 0, 0 ]
% 
% を出力します。
% 
%      A =
%         [ a, b, c ]
%         [ 1, 2, 3 ]
%         [ x, y, z ]
%
% のとき、diag(A)は、
% 
%         [ a ]
%         [ 2 ]
%         [ z ]
% 
% を出力し、diag(A,1)は、
% 
%         [ b ]
%         [ 3 ]
%
% を出力します。
% 



%   Copyright 1993-2003 The MathWorks, Inc.
