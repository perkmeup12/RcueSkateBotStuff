function [eqns,vars] = getEqnsVars(varargin)
%  getEqnsVars(eq1,...,eqn,x1,...,xm)
%  getEqnsVars(expr1,...,exprn,x1,...,xm)
%  getEqnsVars(expr1,eq1,eq2,expr2,...,exprn,x1,...,xm)
%  getEqnsVars(eq1,...,eqn)
%  getEqnsVars(expr1,...,exprn)
%  getEqnsVars(expr1,eq1,eq2,expr2,...,exprn) 
% 
%  Helper function to separate equations from variables. It implements the
%  strategy: scan the input from right to left and treat everything as a 
%  variable which is a single variable. When the first equation is found, 
%  every input parameter to the left of that is also assumed to be an 
%  equation.
%
%  In particular: input p is a variable if logical(symvar(p) == p) gives 
%  true. The first (from right to left) input parameter p for which 
%  logical(symvar(p) == p) gives false, is interpreted as an equation.
%  From that point on every input parameter to the left of p up to the  
%  very first input parameter given is also interpreted as an equation.
%  Additionally: the first input argument is always interpreted as an 
%  equation (calls such as getEqnsVars(x1) do not seem to make much 
%  sense). 
%
%  If using this strategy no variable is obtained (input consists of 
%  equations only), we use symvar to determine variables. In particular 
%  this means that:
% 
%    getEqnsVars(eq1,...,eqn) is equivalent to
%    getEqnsVars(eq1,...,eqn,symvar([eq1,...,eqn]))
% 
%    getEqnsVars(expr1,...,exprn) is equivalent to
%    getEqnsVars(expr1,...,exprn,...,symvar([expr1,...,exprn]))
%
%    getEqnsVars(expr1,eq1,eq2,expr2,...,exprn) is equivalent to 
%    getEqnsVars(expr1,eq1,eq2,expr2,...,exprn,...
%                symvar([expr1,eq1,eq2,expr2,...,exprn])) 

%   Copyright 2012 The MathWorks, Inc.

if nargin == 0
    eqns = sym([]);
    vars = sym([]);
    return;
end

vars = sym([]);

if ~isscalar(varargin{end}) 
    if nargin > 2 
        error(message('symbolic:sym:equationsToMatrix:VectorOfEquations'));    
    elseif nargin == 2 
        vars = varargin{2};
        eqns = varargin{1};
        if ~isa(eqns,'sym') || ~isa(vars,'sym')
            error(message('symbolic:sym:sym:SymInputExpected'));
        end
        return;
    end
elseif ~isscalar(varargin{1}) 
    if nargin > 2 
        error(message('symbolic:sym:equationsToMatrix:VectorOfEquations'))
    end
end
    
if isempty(vars) && isscalar(varargin{1})
    k = nargin+1;
    ind = 1; % index of the first equation
    if nargin > 1
        while k > 1
            k = k-1;
            p = varargin{k};
            if ~isa(p,'sym')
                error(message('symbolic:sym:sym:SymInputExpected'));
            end
            if ~logical(symvar(p) == p) % first equation detected
                if k==0
                    ind = 1;
                else
                    ind = k;
                end
                break;
            end
        end
    end
    eqns = [varargin{1:ind}];
    if ind+1 <= nargin
        vars = [varargin{(ind+1):nargin}];
    else
        vars = symvar(eqns);
    end
else
    eqns = [varargin{1}];
    if nargin > 1
        vars = [varargin{2}];
    else
        vars = symvar(eqns);
    end
    if ~isa(eqns,'sym') || ~isa(vars,'sym')
        error(message('symbolic:sym:sym:SymInputExpected'));
    end
end

end
