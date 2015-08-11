%SYMS  シンボリックオブジェクト作成のショートカット
%
%   SYMS arg1 arg2 ...
%   は、以下のステートメントの短縮形です。
%      arg1 = sym('arg1');
%      arg2 = sym('arg2'); ...
%
%   SYMS arg1 arg2 ... real
%   は、以下のステートメントの短縮形です。
%      arg1 = sym('arg1','real');
%      arg2 = sym('arg2','real'); ...
%
%   SYMS arg1 arg2 ... positive
%   は、以下のステートメントの短縮形です。
%      arg1 = sym('arg1','positive');
%      arg2 = sym('arg2','positive'); ...
%
%   SYMS arg1 arg2 ... clear
%   は、以下のステートメントの短縮形です。
%      arg1 = sym('arg1','clear');
%      arg2 = sym('arg2','clear'); ...
%
%   各入力引数は、文字で始まり、英数字のみを含まなければなりません。
%
%   SYMS だけでは、ワークスペース内のシンボリックオブジェクトをリストします。
%
%   例:
%      syms x beta real
%   は、以下と等価です。
%      x = sym('x','real');
%      beta = sym('beta','real');
%
%      syms k positive
%   は、以下と等価です。
%      k = sym('k','positive');
%
%   'real' 状態のシンボリックオブジェクト x と beta を消去するためには、
%   以下のように入力します。
%      syms x beta clear
%
%   参考 SYM.


%   Copyright 1993-2009 The MathWorks, Inc.
