%SIMPLE  �V���{���b�N���܂��͍s��̍ł��V���v���ȃt�H�[���̌���
%
%   SIMPLE(S) �́AS �̂��ꂼ��ɈقȂ�㐔�I�Ȋȗ��������s���A�ǂ̂悤�� 
%   S �̕\���̒�����Z����������\�����Ȃ���A�ł��Z���\����Ԃ��܂��B
%   S �̓V���{���b�N�I�u�W�F�N�g�ł��BS ���s��̏ꍇ�A���ʂ͍s��S�̂�
%   �ł��Z���Ȃ�\���ł��B�X�̗v�f���ł��Z���Ƃ͌���܂���B
%
%   [R,HOW] = SIMPLE(S) �́A�ȗ����̓r�����ʂ�\�����܂��񂪁A�ł��Z���\����
%   ���ɁA����̊ȗ����̕��@�����������񂪓����܂��BR �̓V���{���b�N���ł��B
%   HOW �͕�����ł��B
%
%   ��:
%
%      S                          R                  How
%
%      cos(x)^2+sin(x)^2          1                  simplify
%      2*cos(x)^2-sin(x)^2        3*cos(x)^2-1       simplify
%      cos(x)^2-sin(x)^2          cos(2*x)           simplify
%      cos(x)+i*sin(x)            exp(i*x)           rewrite(exp)
%      (x+1)*x*(x-1)              x^3-x              simplify(100)
%      x^3+3*x^2+3*x+1            (x+1)^3            simplify
%      cos(3*acos(x))             4*x^3-3*x          simplify(100)
%
%   �Q�l SYM/SIMPLIFY, SYM/FACTOR, SYM/EXPAND, SYM/COLLECT.


%   Copyright 1993-2009 The MathWorks, Inc.
