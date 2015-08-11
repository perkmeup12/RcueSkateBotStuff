function r = simplifyFraction(s,varargin)
%simplifyFraction Symbolic simplification of fractions.
%   SIMPLIFYFRACTION(S)  returns a simplified form of the rational   
%   expression S. Simplified form means that both numerator and denominator 
%   are polynomials whose greatest common divisor is 1.
%
%   SIMPLIFYFRACTION(S,'Expand',true) returns numerator and denominator 
%   in expanded form whereas SIMPLIFYFRACTION(S,'Expand',false) (which is 
%   the default) will not expand numerator and denominator completely. 
%   
%   Examples:
%      simplifyFraction((x^2-1)/(x+1))  
%      returns x-1
%
%      simplifyFraction(((y+1)^3*x)/((x^3-x*(x+1)*(x-1))*y))  
%      returns (y+1)^3/y
% 
%      simplifyFraction(((y+1)^3*x)/((x^3-x*(x+1)*(x-1))*y),'Expand',true)  
%      returns (y^3+3*y^2+3*y+1)/y 
%
%   See also SYM/SIMPLIFY, SYM/SIMPLE, SYM/FACTOR, SYM/COLLECT, SYM/EXPAND.

%   Copyright 2011 The MathWorks, Inc.

% parse arguments, step 1: Look for options
narg = nargin-1;
args = varargin;
% default:
options = 'null()';
k = 1;
while k <= size(args, 2)
  v = args{k};
  if ischar(v) && strcmpi(v, 'Expand')
    if k == size(args, 2);
      error(message('symbolic:sym:optRequiresArg', v))
    end
    value = args{k+1};
    if value == true
      value = 'TRUE';
    elseif value == false
      value = 'FALSE';
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end
    if strcmp(value, 'TRUE')
      options = [options ', Expand']; %#ok<AGROW>
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

s = privResolveArgs(s);
s = s{1};
rSym = mupadmex('symobj::map',s.s,'normal',options);
r = privResolveOutput(rSym, s);
