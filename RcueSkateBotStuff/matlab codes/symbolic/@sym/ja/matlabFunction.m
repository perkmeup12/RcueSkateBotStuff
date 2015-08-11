%matlabFunction  sym ���� MATLAB �t�@�C���܂��͖����֐��̐���
%
%   G = matlabFunction(F) �́Asym �I�u�W�F�N�g F ���� MATLAB �̖����֐���
%   �������܂��BF �̎��R�ϐ��́A�֐��n���h�� G �̌��ʂɑ΂�����͂ɂȂ�܂��B
%   ���Ƃ��΁Ax �� F �̎��R�ϐ��Ƃ���Ƃ��AMATLAB ��� G(z) �����s����ƁA
%   �����G���W����� subs(F,x,z) ���s�����ƂƓ��l�̌��ʂ������܂��B
%   �֐��n���h�� G �́AMATLAB �ɂ���֐� FZERO �̂悤�Ɉ������Ƃ��ł��A
%   �܂��́A���̃c�[���{�b�N�X���̊֐��Ŏg�p���邱�Ƃ��ł��܂��B
%   G �̓��͂̏��Ԃ́Asymvar(F) �ŕԂ���鏇�ƈ�v���܂��B
%
%   G = matlabFunction(F1,F2,...,FN) �́AF1 ���� FN �܂ł� N �̏o�͂����� 
%   MATLAB �֐��𐶐����܂��B
%
%   G = matlabFunction(...,PARAM1,VALUE1,...) �́A�������ꂽ�֐��̃p�����[�^��
%   �l�̑g���J�X�^�}�C�Y����ۂɎg�p���܂��B�p�����[�^�́A�����R�[�h���̐錾��
%   �C�����܂��B�����R�[�h�̃e���v���[�g�́A�ȉ��̂Ƃ���ł��B
%      function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   �p�����[�^���́A�ȉ��̂����ꂩ�ɂȂ�܂��B
%
%     'file': �l FILE �́A�L���� MATLAB �֐�������������łȂ���΂Ȃ�܂���B
%             FILE �̍Ōオ '.m' �łȂ��ꍇ�� '.m' ��ǉ����܂��B�t�@�C����
%             ���ɑ��݂���ꍇ�́A�㏑������܂��B���̊֐��̊֐��n���h���́A
%             G �ɕԂ���܂��B�t�@�C�����̃p�����[�^����̏ꍇ�A�����֐���
%             ��������܂��B�֐��e���v���[�g���� NAME �́AFILE ���̃t�@�C�����ł��B
%
%  'outputs': �l�͊֐��e���v���[�g���̏o�͕ϐ��̖��O OUT1, OUT2,... OUTN ��
%             �w�肷�� N �̕�����̃Z���z��łȂ���΂Ȃ�܂���BOUTk ��
%             �΂���f�t�H���g�̏o�͒[�q���� Fk �̕ϐ����A�܂��́AFk �� 
%             simple variable �ł͂Ȃ��ꍇ�� 'outk' �ł��B'file' �p�����[�^��
%             �^�����Ȃ��ꍇ�A'outputs' �p�����[�^�͖�������܂��B
%
%     'vars': �l IN �͈ȉ��̂����ꂩ�łȂ���΂Ȃ�܂���B
%                1) M �̕�����̃Z���z��܂��� sym �z��
%                2) M �̃V���{���b�N�ϐ��̃x�N�g��
%             IN �́A�֐��e���v���[�g���̓��͂̕ϐ����Ɠ��͂̏��� IN1, 
%             IN2,... INM ���w�肵�܂��BINj �� sym �z��̏ꍇ�A�֐��e���v���[�g��
%             �g���閼�O�� 'inj' �ɂȂ�܂��BIN �Ƀ��X�g�����ϐ��́AFk ��
%             ���ׂĂɂ����鎩�R�ϐ��̏�ʏW���łȂ���΂Ȃ�܂���B
%             IN �̃f�t�H���g�l�́AFk �̂��ׂĂɂ����鎩�R�ϐ��̘a�W���ł��B
%
%   ����: ���ׂĂ� MuPAD ���� MATLAB �֐��ɕϊ������킯�ł͂���܂���B
%   ���Ƃ��΁A�敪�I�Ȏ��ƏW���͕ϊ�����܂���B
%
%   ��:
%     syms x y
%     r = x^2+y^2;
%     f = log(r)+1/r;
%     matlabFunction(f,'file','sample')
%     type sample.m
%       function f = sample(x,y)
%       %SAMPLE
%       %    F = SAMPLE(X,Y)
%       t7 = x.^2;
%       t8 = y.^2;
%       t9 = t7 + t8;
%       f = log(t9)+1./t9;
%
%     % Van der Pol �� ODE �ɑ΂��� sym �����쐬���Aode45 ���g�p���ĉ����܂��B
%     % �����āA����̏��������ɑ΂�������v���b�g���܂��B
%     syms t x y
%     mu = 1;
%     vdp = [y; mu*(1-x^2)*y-x];
%     % �������ꂽ�֐��ɂ� 2 �̓��͂�����A2 �Ԗڂ̓��͂̍s�� x �� y ��
%     % �ϐ��Ƀ}�b�s���O����܂��Bode45 �֐��́A���͊֐������̌`���ɂ���
%     % �K�v������܂��B
%     vdpf = matlabFunction(vdp,'vars',{t,[x;y]});
%     % vdpf �� @(t,in2)[in2(2,:);-in2(1,:)-in2(2,:).*(in2(1,:).^2-1)] �ɂȂ�
%     �܂��B
%     % ode45 �ɏ������� [2 0] �Ŋ֐��n���h����n���A���ʂ��v���b�g���܂��B
%     [ts,ys] = ode45(vdpf,[0 20],[2 0]);
%     plot(ts,ys(:,1))
%
%     % �V���{���b�N mu ���g���� Van der Pol �� ODE �ɑ΂��� sym �����쐬���A
%     % sym ������ 'vdp2' �Ƃ������O�� MATLAB �t�@�C���𐶐����܂��B
%     syms mu x y
%     vdp = [y; mu*(1-x^2)*y-x];
%     % ���� x, y, mu �� dvdt �Ƃ������O�̏o�͕ϐ��Ńt�@�C�� vdp2.m ��
%     % �������܂��B
%     matlabFunction(vdp,'file','vdp2','vars',[x y mu],'outputs',{'dvdt'});
%     type vdp2
%       function dvdt = vdp2(x,y,mu)
%       %VDP2
%       %    DVDT = VDP2(X,Y,MU)
%       dvdt = [y;- x - mu.*y.*(x.^2 - 1)];
%
%   �Q�l: function_handle, subs, fzero, ode45


%   Copyright 2008-2009 The MathWorks, Inc.
