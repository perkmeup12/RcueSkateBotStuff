%matlabFunction  sym から MATLAB ファイルまたは無名関数の生成
%
%   G = matlabFunction(F) は、sym オブジェクト F から MATLAB の無名関数を
%   生成します。F の自由変数は、関数ハンドル G の結果に対する入力になります。
%   たとえば、x を F の自由変数とするとき、MATLAB 上で G(z) を実行すると、
%   数式エンジン上で subs(F,x,z) を行うことと同様の結果が得られます。
%   関数ハンドル G は、MATLAB にある関数 FZERO のように扱うことができ、
%   または、他のツールボックス内の関数で使用することができます。
%   G の入力の順番は、symvar(F) で返される順と一致します。
%
%   G = matlabFunction(F1,F2,...,FN) は、F1 から FN までの N 個の出力を持つ 
%   MATLAB 関数を生成します。
%
%   G = matlabFunction(...,PARAM1,VALUE1,...) は、生成された関数のパラメータと
%   値の組をカスタマイズする際に使用します。パラメータは、既存コード内の宣言を
%   修正します。生成コードのテンプレートは、以下のとおりです。
%      function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   パラメータ名は、以下のいずれかになります。
%
%     'file': 値 FILE は、有効な MATLAB 関数名を持つ文字列でなければなりません。
%             FILE の最後が '.m' でない場合は '.m' を追加します。ファイルが
%             既に存在する場合は、上書きされます。その関数の関数ハンドルは、
%             G に返されます。ファイル名のパラメータが空の場合、無名関数が
%             生成されます。関数テンプレート内の NAME は、FILE 内のファイル名です。
%
%  'outputs': 値は関数テンプレート内の出力変数の名前 OUT1, OUT2,... OUTN を
%             指定する N 個の文字列のセル配列でなければなりません。OUTk に
%             対するデフォルトの出力端子名は Fk の変数名、または、Fk が 
%             simple variable ではない場合は 'outk' です。'file' パラメータが
%             与えられない場合、'outputs' パラメータは無視されます。
%
%     'vars': 値 IN は以下のいずれかでなければなりません。
%                1) M 個の文字列のセル配列または sym 配列
%                2) M 個のシンボリック変数のベクトル
%             IN は、関数テンプレート内の入力の変数名と入力の順番 IN1, 
%             IN2,... INM を指定します。INj が sym 配列の場合、関数テンプレートで
%             使われる名前は 'inj' になります。IN にリストされる変数は、Fk の
%             すべてにおける自由変数の上位集合でなければなりません。
%             IN のデフォルト値は、Fk のすべてにおける自由変数の和集合です。
%
%   注意: すべての MuPAD 式が MATLAB 関数に変換されるわけではありません。
%   たとえば、区分的な式と集合は変換されません。
%
%   例:
%     syms x y
%     r = x^2+y^2;
%     f = log(r)+1/r;
%     matlabFunction(f,'file','sample')
%     type sample.m
%       function f = sample(x,y)
%       %SAMPLE
%       %    F = SAMPLE(X,Y)
%       t7 = x.^2;
%       t8 = y.^2;
%       t9 = t7 + t8;
%       f = log(t9)+1./t9;
%
%     % Van der Pol の ODE に対して sym 式を作成し、ode45 を使用して解きます。
%     % そして、特定の初期条件に対する解をプロットします。
%     syms t x y
%     mu = 1;
%     vdp = [y; mu*(1-x^2)*y-x];
%     % 生成された関数には 2 つの入力があり、2 番目の入力の行は x と y の
%     % 変数にマッピングされます。ode45 関数は、入力関数をこの形式にする
%     % 必要があります。
%     vdpf = matlabFunction(vdp,'vars',{t,[x;y]});
%     % vdpf は @(t,in2)[in2(2,:);-in2(1,:)-in2(2,:).*(in2(1,:).^2-1)] になり
%     ます。
%     % ode45 に初期条件 [2 0] で関数ハンドルを渡し、結果をプロットします。
%     [ts,ys] = ode45(vdpf,[0 20],[2 0]);
%     plot(ts,ys(:,1))
%
%     % シンボリック mu を使って Van der Pol の ODE に対する sym 式を作成し、
%     % sym 式から 'vdp2' という名前の MATLAB ファイルを生成します。
%     syms mu x y
%     vdp = [y; mu*(1-x^2)*y-x];
%     % 入力 x, y, mu と dvdt という名前の出力変数でファイル vdp2.m を
%     % 生成します。
%     matlabFunction(vdp,'file','vdp2','vars',[x y mu],'outputs',{'dvdt'});
%     type vdp2
%       function dvdt = vdp2(x,y,mu)
%       %VDP2
%       %    DVDT = VDP2(X,Y,MU)
%       dvdt = [y;- x - mu.*y.*(x.^2 - 1)];
%
%   参考: function_handle, subs, fzero, ode45


%   Copyright 2008-2009 The MathWorks, Inc.
