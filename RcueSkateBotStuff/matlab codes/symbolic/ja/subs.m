%SUBS  シンボリックな代入
%
%   SUBS(S) は、シンボリック式 S 内のすべての変数を呼び出し側の関数、または、
%   MATLAB のワークスペースから得られる値で置き換えます。
%
%   SUBS(S, NEW) は、S 内のシンボリックな自由変数を NEW で置き換えます。
%   SUBS(S, OLD, NEW) は、シンボリック式 S 内の OLD を NEW で置き換えます。
%   OLD は、シンボリック変数、変数名を表わす文字列、コーテーションで囲まれた
%   文字列表現です。NEW は、シンボリック変数または数値的な変数、あるいは式です。
%
%   OLD と NEW が同じサイズのベクトルまたは配列の場合、OLD の各要素は、NEW に
%   対応する要素で置き換えられます。S と OLD がスカラで、NEW が配列または
%   セル配列の場合、スカラは配列の結果を生成するために拡張されます。NEW が
%   数値行列からなるセル配列の場合、要素ごとの代入が実行されます (すなわち、
%   A と B が数値の場合、subs(x*y,{x,y},{A,B}) は、A.*B を返します)。
%
%   SUBS(S, OLD, NEW) により S が変更されなければ、SUBS(S, NEW, OLD) が
%   試されます。これは、前バージョンに対する互換性を提供します。
%   これにより、引数の順序を覚える必要はありません。
%   S が変更されなければ、SUBS(S, OLD, NEW, 0) は、引数の入れ替えを行いません。
%
%   例:
%     単入力:
%       ワークスペース内に、a = 980 と C1 = 3 が存在すると仮定します。
%       ステートメント
%          y = dsolve('Dy = -a*y')
%       は、以下の結果を出力します。
%          y = exp(-a*t)*C1
%       ステートメント
%          subs(y)
%       は、以下の結果を出力します。
%          ans = 3*exp(-980*t)
%
%     一変数の代入:
%       subs(a+b,a,4) は、4+b を返します。
%
%     多変数の代入:
%       subs(cos(a)+sin(b),{a,b},[sym('alpha'),2]) または
%       subs(cos(a)+sin(b),{a,b},{sym('alpha'),2}) は、以下の結果を返します。
%       cos(alpha)+sin(2)
%
%     スカラ拡張の場合:
%       subs(exp(a*t),'a',-magic(2)) は、以下の結果を返します。
%
%       [   exp(-t), exp(-3*t)]
%       [ exp(-4*t), exp(-2*t)]
%
%     複数のスカラ拡張の場合:
%       subs(x*y,{x,y},{[0 1;-1 0],[1 -1;-2 1]}) は、以下の結果を返します。
%       [  0, -1]
%       [  2,  0]
%
%   参考 SYM/SUBEXPR.


%   Copyright 1993-2008 The MathWorks, Inc.
