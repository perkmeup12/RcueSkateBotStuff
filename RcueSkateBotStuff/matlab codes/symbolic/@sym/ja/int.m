%INT  �ϕ�
%
%   INT(S) �́AFINDSYM �Œ�`�����悤�ȃV���{���b�N�ϐ��ɂ��Ă� S ��
%     �s��ϕ��ł��BS �́A�V���{���b�N�I�u�W�F�N�g (�s��܂��̓X�J��) �ł��B
%     S ���萔�̏ꍇ�A�ϕ��́A'x' �ɂ��Čv�Z����܂��B
%   INT(S, v) �́Av �ɂ��Ă� S �̕s��ϕ��ł��Bv �́A�X�J���̃V���{���b�N
%     �I�u�W�F�N�g�ł��B
%   INT(S,a,b) �́A���̃V���{���b�N�ϐ��ɂ��Ă� a ���� b �܂ł� S �̒�ϕ�
%     ���`���܂��Ba �� b �́A���ꂼ�� double �܂��̓V���{���b�N�ȃX�J���ł��B
%   INT(S, v, a, b) �́Av �ɂ��Ă� a ���� b �܂ł� S �̒�ϕ��ł��B
%
%   ��:
%     syms x x1 alpha u t;
%     A = [cos(x*t),sin(x*t);-sin(x*t),cos(x*t)];
%     int(1/(1+x^2)) �� atan(x) ��Ԃ��܂��B
%     int(sin(alpha*u),alpha) �� -cos(alpha*u)/u ��Ԃ��܂��B
%     int(besselj(1,x),x) �� -besselj(0,x) ��Ԃ��܂��B
%     int(x1*log(1+x1),0,1) �� 1/4 ��Ԃ��܂��B
%     int(4*x*t,x,2,sin(t)) �� -2*t*cos(t)^2 - 6*t ��Ԃ��܂��B
%     int([exp(t),exp(alpha*t)]) �� [ exp(t), exp(alpha*t)/alpha] ��Ԃ��܂��B
%     int(A,t) �� [sin(t*x)/x, -cos(t*x)/x] ��Ԃ��܂��B
%                 [cos(t*x)/x,  sin(t*x)/x]


%   Copyright 1993-2009 The MathWorks, Inc.
