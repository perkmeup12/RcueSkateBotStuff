% Symbolic Math Toolbox
% Version 6.0 (R2014a) 27-Dec-2013
%
% 計算
%   diff        - 微分
%   int         - 積分
%   limit       - 極限値
%   taylor      - テイラー級数
%   jacobian    - ヤコビ行列
%   symsum      - 級数の総和
%
% 線形代数
%   diag        - 対角行列の作成、または、対角成分の抽出
%   triu        - 上三角行列
%   tril        - 下三角行列
%   inv         - 逆行列
%   det         - 行列式
%   rank        - ランク
%   rref        - 行列の簡約化
%   null        - ヌル空間に対する基底
%   colspace    - 列空間に対する基底
%   eig         - 固有値と固有ベクトル
%   svd         - 特異値と特異ベクトル
%   jordan      - Jordan 正準型
%   poly        - 特性多項式
%   expm        - 行列指数
%   mldivide    - \  行列の左除算
%   mpower      - ^  行列のべき乗
%   mrdivide    - /  行列の除算
%   mtimes      - *  行列の乗算
%   transpose   - .' 行列の転置
%   ctranspose  - '  行列の複素共役転置
%
% 簡略化
%   simplify    - 簡略化
%   expand      - 展開
%   factor      - 因数分解
%   collect     - 係数をまとめる
%   simple      - 最も短い表現の検索
%   numden      - 分子と分母
%   horner      - 入れ子の多項式表現
%   subexpr     - 共通する部分式による式の書き換え
%   coeffs      - 多変数多項式の係数抽出
%   sort        - シンボリックベクトルあるいは多項式の並べ替え
%   subs        - シンボリックな代入
%
% 方程式の解法
%   solve       - 代数方程式のシンボリックな解
%   dsolve      - 微分方程式のシンボリックな解
%   finverse    - 逆関数
%   compose     - 関数の合成
%
% 可変精度の演算
%   vpa         - 可変精度の演算
%   digits      - 可変精度の設定
%
% 積分変換
%   fourier     - フーリエ変換
%   laplace     - ラプラス変換
%   ztrans      - Z-変換
%   ifourier    - 逆フーリエ変換
%   ilaplace    - 逆ラプラス変換
%   iztrans     - 逆 Z-変換
%
% 変換
%   double      - シンボリック行列を倍精度に変換
%   single      - シンボリック行列を単精度に変換
%   poly2sym    - 係数ベクトルをシンボリック多項式に変換
%   sym2poly    - シンボリック多項式を係数ベクトルに変換
%   char        - シンボリックオブジェクトを文字列に変換
%   int8        - 符号付き 8 ビット整数に変換
%   int16       - 符号付き 16 ビット整数に変換
%   int32       - 符号付き 32 ビット整数に変換
%   int64       - 符号付き 64 ビット整数に変換
%   uint8       - 符号なし 8 ビット整数に変換
%   uint16      - 符号なし 16 ビット整数に変換
%   uint32      - 符号なし 32 ビット整数に変換
%   uint64      - 符号なし 64 ビット整数に変換
%
% 基本演算
%   sym         - シンボリックオブジェクトの作成
%   syms        - シンボリックオブジェクト作成のショートカット
%   findsym     - シンボリック変数の決定
%   pretty      - シンボリック式の簡易出力
%   latex       - シンボリック式の LaTeX 表現
%   texlabel    - 文字列から TeX 形式の生成
%   ccode       - シンボリック式の C コード表現
%   fortran     - シンボリック式の Fortran 表現
%   matlabFunction - シンボリック式から MATLAB 関数を生成
%   emlBlock    - Embedded MATLAB Simulink ブロックを生成
%
% 数学および代数の演算
%   plus        - +  加算
%   minus       - -  減算
%   uminus      - -  否定
%   times       - .* 配列の乗算
%   ldivide     - \  左除算
%   rdivide     - /  除算
%   power       - .^ 配列のべき乗
%   abs         - 絶対値
%   ceil        - 切り上げ (Ceiling)
%   conj        - 共役
%   colon       - コロン演算子
%   fix         - 整数部
%   floor       - 切り捨て (Floor)
%   frac        - 小数部
%   mod         - 剰余
%   round       - 丸め
%   quorem      - 商と余り
%   imag        - 虚数部
%   real        - 実数部
%   exp         - 指数
%   log         - 自然対数
%   log10       - 常用対数
%   log2        - 2 を底とした対数
%   sqrt        - 平方根
%   prod        - 要素の積
%   sum         - 要素の和
%
% 論理演算子
%   isreal      - 実数配列の検出
%   eq          - 等価
%   ne          - 不等価
%
% 特殊関数
%   besseli     - ベッセル関数 I
%   besselj     - ベッセル関数 J
%   besselk     - ベッセル関数 K
%   bessely     - ベッセル関数 Y
%   erf         - 誤差関数
%   sinint      - 正弦積分関数
%   cosint      - 余弦積分関数
%   zeta        - リーマンの zeta 関数
%   gamma       - シンボリックなガンマ関数
%   gcd         - 最大公約数
%   lcm         - 最小公倍数
%   hypergeom   - 一般超幾何関数
%   lambertw    - ランベルトの W 関数
%   dirac       - デルタ関数
%   heaviside   - ステップ関数
%
% 三角関数
%
%   acos        - 逆余弦
%   acosh       - 逆双曲線余弦
%   acot        - 逆正接
%   acoth       - 逆双曲線正接
%   acsc        - 逆余割
%   acsch       - 逆双曲線余割
%   asec        - 逆正割
%   asech       - 逆双曲線正割
%   asin        - 逆正弦
%   asinh       - 逆双曲線正弦
%   atan        - 逆正接
%   atanh       - 逆双曲線正接
%   cos         - 余弦
%   cosh        - 双曲線余弦
%   cot         - 余接
%   coth        - 双曲線余接
%   csc         - 余割
%   csch        - 双曲線余割
%   sec         - 正割
%   sech        - 双曲線正割
%   sin         - 正弦
%   sinh        - 双曲線正弦
%   tan         - 正接
%   tanh        - 双曲線正接
%
% 文字列の取り扱いのユーティリティ
%   isvarname   - 有効な変数名のチェック(MATLAB TOOLBOX)
%   vectorize   - シンボリック式のベクトル化
%   disp        - sym をテキストとして表示
%   display     - 関数を syms として表示
%   eval        - シンボリック表現の評価
%
% 教育的なグラフィカルアプリケーション
%   rsums       - リーマン和
%   ezcontour   - 簡単な等高線図
%   ezcontourf  - 簡単な塗りつぶし等高線図
%   ezmesh      - 簡単なメッシュ(表面) プロット
%   ezmeshc     - メッシュと等高線の簡単な組み合わせプロット
%   ezplot      - 関数の簡単なプロット
%   ezplot3     - 3 次元パラメトリック曲線の簡単なプロット
%   ezpolar     - 簡単な極座標プロット
%   ezsurf      - 簡単な表面プロット
%   ezsurfc     - 表面と等高線の簡単な組み合わせプロット
%   funtool     - 関数計算機
%   taylortool  - テイラー級数計算機
%
% デモ
%   symintro    - Symbolic Toolbox の紹介
%   symcalcdemo - 計算のデモ
%   symlindemo  - シンボリックな線形代数のデモ
%   symvpademo  - 可変精度の演算のデモ
%   symrotdemo  - 平面回転の問題
%   symeqndemo  - シンボリックな式の解法のデモ
%   mupadDemo   - MuPAD ノートブックデモの起動
%
% MuPAD へのアクセス
%   mupadwelcome - MuPAD の Welcome 画面
%   mupad       - MuPAD ノートブックインタフェースの起動
%   getVar      - MuPAD ノートブックから変数を取得
%   setVar      - MuPAD ノートブック内の変数を設定
%   symengine   - sym オブジェクトに対する MuPAD エンジンのインタフェース

%   Copyright 1993-2013 The MathWorks, Inc. 
