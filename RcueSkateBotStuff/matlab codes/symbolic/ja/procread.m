% PROCREAD   Mapleプロシージャの挿入
%
% PROCREAD(FILENAME) は、指定のファイルを読み込みます。ここで、ファイルは 
% Maple プロシージャのソーステキストを含んでいます。PROCREAD は、コメントと 
% newline 文字を取り除いてから、結果の文字列を Maple に転送します。
% PROCREAD を使用するには、Extended Symbolic Toolbox が必要です。
%
% 例題:
% ファイル "check.src" に、以下の Maple プロシージャのソーステキストが
% 含まれていると仮定します。
%
%         check := proc(A)
%            #   check(A) computes A*inverse(A)
%            local X;
%            X := inverse(A):
%            evalm(A &* X);
%         end
%
% ステートメント
%
%         procread('check.src')
%
% は、プロシージャを読み込みます。以下のコマンドで、このプロシージャに
% アクセスできます。
%
%         maple('check',magic(3))
%
% または、
%
%         maple('check',vpa(magic(3)))
%
%   参考 MAPLE.


%   Copyright 1993-2004 The MathWorks, Inc.
