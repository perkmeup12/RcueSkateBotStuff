function res = isAllVars(expr)
%  isAllVars(expr)
% 
%  Private helper function to check if a matrix consists of variables 
%  (e.g. to perform differentiation).

%   Copyright 2013 The MathWorks, Inc.

res = strcmp(mupadmex('symobj::isAllVars',expr.s,0),'TRUE');
end
