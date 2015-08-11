function [r,h] = simple(s,varargin)
%SIMPLE Search for simplest form of a symbolic expression or matrix.
%   SIMPLE(S) tries several different algebraic simplifications of
%   S, displays any which shorten the length of S's representation,
%   and returns the shortest. S is a SYM. If S is a matrix, the result
%   represents the shortest representation of the entire matrix, which is 
%   not necessarily the shortest representation of each individual element.
%
%   [R,HOW] = SIMPLE(S) does not display intermediate simplifications,
%   but returns the shortest found, as well as a string describing
%   the particular simplification. R is a SYM. HOW is a string.
%   
%   SIMPLE(S,'IgnoreAnalyticConstraints',VAL) controls the level of 
%   mathematical rigor to use on the analytical constraints while simplifying 
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or 
%   FALSE. Specify TRUE to relax the level of mathematical rigor
%   in the rewriting process. The default is FALSE.
%

%
%   Examples:
%
%      S                          R                  How
%
%      cos(x)^2+sin(x)^2          1                  simplify
%      2*cos(x)^2-sin(x)^2        3*cos(x)^2-1       simplify
%      cos(x)^2-sin(x)^2          cos(2*x)           simplify
%      cos(x)+i*sin(x)            exp(i*x)           rewrite(exp)
%      (x+1)*x*(x-1)              x^3-x              simplify(100)
%      x^3+3*x^2+3*x+1            (x+1)^3            simplify
%      cos(3*acos(x))             4*x^3-3*x          simplify(100)
%      
%      simple(asin(sin(x)))                                   = asin(sin(x))
%      simple(asin(sin(x)),'IgnoreAnalyticConstraints',true)  = x
%
%   See also SYM/SIMPLIFY, SYM/FACTOR, SYM/EXPAND, SYM/COLLECT.

%   Copyright 1993-2012 The MathWorks, Inc.

% This function will be removed in a future version:
warning(message('symbolic:sym:simple:Deprecated'));
s = privResolveArgs(s);
s = s{1};
p = nargout == 0;
[rsym,h] = mupadSimple(s,p,varargin{:});
r = privResolveOutput(rsym, s);
end

function [r,h] = mupadSimple(s,p,varargin)
    h = '';
    r = s;
    x = symvar(s,1);

    % parse arguments: Look for options
    args = varargin;
    % default:
    options = 'null()';
    k = 1;
    while k <= size(args, 2)
      v = args{k};
      if ischar(v) && strcmpi(v, 'IgnoreAnalyticConstraints')
        if k == size(args, 2);
          error(message('symbolic:sym:optRequiresArg', v))
        end
        value = args{k+1};
        if value == true
          value = 'TRUE';
        elseif value == false
          value = 'FALSE';
        elseif strcmpi(v, 'IgnoreAnalyticConstraints') 
          if isa(value, 'char')
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
        else
          error(message('symbolic:sym:badarg', value))
        end
        options = [options ', IgnoreAnalyticConstraints =' value]; %#ok<AGROW>
        args(k:k+1) = [];
      else
        error(message('symbolic:sym:badarg', v))
      end
    end

    % Try the different simplifications.
    [r,h] = simpler('simplify',s,r,h,p,options);
    [r,h] = simpler('radsimp',s,r,h,p,'null()');

    [r,h] = simpler('simplify',s,r,h,p, options, 'Steps = 100');
    [r,h] = simpler('combine',s,r,h,p,options,'sincos');
    [r,h] = simpler('combine',s,r,h,p,options,'sinhcosh');
    [r,h] = simpler('combine',s,r,h,p,options,'ln');

    [r,h] = simpler('factor',s,r,h,p,'null()');
    [r,h] = simpler('expand',s,r,h,p,options);
    [r,h] = simpler('combine',s,r,h,p,options);

    [r,h] = simpler('rewrite',s,r,h,p,'null()','exp');
    [r,h] = simpler('rewrite',s,r,h,p,'null()','sincos');
    [r,h] = simpler('rewrite',s,r,h,p,'null()','sinhcosh');
    [r,h] = simpler('rewrite',s,r,h,p,'null()','tan');
    [r,h] = simpler('symobj::mwcos2sin',s,r,h,p,'null()');

    if ~isempty(x)
        [r,h] = simpler('collect',s,r,h,p,'null()',x);
    end
end

function [r,h] = simpler(how,s,r,h,p,options,x)
%SIMPLER Used by SIMPLE to shorten expressions.
%   SIMPLER(HOW,S,R,H,P,X) applies method HOW with optional parameter X
%   to expression S, prints the result if P is nonzero, compares the
%   length of the result with expression R, which was obtained with
%   method H, and returns the shortest string and corresponding method.

if nargin < 7
    [t,err] = mupadmex('symobj::map',s.s,how,options);
elseif ischar(x)
    [t,err] = mupadmex('symobj::map',s.s,how,x,options);
else
    [t,err] = mupadmex('symobj::map',s.s,how,x.s,options);
end

if err
    return;
end

if nargin == 7
   how = [how '(' char(x) ')'];
end

how = strrep(how,'symobj::','');

if p 
   loose = isequal(get(0,'FormatSpacing'),'loose');
   if loose, disp(' '), end
   disp([how ':'])
   if loose, disp(' '), end
   disp(t)
end

cmp = mupadmex('symobj::simpler', t.s, r.s, 0);
if strcmp(cmp,'TRUE') 
   r = t;
   h = how;
end
end
