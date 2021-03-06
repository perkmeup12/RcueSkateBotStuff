%SYM  シンボリックな数値、変数、オブジェクトの作成
%
%   S = SYM(A) は、A からクラス 'sym' のオブジェクト S を作成します。
%   入力引数が文字列の場合、結果はシンボリックな数値、または、変数になります。
%   入力引数が数値的なスカラ、または、行列の場合、結果は与えられた数値の
%   シンボリック表現になります。入力が関数ハンドルの場合、結果は関数ハンドルの
%   本体のシンボリックな形式になります。
%
%   x = sym('x') は、'x' という名前のシンボリック変数を作成し、結果を x に
%   格納します。x = sym('x', 'real') は、x が実数であるという仮定も含みます。
%   この場合、conj(x) は x と等価です。alpha = sym('alpha') および 
%   r = sym('Rho', 'real') のように使います。同様に、k = sym('k','positive') は、
%   k を正の (実数の) 変数にします。x = sym('x','clear') は、x を追加の
%   プロパティを持たない形式に戻します (すなわち、x は実数にも正にもなりません)。
%   下記のシンボルのいずれかを定義すると、
%
%      beta, gamma, psi, theta, zeta, D, E, I, O, Ei, Ci, Si
%
%   通常の MuPAD の定義の代わりに変数としてシンボルを扱います。
%   シンボル 'i' を定義すると、'clear' が使用されるまで虚部 i の代わりに 
%   sqrt(-1) を使用します。
%   参考: SYMS.
%
%   pi = sym('pi') と delta = sym('1/10') のようなステートメントは、
%   pi と 1/10 の値を継承するように、浮動小数点近似を行わずにシンボリック数を
%   作成します。この方法で作られた pi は、組み込みの数値関数を一時的に
%   同じ名前で置き換えます。
%
%   S = sym(A,flag) は、数値のスカラ、または、行列をシンボリック型に変換します。
%   浮動小数点数を変換する手法は、2 番目の引数で指定します。'f', 'r', 'e', 'd' 
%   のいずれかになります。デフォルトは 'r' です。
%
%   'f' は、'floating point' (浮動小数点) を表します。すべての値は、
%   (2^e+N*2^(e-52)) または '-(2^e+N*2^(e-52)) の型で表されます。ここで、N は整数です。
%   たとえば、sym(1/10,'f') は (2^-4+2702159776422298*2^-56) です。
%
%   'r' は 'rational' (有理数) を表します。適度なサイズの整数 p と q に対して、
%   p/q, p*pi/q, sqrt(p), 2^q,10^q 型の式を評価して得られる浮動小数点数は、
%   対応するシンボリック型に変換されます。これは、オリジナルの評価に含まれる
%   丸め誤差を効果的に補います。しかし、浮動小数点値を正確に表していない場合が
%   あります。簡単な有理数近似を求める場合、大きな整数 p と q を使った 
%   p*2^q 型の式は、正確に浮動小数点値を再生します。たとえば、sym(4/3,'r') は、
%   '4/3' ですが、sym(1+sqrt(5),'r') は 7286977268806824*2^(-51) となります。
%
%   'e' は、'estimate error' (推定誤差) を表します。'r' 型 は、変数 'eps' を
%   含む項で補われます。これは、理論的な有理式と実際の浮動小数点値との間の差を
%   推定します。たとえば、sym(3*pi/4,'e') の結果は 3*pi/4-103*eps/249 です。
%    
%   'd' は、'decimal' (小数) を表します。桁数は、VPA で使用される DIGITS の
%   現在の設定から得られます。16 桁より小さい桁数を使用すると精度が落ちますが、
%   それ以上の桁は保証されません。
%   たとえば、digits(10) では、sym(4/3,'d') は 1.333333333 ですが、
%   digits(20) は 1.3333333333333332593 となります。これは、3 からなる
%   文字列で終了していませんが、4/3 に最も近い浮動小数点数の正確な 10 進数
%   表現です。
%    
%   参考 SYMS, CLASS, DIGITS, VPA.


%   Copyright 1993-2009 The MathWorks, Inc.
