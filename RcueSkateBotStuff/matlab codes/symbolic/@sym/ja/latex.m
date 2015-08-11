%LATEX  シンボリック式の LaTeX 表現
%
%   LATEX(S) は、シンボリック式 S の LaTeX 表現を返します。
%
%   例:
%      syms x
%      f = taylor(log(1+x));
%      latex(f) =
%         \frac{x^5}{5} - \frac{x^4}{4} + \frac{x^3}{3} - \frac{x^2}{2} + x
%
%      H = sym(hilb(3));
%      latex(H) =
%        \left(\begin{array}{ccc} 1 & \frac{1}{2} & \frac{1}{3}\\
%        \frac{1}{2} & \frac{1}{3} & \frac{1}{4}\\ \frac{1}{3} &
%        \frac{1}{4} & \frac{1}{5} \end{array}\right)
%
%      syms alpha t
%      A = [alpha t alpha*t];
%      latex(A) =
%        \left(\begin{array}{ccc} \mathrm{alpha} & t & \mathrm{alpha}\,
%        t \end{array}\right)
%
%   参考 SYM/PRETTY, SYM/CCODE, SYM/FORTRAN.


%   Copyright 1993-2009 The MathWorks, Inc.
