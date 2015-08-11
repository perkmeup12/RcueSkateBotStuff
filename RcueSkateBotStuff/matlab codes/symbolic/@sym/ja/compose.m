%COMPOSE  �֐��̍���
%
%   COMPOSE(f,g) �́Af(g(y)) ��Ԃ��܂��B�����ŁAf = f(x) �� g = g(y) �ł��B
%   x �� FINDSYM �Œ�`�����悤�� f �̃V���{���b�N�ϐ��ŁAy �� FINDSYM ��
%   ��`�����悤�� g �̃V���{���b�N�ϐ��ł��B
%
%   COMPOSE(f,g,z) �� f(g(z)) ��Ԃ��܂��B�����ŁAf = f(x) �� g = g(y) �ł��B
%   x �� y �́AFINDSYM �Œ�`�����悤�� f �� g �̃V���{���b�N�ϐ��ł��B
%
%   COMPOSE(f,g,x,z) �́Af(g(z)) ��Ԃ��Ax �� f �ɑ΂���Ɨ��ϐ��Ƃ��܂��B
%   ���Ȃ킿�Af = cos(x/t) �̏ꍇ�ACOMPOSE(f,g,x,z) �́Acos(g(z)/t) ��Ԃ��܂��B
%   ����ACOMPOSE(f,g,t,z) �́Acos(x/g(z)) ��Ԃ��܂��B
%
%   COMPOSE(f,g,x,y,z) �́Af(g(z)) ��Ԃ��Ax �� y �����ꂼ�� f �� g �ɑ΂���
%   �Ɨ��ϐ��Ƃ��܂��Bf = cos(x/t) �� g = sin(y/u) �̏ꍇ�ACOMPOSE(f,g,x,y,z) 
%   �� cos(sin(z/u)/t) ��Ԃ��ACOMPOSE(f,g,x,u,z) �� cos(sin(y/z)/t) ��
%   �Ԃ��܂��B
%
%   ��:
%    syms x y z t u;
%    f = 1/(1 + x^2); g = sin(y); h = x^t; p = exp(-y/u);
%    compose(f,g)        ��  1/(sin(y)^2 + 1)  ��Ԃ��܂��B
%    compose(f,g,t)      ��  1/(sin(t)^2 + 1)  ��Ԃ��܂��B
%    compose(h,g,x,z)    ��  sin(z)^t          ��Ԃ��܂��B
%    compose(h,g,t,z)    ��  x^sin(z)          ��Ԃ��܂��B
%    compose(h,p,x,y,z)  ��  (1/exp(z/u))^t    ��Ԃ��܂��B
%    compose(h,p,t,u,z)  ��  x^(1/exp(y/z))    ��Ԃ��܂��B
%
%   �Q�l SYM/FINVERSE, SYM/FINDSYM, SYM/SUBS.


%   Copyright 1993-2009 The MathWorks, Inc.
