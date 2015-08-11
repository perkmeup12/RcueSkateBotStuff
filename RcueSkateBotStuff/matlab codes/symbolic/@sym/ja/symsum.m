%SYMSUM  シンボリックな総和
%
%   SYMSUM(S) は、FINDSYM で決定されるようなシンボリック変数について、
%   S の無限大の総和を求めます。
%   SYMSUM(S, v) は、v について無限大の総和を求めます。
%   SYMSUM(S, a, b) と SYMSUM(S, v, a, b)は、a から b までのシンボリック式の
%   総和を求めます。
%
%   例:
%      symsum(k)                     k^2/2 - k/2
%      symsum(k,0,n-1)               (n*(n - 1))/2
%      symsum(k,0,n)                 (n*(n + 1))/2
%      simple(symsum(k^2,0,n))       n^3/3 + n^2/2 + n/6
%      symsum(k^2,0,10)              385
%      symsum(k^2,11,10)             0
%      symsum(1/k^2)                 -psi(k, 1)
%      symsum(1/k^2,1,Inf)           pi^2/6
%
%   参考 SYM/INT.


%   Copyright 1993-2009 The MathWorks, Inc.
