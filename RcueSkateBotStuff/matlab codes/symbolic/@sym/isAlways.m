function Y = isAlways(X,varargin)
%isAlways     Test mathematical statement
%   Y = isAlways(X) converts each element of the symbolic
%   array X into the value true or false. If the statement
%   is not true or false for all values of all free variables
%   then false is returned. isAlways tests a statement by using 
%   assumptions and mathematical simplifications. Nontrivial 
%   constants are compared using floating-point approximations 
%   and may change results based on the value of the current
%   precision. See DIGITS for more information.
%
%   Y = isAlways(X,'PARAM1',val1,...)  can
%   be used to specify one or more of the following parameter
%   name/value pairs:
%
%     Parameter        Value
%     'Unknown'        Specify the behavior for unknown equalities with one of
%                      these strings: 'false', 'true', or 'error'. By default,
%                      the value is 'false', and isAlways returns false for
%                      unknown results. If you specify 'true', isAlways returns
%                      true for unknown results. If you specify 'error', it
%                      throws an error for unknown results.
%
%   See also: SYM/LOGICAL

%   Copyright 2011 MathWorks, Inc.

if builtin('numel',X) ~= 1,  X = normalizesym(X);  end
persistent argparser;
if isempty(argparser)
    argparser = inputParser;
    argparser.addParamValue('Unknown','false',@checkValues);
end
argparser.parse(varargin{:});
p = argparser.Results;
isMath = 'TRUE';
Y = mupadmex('symobj::isAlways',X.s,isMath,['"Unknown' p.Unknown '"'],9);
end

function checkValues(x)
if ~any(strcmp(x,{'false', 'true', 'error'}))
  error(message('symbolic:sym:TrueFalseErrorExpected'));  
end
end 

