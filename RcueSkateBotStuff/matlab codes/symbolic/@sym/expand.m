function r = expand(s,varargin)
%EXPAND Symbolic expansion.
%   EXPAND(S) writes each element of a symbolic expression S as a
%   product of its factors.  EXPAND is most often used on polynomials,
%   but also expands trigonometric, exponential and logarithmic functions.
%
%   EXPAND(S,'ArithmeticOnly',true) limits expansion to basic arithmetic,
%   whereas EXPAND(S,'ArithmeticOnly',false) (which is the default) will
%   also expand trigonometric and other special functions.
%   
%   EXPAND(S,'IgnoreAnalyticConstraints',VAL) controls the level of 
%   mathematical rigor to use on the analytical constraints while simplifying 
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or 
%   FALSE. Specify TRUE to relax the level of mathematical rigor
%   in the rewriting process. The default is FALSE.
%
%   Examples:
%      expand((x+1)^3)   returns  x^3+3*x^2+3*x+1
%      expand(sin(x+y))  returns  sin(x)*cos(y)+cos(x)*sin(y)
%      expand(exp(x+y))  returns  exp(x)*exp(y)
%      expand((exp(x+y)+1)^2,'ArithmeticOnly',true)
%                        returns  exp(2*x + 2*y) + 2*exp(x + y) + 1
%      expand(log(x*y))  returns  log(x*y)
%      expand(log(x*y),'IgnoreAnalyticConstraints',true)
%                        returns  log(x)+log(y)
%
%   See also SYM/SIMPLIFY, SYM/SIMPLE, SYM/FACTOR, SYM/COLLECT.

%   Copyright 1993-2011 The MathWorks, Inc.

% parse arguments, step 1: Look for options
narg = nargin-1;
args = varargin;
% default:
options = 'null()';
k = 1;
while k <= size(args, 2)
  v = args{k};
  if ischar(v) && any(strcmpi(v, {'IgnoreAnalyticConstraints', 'ArithmeticOnly'}))
    if k == size(args, 2);
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if value == true
      value = 'TRUE';
    elseif value == false
      value = 'FALSE';
    elseif strcmpi(v, 'IgnoreAnalyticConstraints') && isa(value, 'char')
      if strcmpi(value, 'all')
        value = 'TRUE';
      elseif strcmpi(value, 'none')
        value = 'FALSE';
      else
        error(message('symbolic:sym:badArgForOpt', v))
      end
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    % expand does not expect option=value for its two boolean options
    if strcmp(value, 'TRUE')
      if strcmpi(v, 'IgnoreAnalyticConstraints')
        options = [options ', IgnoreAnalyticConstraints']; %#ok<AGROW>
      else
        options = [options ', ArithmeticOnly']; %#ok<AGROW>      
      end  
    end
    args(k:k+1) = [];
    narg = narg - 2;
  elseif ischar(v) && strcmpi(v, 'MaxExponent')
    if k == size(args, 2)
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if isnumeric(value) && 0 <= value && round(value) == value
      options = [options ', MaxExponent =' int2str(value)]; %#ok<AGROW>
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    args(k:k+1) = [];
    narg = narg - 2;
  else
    k = k+1;
  end
end

if narg > 0
  error(message('symbolic:sym:maxrhs'))
end

r = privUnaryOp(s, 'symobj::map', 'expand', options);
