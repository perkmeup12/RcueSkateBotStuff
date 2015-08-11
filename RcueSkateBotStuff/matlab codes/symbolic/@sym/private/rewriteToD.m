function res = rewriteToD(expr)
%  rewriteToD(expr)
% 
%  Private helper function to rewrite expressions in terms of MuPAD's 
%  differential operator D. In case expr does not contain any derivatives, 
%  applying rewriteToD does not have any effect. 

%   Copyright 2013 The MathWorks, Inc.

res = feval(symengine,'rewrite',expr,'D');

end
