%SYMS  �V���{���b�N�I�u�W�F�N�g�쐬�̃V���[�g�J�b�g
%
%   SYMS arg1 arg2 ...
%   �́A�ȉ��̃X�e�[�g�����g�̒Z�k�`�ł��B
%      arg1 = sym('arg1');
%      arg2 = sym('arg2'); ...
%
%   SYMS arg1 arg2 ... real
%   �́A�ȉ��̃X�e�[�g�����g�̒Z�k�`�ł��B
%      arg1 = sym('arg1','real');
%      arg2 = sym('arg2','real'); ...
%
%   SYMS arg1 arg2 ... positive
%   �́A�ȉ��̃X�e�[�g�����g�̒Z�k�`�ł��B
%      arg1 = sym('arg1','positive');
%      arg2 = sym('arg2','positive'); ...
%
%   SYMS arg1 arg2 ... clear
%   �́A�ȉ��̃X�e�[�g�����g�̒Z�k�`�ł��B
%      arg1 = sym('arg1','clear');
%      arg2 = sym('arg2','clear'); ...
%
%   �e���͈����́A�����Ŏn�܂�A�p�����݂̂��܂܂Ȃ���΂Ȃ�܂���B
%
%   SYMS �����ł́A���[�N�X�y�[�X���̃V���{���b�N�I�u�W�F�N�g�����X�g���܂��B
%
%   ��:
%      syms x beta real
%   �́A�ȉ��Ɠ����ł��B
%      x = sym('x','real');
%      beta = sym('beta','real');
%
%      syms k positive
%   �́A�ȉ��Ɠ����ł��B
%      k = sym('k','positive');
%
%   'real' ��Ԃ̃V���{���b�N�I�u�W�F�N�g x �� beta ���������邽�߂ɂ́A
%   �ȉ��̂悤�ɓ��͂��܂��B
%      syms x beta clear
%
%   �Q�l SYM.


%   Copyright 1993-2009 The MathWorks, Inc.
