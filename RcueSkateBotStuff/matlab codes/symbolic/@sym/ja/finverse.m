%FINVERSE  �t�֐�
%
%   g = FINVERSE(f) �́Af �̋t�֐���Ԃ��܂��Bf �́A1 �̃V���{���b�N�ϐ��A
%   ������ 'x' �̊֐���\�킷�V���{���b�N���ł��B���̂Ƃ��Ag �� g(f(x)) = x ��
%   �������V���{���b�N���ł��B
%
%   g = FINVERSE(f, v) �́A�Ɨ��ϐ��Ƃ��ăV���{���b�N�ϐ� v ���g���܂��B
%   ���̂Ƃ��Ag �� g(f(v)) = v �𖞂����V���{���b�N���ł��Bf ��������
%   �V���{���b�N�ϐ����܂�ł���Ƃ��ɁA���̃t�H�[���g�p���܂��B
%
%   �t�֐����Ȃ��ꍇ�Ag �͋�� sym �I�u�W�F�N�g�A�܂��́Af ���������̏ꍇ�� 
%   RootOf ���̂����ꂩ�ɂȂ�܂��B
%
%   ��:
%      finverse(1/tan(x)) �� atan(1/x) ��Ԃ��܂��B
%
%      f = x^2+y;
%      finverse(f, y) �� -x^2+y ��Ԃ��܂��B
%      finverse(f) �� (x - y)^(1/2) ��Ԃ��A�t�֐����ŗL�łȂ����Ƃ�����
%        �x����\�����܂��B
%
%   �Q�l SYM/COMPOSE.


%   Copyright 1993-2009 The MathWorks, Inc.
