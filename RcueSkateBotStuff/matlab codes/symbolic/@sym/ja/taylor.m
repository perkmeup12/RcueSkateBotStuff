%TAYLOR  �e�C���[�����W�J
%
%   TAYLOR(f) �́Af �ɑ΂��� 5 ���� Maclaurin �������ߎ��ł��B3 �̃p�����[�^
%   ��C�ӂ̏����ŗ^���邱�Ƃ��ł��܂��BTAYLOR(f, n) �́A(n-1) ���� Maclaurin 
%   �������ł��BTAYLOR(f, a) �́A�_ a �Ɋւ���e�C���[�������ߎ������߂܂��B
%   TAYLOR(f, x) �́AFINDSYM(f) �̑���ɓƗ��ϐ� x ���g���܂��B
%
%   ��:
%      taylor(exp(-x))   �́A�ȉ���Ԃ��܂��B
%        x^4/24 - x^5/120 - x^3/6 + x^2/2 - x + 1
%      taylor(log(x),6,1)   �́A�ȉ���Ԃ��܂��B
%        x - (x - 1)^2/2 + (x - 1)^3/3 - (x - 1)^4/4 + (x - 1)^5/5 - 1
%      taylor(sin(x),pi/2,6)   �́A�ȉ���Ԃ��܂��B
%        (pi/2 - x)^4/24 - (pi/2 - x)^2/2 + 1
%      taylor(x^t,3,t)   �́A�ȉ���Ԃ��܂��B
%        (t^2*log(x)^2)/2 + t*log(x) + 1
%
%   �Q�l SYM/FINDSYM, SYM/SYMSUM.


%   Copyright 1993-2009 The MathWorks, Inc.
