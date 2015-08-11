function Z = null(A)
%NULL   Basis for null space.
%   The columns of Z = NULL(A) form a basis for the null space of A.
%   SIZE(Z,2) is the nullity of A.
%   A*Z is zero.
%   If A has full rank, Z is empty.
%
%   Example:
%
%     null(sym(magic(4))) is
% 
%     -1
%     -3
%      3
%      1
%
%   See also SYM/COLSPACE.

%   Copyright 1993-2011 The MathWorks, Inc.

if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
if any(any(~isfinite(A))) 
    error(message('symbolic:sym:InputMustNotContainNaNOrInf')); 
elseif all(size(formula(A)) == 1)
   if A == 0
      Z = sym(1); 
   else
      Z = sym([]); 
   end
else
   Zsym = mupadmex('symobj::nullspace',A.s);
   Z = privResolveOutput(Zsym, A);
end
