% MAPLE   Maple のカーネルへのアクセス
%
% MAPLE(STATEMENT) は、Maple のカーネルへ STATEMENT を送ります。
% STATEMENT は、文法的に有効な Maple のコマンドを表わす文字列です。
% 必要ならば、Maple のシンタックスに対するセミコロンが STATEMENT に付加
% されます。結果は、Maple のシンタックスの文字列です。
%
% MAPLE('function', ARG1, ARG2, ..,) は、シングルコートで囲まれた Maple の
% 関数名と対応する引数を受け入れます。Maple のステートメントは、
% function(arg1, arg2, arg3, ...) のようになります。つまり、引数の間に
% カンマが付加されます。すべての入力引数は、Maple の文法的に有効な文字列で
% なければなりません。結果は、Maple のシンタックスの文字列として出力されます。
% 結果を Maple の文字列からシンボリックオブジェクトに変換するには、SYM を
% 使います。
%
% [RESULT, STATUS] = MAPLE(...) は、警告/エラーステータスを出力します。
% ステートメントの実行が成功すると、RESULT には結果が出力され、STATUS には 
% 0 が出力されます。実行が失敗すると、RESULT には対応する警告/エラー
% メッセージが出力され、STATUS には正の整数が出力されます。
%
% ステートメント
%      maple traceon  または  maple trace on
% は、その後に続く Maple コマンドを起動し、結果を表示します。
% ステートメント
%   maple traceoff  または  maple trace off
% は、上記の機能を終了します。
% ステートメント、
%      maple restart
% は、Maple ワークスペースをクリアし、Maple カーネルを再度初期化します。
% メモリから Maple カーネルを解放するには、"clear maplemex" を使用して
% ください。Macintosh でのみ、MATLAB を終了することでカーネルを解放できる
% ことに注意してください。
%
% MAPLE は、Student Version では利用できません。
%
%   参考 SYM, SYM/MAPLE


%   Copyright 1993-2006 The MathWorks, Inc.
