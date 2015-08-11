%DIFF  微分
%
%   DIFF(S) は、FINDSYM で決定されるような自由変数に関して、シンボリック式 
%   S を微分します。
%   DIFF(S,'v')、または、DIFF(S,sym('v')) は、v に関して S を微分します。
%   DIFF(S,n) は、正の整数 n に対して、S を n 回微分します。
%   DIFF(S,'v',n) と DIFF(S,n,'v') も利用できます。
%
%   例;
%      x = sym('x');
%      t = sym('t');
%      diff(sin(x^2)) は 2*x*cos(x^2) です。
%      diff(t^6,6) は 720 です。
%
%   参考 SYM/INT, SYM/JACOBIAN, SYM/FINDSYM.


%   Copyright 1993-2009 The MathWorks, Inc.
