%emlBlock  Embedded MATLAB �u���b�N�̐���
%
%   emlBlock(BLOCK,F) �́ABLOCK �Ƃ����p�X������ 'Embedded MATLAB Function' 
%   �u���b�N�𐶐����AF ���� matlabFunction ����Đ������ꂽ MATLAB �R�[�h��
%   �u���b�N�Ƃ��Ē�`���܂��BBLOCK �����݂���ꍇ�́A����� EML �u���b�N��
%   �Ȃ���΂Ȃ�܂���B�܂��A�����̃u���b�N��`�� F �ƒu���������܂��B
%
%   emlBlock(BLOCK,F1,F2,...,FN) �́AF1 ���� FN �܂ł� N �̏o�͂����� 
%   EML �u���b�N�𐶐����܂��B�u���b�N�̓��͂Əo�͂́A�u���b�N��`�� 
%   MATLAB �֐��̓��o�͂Ɠ����ł��B
%
%   emlBlock(...,PARAM1,VALUE1,...) �́A�������ꂽ�u���b�N�̃p�����[�^��
%   �l�̑g��ύX����ۂɎg�p���܂��B�p�����[�^�́A�����R�[�h���̊֐��錾��
%   �J�X�^�}�C�Y���܂��B�����R�[�h�̃e���v���[�g�́A�ȉ��̂Ƃ���ł��B
%       function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   �p�����[�^���́A�ȉ��̂����ꂩ�ɂȂ�܂��B
%
%   'functionName': �l NAME �͕�����łȂ���΂Ȃ�܂���B
%             �f�t�H���g�́A�u���b�N BLOCK �̖��O�ł��B
%
%  'outputs': �l�͊֐��e���v���[�g���̏o�͕ϐ��̖��O OUT1, OUT2,... OUTN ��
%             �w�肷�� N �̕�����̃Z���z��łȂ���΂Ȃ�܂���BOUTk ��
%             �΂���f�t�H���g�̏o�͒[�q���� Fk �̕ϐ����A�܂��́AFk �� 
%             simple variable �ł͂Ȃ��ꍇ�� 'outk' �ł��B
%
%     'vars': �l IN �͈ȉ��̂����ꂩ�łȂ���΂Ȃ�܂���B
%                1) M �̕�����̃Z���z��܂��� sym �z��
%                2) M �̃V���{���b�N�ϐ��̃x�N�g��
%             IN �́A�֐��e���v���[�g���̓��͂̕ϐ����Ɠ��͂̏��� IN1, 
%             IN2,... INM ���w�肵�܂��BINj �� sym �z��̏ꍇ�A�֐��e���v���[�g��
%             �g���閼�O�� 'inj' �ɂȂ�܂��BIN �Ƀ��X�g�����ϐ��́AFk ��
%             ���ׂĂɂ����鎩�R�ϐ��̏�ʏW���łȂ���΂Ȃ�܂���BIN ��
%             �f�t�H���g�l�́AFk �̂��ׂĂɂ����鎩�R�ϐ��̘a�W���ł��B
%
%   ����: ���ׂĂ� MuPAD ���� MATLAB �֐��ɕϊ������킯�ł͂���܂���B
%   ���Ƃ��΁A�敪�I�Ȏ��ƏW���͕ϊ�����܂���B
%
%   ��:
%      syms x y
%      f = x^2 + y^2;
%      new_system('mysys'); open_system('mysys');
%      emlBlock('mysys/f',f);
%
%   �Q�l: matlabFunction, simulink


%   Copyright 2008-2009 The MathWorks, Inc.
