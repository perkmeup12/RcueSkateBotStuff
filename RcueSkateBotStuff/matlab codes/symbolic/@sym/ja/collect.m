%COLLECT  �W�����܂Ƃ߂�
%
%   COLLECT(S,v) �́A�V���{���b�N�s�� S �̊e�X�̗v�f�� v �̑������Ƃ݂Ȃ��A 
%   S�� v �ׂ̂���̌`���ŏ��������܂��BCOLLECT(S) �́AFINDSYM �Ō��肳���
%   �f�t�H���g�ϐ����g���܂��B
%
%   ��:
%      collect(x^2*y + y*x - x^2 - 2*x)  returns (y - 1)*x^2 + (y - 2)*x
%
%      f = -1/4*x*exp(-2*x)+3/16*exp(-2*x)
%      collect(f,exp(-2*x)) �� -(x/4 - 3/16)/exp(2*x) ��Ԃ��܂��B
%
%   �Q�l SYM/SIMPLIFY, SYM/SIMPLE, SYM/FACTOR, SYM/EXPAND, SYM/FINDSYM.


%   Copyright 1993-2009 The MathWorks, Inc.