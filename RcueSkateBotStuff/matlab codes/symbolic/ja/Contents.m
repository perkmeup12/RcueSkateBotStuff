% Symbolic Math Toolbox
% Version 6.0 (R2014a) 27-Dec-2013
%
% �v�Z
%   diff        - ����
%   int         - �ϕ�
%   limit       - �Ɍ��l
%   taylor      - �e�C���[����
%   jacobian    - ���R�r�s��
%   symsum      - �����̑��a
%
% ���`�㐔
%   diag        - �Ίp�s��̍쐬�A�܂��́A�Ίp�����̒��o
%   triu        - ��O�p�s��
%   tril        - ���O�p�s��
%   inv         - �t�s��
%   det         - �s��
%   rank        - �����N
%   rref        - �s��̊Ȗ�
%   null        - �k����Ԃɑ΂�����
%   colspace    - ���Ԃɑ΂�����
%   eig         - �ŗL�l�ƌŗL�x�N�g��
%   svd         - ���ْl�Ɠ��كx�N�g��
%   jordan      - Jordan �����^
%   poly        - ����������
%   expm        - �s��w��
%   mldivide    - \  �s��̍����Z
%   mpower      - ^  �s��ׂ̂���
%   mrdivide    - /  �s��̏��Z
%   mtimes      - *  �s��̏�Z
%   transpose   - .' �s��̓]�u
%   ctranspose  - '  �s��̕��f����]�u
%
% �ȗ���
%   simplify    - �ȗ���
%   expand      - �W�J
%   factor      - ��������
%   collect     - �W�����܂Ƃ߂�
%   simple      - �ł��Z���\���̌���
%   numden      - ���q�ƕ���
%   horner      - ����q�̑������\��
%   subexpr     - ���ʂ��镔�����ɂ�鎮�̏�������
%   coeffs      - ���ϐ��������̌W�����o
%   sort        - �V���{���b�N�x�N�g�����邢�͑������̕��בւ�
%   subs        - �V���{���b�N�ȑ��
%
% �������̉�@
%   solve       - �㐔�������̃V���{���b�N�ȉ�
%   dsolve      - �����������̃V���{���b�N�ȉ�
%   finverse    - �t�֐�
%   compose     - �֐��̍���
%
% �ϐ��x�̉��Z
%   vpa         - �ϐ��x�̉��Z
%   digits      - �ϐ��x�̐ݒ�
%
% �ϕ��ϊ�
%   fourier     - �t�[���G�ϊ�
%   laplace     - ���v���X�ϊ�
%   ztrans      - Z-�ϊ�
%   ifourier    - �t�t�[���G�ϊ�
%   ilaplace    - �t���v���X�ϊ�
%   iztrans     - �t Z-�ϊ�
%
% �ϊ�
%   double      - �V���{���b�N�s���{���x�ɕϊ�
%   single      - �V���{���b�N�s���P���x�ɕϊ�
%   poly2sym    - �W���x�N�g�����V���{���b�N�������ɕϊ�
%   sym2poly    - �V���{���b�N���������W���x�N�g���ɕϊ�
%   char        - �V���{���b�N�I�u�W�F�N�g�𕶎���ɕϊ�
%   int8        - �����t�� 8 �r�b�g�����ɕϊ�
%   int16       - �����t�� 16 �r�b�g�����ɕϊ�
%   int32       - �����t�� 32 �r�b�g�����ɕϊ�
%   int64       - �����t�� 64 �r�b�g�����ɕϊ�
%   uint8       - �����Ȃ� 8 �r�b�g�����ɕϊ�
%   uint16      - �����Ȃ� 16 �r�b�g�����ɕϊ�
%   uint32      - �����Ȃ� 32 �r�b�g�����ɕϊ�
%   uint64      - �����Ȃ� 64 �r�b�g�����ɕϊ�
%
% ��{���Z
%   sym         - �V���{���b�N�I�u�W�F�N�g�̍쐬
%   syms        - �V���{���b�N�I�u�W�F�N�g�쐬�̃V���[�g�J�b�g
%   findsym     - �V���{���b�N�ϐ��̌���
%   pretty      - �V���{���b�N���̊ȈՏo��
%   latex       - �V���{���b�N���� LaTeX �\��
%   texlabel    - �����񂩂� TeX �`���̐���
%   ccode       - �V���{���b�N���� C �R�[�h�\��
%   fortran     - �V���{���b�N���� Fortran �\��
%   matlabFunction - �V���{���b�N������ MATLAB �֐��𐶐�
%   emlBlock    - Embedded MATLAB Simulink �u���b�N�𐶐�
%
% ���w����ё㐔�̉��Z
%   plus        - +  ���Z
%   minus       - -  ���Z
%   uminus      - -  �ے�
%   times       - .* �z��̏�Z
%   ldivide     - \  �����Z
%   rdivide     - /  ���Z
%   power       - .^ �z��ׂ̂���
%   abs         - ��Βl
%   ceil        - �؂�グ (Ceiling)
%   conj        - ����
%   colon       - �R�������Z�q
%   fix         - ������
%   floor       - �؂�̂� (Floor)
%   frac        - ������
%   mod         - ��]
%   round       - �ۂ�
%   quorem      - ���Ɨ]��
%   imag        - ������
%   real        - ������
%   exp         - �w��
%   log         - ���R�ΐ�
%   log10       - ��p�ΐ�
%   log2        - 2 ���Ƃ����ΐ�
%   sqrt        - ������
%   prod        - �v�f�̐�
%   sum         - �v�f�̘a
%
% �_�����Z�q
%   isreal      - �����z��̌��o
%   eq          - ����
%   ne          - �s����
%
% ����֐�
%   besseli     - �x�b�Z���֐� I
%   besselj     - �x�b�Z���֐� J
%   besselk     - �x�b�Z���֐� K
%   bessely     - �x�b�Z���֐� Y
%   erf         - �덷�֐�
%   sinint      - �����ϕ��֐�
%   cosint      - �]���ϕ��֐�
%   zeta        - ���[�}���� zeta �֐�
%   gamma       - �V���{���b�N�ȃK���}�֐�
%   gcd         - �ő����
%   lcm         - �ŏ����{��
%   hypergeom   - ��ʒ��􉽊֐�
%   lambertw    - �����x���g�� W �֐�
%   dirac       - �f���^�֐�
%   heaviside   - �X�e�b�v�֐�
%
% �O�p�֐�
%
%   acos        - �t�]��
%   acosh       - �t�o�Ȑ��]��
%   acot        - �t����
%   acoth       - �t�o�Ȑ�����
%   acsc        - �t�]��
%   acsch       - �t�o�Ȑ��]��
%   asec        - �t����
%   asech       - �t�o�Ȑ�����
%   asin        - �t����
%   asinh       - �t�o�Ȑ�����
%   atan        - �t����
%   atanh       - �t�o�Ȑ�����
%   cos         - �]��
%   cosh        - �o�Ȑ��]��
%   cot         - �]��
%   coth        - �o�Ȑ��]��
%   csc         - �]��
%   csch        - �o�Ȑ��]��
%   sec         - ����
%   sech        - �o�Ȑ�����
%   sin         - ����
%   sinh        - �o�Ȑ�����
%   tan         - ����
%   tanh        - �o�Ȑ�����
%
% ������̎�舵���̃��[�e�B���e�B
%   isvarname   - �L���ȕϐ����̃`�F�b�N(MATLAB TOOLBOX)
%   vectorize   - �V���{���b�N���̃x�N�g����
%   disp        - sym ���e�L�X�g�Ƃ��ĕ\��
%   display     - �֐��� syms �Ƃ��ĕ\��
%   eval        - �V���{���b�N�\���̕]��
%
% ����I�ȃO���t�B�J���A�v���P�[�V����
%   rsums       - ���[�}���a
%   ezcontour   - �ȒP�ȓ������}
%   ezcontourf  - �ȒP�ȓh��Ԃ��������}
%   ezmesh      - �ȒP�ȃ��b�V��(�\��) �v���b�g
%   ezmeshc     - ���b�V���Ɠ������̊ȒP�ȑg�ݍ��킹�v���b�g
%   ezplot      - �֐��̊ȒP�ȃv���b�g
%   ezplot3     - 3 �����p�����g���b�N�Ȑ��̊ȒP�ȃv���b�g
%   ezpolar     - �ȒP�ȋɍ��W�v���b�g
%   ezsurf      - �ȒP�ȕ\�ʃv���b�g
%   ezsurfc     - �\�ʂƓ������̊ȒP�ȑg�ݍ��킹�v���b�g
%   funtool     - �֐��v�Z�@
%   taylortool  - �e�C���[�����v�Z�@
%
% �f��
%   symintro    - Symbolic Toolbox �̏Љ�
%   symcalcdemo - �v�Z�̃f��
%   symlindemo  - �V���{���b�N�Ȑ��`�㐔�̃f��
%   symvpademo  - �ϐ��x�̉��Z�̃f��
%   symrotdemo  - ���ʉ�]�̖��
%   symeqndemo  - �V���{���b�N�Ȏ��̉�@�̃f��
%   mupadDemo   - MuPAD �m�[�g�u�b�N�f���̋N��
%
% MuPAD �ւ̃A�N�Z�X
%   mupadwelcome - MuPAD �� Welcome ���
%   mupad       - MuPAD �m�[�g�u�b�N�C���^�t�F�[�X�̋N��
%   getVar      - MuPAD �m�[�g�u�b�N����ϐ����擾
%   setVar      - MuPAD �m�[�g�u�b�N���̕ϐ���ݒ�
%   symengine   - sym �I�u�W�F�N�g�ɑ΂��� MuPAD �G���W���̃C���^�t�F�[�X

%   Copyright 1993-2013 The MathWorks, Inc. 
