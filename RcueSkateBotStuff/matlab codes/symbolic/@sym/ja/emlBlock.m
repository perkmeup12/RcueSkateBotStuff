%emlBlock  Embedded MATLAB ブロックの生成
%
%   emlBlock(BLOCK,F) は、BLOCK というパスを持つ 'Embedded MATLAB Function' 
%   ブロックを生成し、F から matlabFunction を介して生成された MATLAB コードを
%   ブロックとして定義します。BLOCK が存在する場合は、それは EML ブロックで
%   なければなりません。また、既存のブロック定義は F と置き換えられます。
%
%   emlBlock(BLOCK,F1,F2,...,FN) は、F1 から FN までの N 個の出力を持つ 
%   EML ブロックを生成します。ブロックの入力と出力は、ブロック定義の 
%   MATLAB 関数の入出力と同じです。
%
%   emlBlock(...,PARAM1,VALUE1,...) は、生成されたブロックのパラメータと
%   値の組を変更する際に使用します。パラメータは、既存コード内の関数宣言を
%   カスタマイズします。生成コードのテンプレートは、以下のとおりです。
%       function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   パラメータ名は、以下のいずれかになります。
%
%   'functionName': 値 NAME は文字列でなければなりません。
%             デフォルトは、ブロック BLOCK の名前です。
%
%  'outputs': 値は関数テンプレート内の出力変数の名前 OUT1, OUT2,... OUTN を
%             指定する N 個の文字列のセル配列でなければなりません。OUTk に
%             対するデフォルトの出力端子名は Fk の変数名、または、Fk が 
%             simple variable ではない場合は 'outk' です。
%
%     'vars': 値 IN は以下のいずれかでなければなりません。
%                1) M 個の文字列のセル配列または sym 配列
%                2) M 個のシンボリック変数のベクトル
%             IN は、関数テンプレート内の入力の変数名と入力の順番 IN1, 
%             IN2,... INM を指定します。INj が sym 配列の場合、関数テンプレートで
%             使われる名前は 'inj' になります。IN にリストされる変数は、Fk の
%             すべてにおける自由変数の上位集合でなければなりません。IN の
%             デフォルト値は、Fk のすべてにおける自由変数の和集合です。
%
%   注意: すべての MuPAD 式が MATLAB 関数に変換されるわけではありません。
%   たとえば、区分的な式と集合は変換されません。
%
%   例:
%      syms x y
%      f = x^2 + y^2;
%      new_system('mysys'); open_system('mysys');
%      emlBlock('mysys/f',f);
%
%   参考: matlabFunction, simulink


%   Copyright 2008-2009 The MathWorks, Inc.
