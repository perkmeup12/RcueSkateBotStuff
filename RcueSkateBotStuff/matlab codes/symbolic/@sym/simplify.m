function r = simplify(s,varargin)
%SIMPLIFY Symbolic simplification.
%   SIMPLIFY(S) simplifies each element of the symbolic matrix S.
%   
%   SIMPLIFY(S,N) or, equivalently, SIMPLIFY(S,'Steps',N),
%   searches for a simplification in N steps. The default value of N is 1.
%   
%   SIMPLIFY(S,'Seconds',T) aborts the search for a simpler version
%   at the next end of a simplification step after T seconds. The results
%   will depend on the speed and system load of your computer and may
%   not be reproducible.
%   
%   SIMPLIFY(S,'IgnoreAnalyticConstraints',VAL) controls the level of 
%   mathematical rigor to use on the analytical constraints while simplifying 
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or 
%   FALSE. Specify TRUE to relax the level of mathematical rigor
%   in the rewriting process. The default is FALSE.
%   
%   SIMPLIFY(S, 'Criterion', 'preferReal') 
%   discourages simplify from returning results 
%   containing complex numbers.
%
%   Examples: 
%      simplify(sin(x)^2 + cos(x)^2)  returns  1.
%      simplify(exp(c*log(sqrt(alpha+beta))))  returns  (alpha + beta)^(c/2).
%      simplify(sqrt(x^2))  returns  sqrt(x^2),
%      simplify(sqrt(x^2),'IgnoreAnalyticConstraints',true)  returns  x.
%
%   See also SYM/SIMPLE, SYM/FACTOR, SYM/EXPAND, SYM/COLLECT.

%   Copyright 1993-2012 The MathWorks, Inc.

if builtin('numel',s) ~= 1,  s = normalizesym(s);  end
% parse arguments, step 1: Look for options
args = varargin;
% default:
k = 1;
IAC = 'FALSE';
steps = sym(1);
seconds = sym(inf);
criterion = sym('Simplify::defaultValuation');
while k <= size(args, 2)
    v = args{k};
    if ischar(v) 
        if k == size(args, 2);
            error(message('symbolic:sym:optRequiresArg', v))
        end
        value = args{k+1};
    
        if strcmpi(v, 'IgnoreAnalyticConstraints')         
            if value == true
                IAC = 'TRUE';
            elseif value == false
                IAC = 'FALSE';
            elseif isa(value, 'char')
                if strcmpi(value, 'all')
                    IAC = 'TRUE';
                elseif strcmpi(value, 'none')
                    IAC = 'FALSE';
                else
                    error(message('symbolic:sym:badArgForOpt', v))
                end
            else
                error(message('symbolic:sym:badArgForOpt', v))
            end
           
        elseif  strcmpi(v, 'Steps')
            if isnumeric(value) && 0 <= value && round(value) == value
                steps = sym(value);
            else
                error(message('symbolic:sym:badArgForOpt', v))
            end
            
        elseif strcmpi(v, 'Seconds')
            if isnumeric(value) && 0 <= value
                seconds = sym(value);
            else
                error(message('symbolic:sym:badArgForOpt', v))
            end
            
        elseif strcmpi(v, 'Criterion')
            if strcmpi(value, 'preferReal') 
                criterion = sym('Simplify::preferReal');
            elseif ~strcmpi(value, 'default')
                error(message('symbolic:sym:badArgForOpt', v))
            end
            
        else
            error(message('symbolic:sym:maxrhs'))
             
        end    
        k = k+2;
        
    elseif isnumeric(v) && 0 <= v && round(v) == v
        steps = sym(v);
        k = k+1;

    else
        error(message('symbolic:sym:maxrhs'))
    end
end


rSym = feval(symengine, 'simplify', s,...
            sym(['IgnoreAnalyticConstraints =', IAC]),...
            sym('Steps') == steps,...
            sym('Seconds') == seconds,...
            sym('Criterion') == criterion,...
            sym('OutputType = "Best"') ...
            );
r = privResolveOutput(rSym, s);
