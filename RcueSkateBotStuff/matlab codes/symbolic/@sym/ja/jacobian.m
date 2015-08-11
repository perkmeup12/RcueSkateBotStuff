%JACOBIAN  ヤコビ行列
%
%   JACOBIAN(f, v) は、ベクトル v について、スカラ、または、ベクトル f の
%   ヤコビアンを計算します。結果の (i, j) 要素は、df(i)/dv(j) です。
%   f がスカラのとき、f のヤコビアンは f の勾配であることに注意してください。
%   また、これは、DIFF(f, v) と同じですが、スカラ v を使うことができます。
%
%   例:
%       jacobian([x*y*z; y; x+z],[x y z])
%       jacobian(u*exp(v),[u;v])
%
%   参考 SYM/DIFF.


%   Copyright 1993-2008 The MathWorks, Inc.
