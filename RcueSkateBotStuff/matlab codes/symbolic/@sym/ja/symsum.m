%SYMSUM  �V���{���b�N�ȑ��a
%
%   SYMSUM(S) �́AFINDSYM �Ō��肳���悤�ȃV���{���b�N�ϐ��ɂ��āA
%   S �̖�����̑��a�����߂܂��B
%   SYMSUM(S, v) �́Av �ɂ��Ė�����̑��a�����߂܂��B
%   SYMSUM(S, a, b) �� SYMSUM(S, v, a, b)�́Aa ���� b �܂ł̃V���{���b�N����
%   ���a�����߂܂��B
%
%   ��:
%      symsum(k)                     k^2/2 - k/2
%      symsum(k,0,n-1)               (n*(n - 1))/2
%      symsum(k,0,n)                 (n*(n + 1))/2
%      simple(symsum(k^2,0,n))       n^3/3 + n^2/2 + n/6
%      symsum(k^2,0,10)              385
%      symsum(k^2,11,10)             0
%      symsum(1/k^2)                 -psi(k, 1)
%      symsum(1/k^2,1,Inf)           pi^2/6
%
%   �Q�l SYM/INT.


%   Copyright 1993-2009 The MathWorks, Inc.
