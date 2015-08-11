% FUNTOOL   関数計算機
%
% FUNTOOL は、一変数関数を取り扱う、対話的で視覚的な関数計算機です。
% 常に2つの関数 f(x) と g(x) が表示されています。多くの演算の結果により、
% f(x) は置き換えられます。
%
% 'f = ' および 'g = ' とラベル付けられているコントロールは、新規の関数の
% 設定時に変更されるエディタブルテキストです。'x = ' とラベル付けられて
% いるコントロールは、新規の定義域の設定時に変更されます。'a = ' と
% ラベル付けられているコントロールは、パラメータの新規の値の設定時に
% 変更されます。
% 
% 最初の行のコントロールボタンは、f(x) のみに関する単項関数演算子です。
% 以下の演算があります。
% 
%      df/dx     - f(x) の微分
%      int f     - f(x) の積分
%      simple f  - 可能であれば、f のシンボリック表現の簡略化
%      num f     - 有理式の分子の抽出
%      den f     - 有理式の分母の抽出
%      1/f       - f(x) を 1/f(x) で置き換える
%      finv      - f(x) を逆関数で置き換える
%
% 演算子 int(f) と finv は、対応するシンボリック式が閉じた形で存在しない
% 場合、失敗することがあります。
%
% 2行目のボタンは、パラメータ 'a' によって、f(x) の変換やスケーリングを
% 行います。
% 
% 以下の演算があります。
%      f + a    - f(x) を f(x) + a で、置き換えます。
%      f - a    - f(x) を f(x) - a で、置き換えます。
%      f * a    - f(x) を f(x) * a で、置き換えます。
%      f / a    - f(x) を f(x) / a で、置き換えます。
%      f ^ a    - f(x) を f(x) ^ a で、置き換えます。
%      f(x+a)   - f(x) を f(x + a) で、置き換えます。
%      f(x*a)   - f(x) を f(x * a) で、置き換えます。
%
% 3行目のボタンは、f(x) と g(x) の両方に対する関数演算子です。以下の
% 演算があります。
% 
%      f + g  - f(x) を f(x) + g(x) で、置き換えます。
%      f - g  - f(x) を f(x) - g(x) で、置き換えます。
%      f * g  - f(x) を f(x) * g(x) で、置き換えます。
%      f / g  - f(x) を f(x) / g(x) で、置き換えます。
%      f(g)   - f(x) を f(g(x)) で、置き換えます。
%      g = f  - g(x) を f(x) で、置き換えます。
%      swap   - f(x) と g(x) を交換します。
%
% 4行目の最初の3つのボタンは、関数のリストを管理します。
% Insert ボタンは、現在のアクティブ関数をリストに追加します。
% Cycle ボタンは、関数リストを繰り返し利用します。
% Delete ボタンは、アクティブな関数をリストから削除します。 
% 関数のリストは、fxlist と名付けられます。複数の興味ある関数を含む
% デフォルトの fxlist が与えられています。
%
% Reset ボタンは、f, g, x, a, fxlist を初期値に設定します。
% Help ボタンは、ヘルプテキストを表示します。 
%
% Demo ボタンは、マウスのみを使ってキーボードに触れずに関数 sin(x) を
% 作成します。
% 
% このデモは、リセットと9回のクリックによって sin(x) を作成します。
% それよりも少ないクリックによって行うことができた場合は、moler@mathworks.com 
% に電子メールを送ってください。
%
% Close ボタンは、3つのウィンドウをすべて閉じます。
%
% 参考   EZPLOT.


%   Copyright 1993-2006 The MathWorks, Inc.
