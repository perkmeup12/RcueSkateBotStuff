function varargout = vpasolve(varargin)
%VPASOLVE  Numerical solution of algebraic equations.
%   VPASOLVE([eq1,...,eqn],[x1,...,xm],X0)
%   VPASOLVE(eq1,...,eqn,x1,...,xm,X0)
%
%   Solve the system of equations eq1,...,eqn in the variables x1,...,xm
%   using the starting values/search intervals defined by X0.
%
%   eq1,eq2,eq3,... can be SYM equations or simply SYM objects. In case
%   that eq1,eq2,eq3,... are generic SYM objects, they will be interpreted
%   as left sides of equations, whose right sides are equal to 0.
%
%   The variables x1,...,xm are optional. If the variables are not
%   specified, SYMVAR will be used to detect all the variables inside of
%   eq1,eq2,...,eqn. Then the system is solved with respect to these
%   variables.
%
%   X0 defines the starting point or the search range for the numerical
%   solver, i.e.:
%
%   X0 = [s1,...,sm] defines the starting values x1 = s1,x2 = s2,...,
%   xm = sm. The values s1,...,sm can be real or complex numbers. The
%   starting values can be given as row or as column vector. If X0 = s 
%   is a scalar, then the starting values x1 = s,x2 = s,...,xm = s are 
%   chosen.
%
%   X0 = [a1 b1; a2 b2; ...; am bm] defines search intervals. This means
%   that for x1 the search interval from a1 to b1 is used, for x2 the
%   search interval from a2 to b2 is used etc. If ai,bi are complex
%   numbers, the corresponding search interval is the rectangle in the
%   complex plane spanned by ai,bi.
%
%   The following special cases are considered:
%
%      When ai = bi = NaN, then this means that no search range for xi
%                          will be used.
%      When ai = bi, ai ~= NaN, then this is interpreted as starting point
%                          for xi.
%
%   X0 is optional. If no value is used, the numerical solver makes its
%   own internal choices.
%
%   In case of polynomial systems and when no search intervals are used to
%   restrict the numerical search, VPASOLVE returns all solutions of the
%   polynomial systems. Systems of rational functions are treated as
%   polynomial systems by considering only the numerators. Note that
%   VPASOLVE does not check if solutions of the systems are also roots
%   of any of the denominators (no singularity check).
%
%   Also note that VPASOLVE does not react to properties/assumptions 
%   used on variables. You need to specify appropriate search ranges 
%   to restrict the results.
%
%   vpasolve(..., 'random', true) chooses random starting points for 
%   the internal search that can differ in different calls of VPASOLVE. 
%   When you call the function with this option several times, each
%   call can return a different result. This may be useful to find
%   several solutions of problems that do not have a unique solution.
%
%   Examples:
%
%   syms x y z;
%   eq1 = 10*cos(10*x/(1 + x^2))/sin(x) == exp(x)/sin(x);
%   eq2 = sin(x)-1;
%   eq3 = (x - 2*y)^3 + 1;
%   eq4 = x - y == 0;
%   eq5 = (x^2 + y^2)^4 == 1;
%   eq6 = (x^2 - y^2)^4;
%   eq7 = x + z;
%   eq8 = (x - 1)*(x - 2)*(y - 3i);
%
%   S = vpasolve(eq1)
%   S = vpasolve(eq1,x)
%   S = vpasolve(eq2)
%   S = vpasolve(eq2,x,1)
%   S = vpasolve(eq2,x,[-1;1])
%   S = vpasolve(eq3, eq4)
%   S = vpasolve([eq3 eq4],[x y])
%   S = vpasolve([eq3 eq4],[x y],[0 1; 1/2 2])
%   S = vpasolve([eq3 eq4],[x y],[0 1; NaN NaN])
%   S = vpasolve([eq4, eq5, eq6], [x,y])
%   S = vpasolve([eq5, eq6, eq7], [x,y,z])
%   S = vpasolve(eq8, eq4, x,y, [NaN; 3.1i])
%   S = vpasolve([eq8, eq4], [x,y], [-1 0.5+4i; 0 3.1i])
%
%   See also SOLVE, DSOLVE, LINSOLVE, MLDIVIDE, SYM/LINSOLVE, SYM/MLDIVIDE,
%   FZERO, SUBS.

%   Copyright 2012 The MathWorks, Inc.

eng = symengine;

N = nargin;

if isa(varargin{end}, 'char') && ...
   strcmpi(varargin{end},'random') 
   error(message('symbolic:sym:vpasolve:RandomRequiresTrueOrFalse'));
end

if N > 2
  random = varargin{end-1};
  if isa(random, 'char')
      validatestring(random, {'random'});
      random = varargin{end};
      if isscalar(random) && (random == 1 || random == true) 
         random = true;
      elseif isscalar(random) && (random == 0 || random == false) 
         random = false;
      else
         error(message('symbolic:sym:vpasolve:RandomRequiresTrueOrFalse'));
      end
      X0 = sym(varargin{end-2});
      N = N - 2;
  else
      random = false;
      X0 = sym(varargin{end});
  end
else
  random = false;
  X0 = sym(varargin{end});
end

if ~isempty(symvar(X0))
    X0 = sym([]);
else
    N = N - 1;
end

[eqns,vars] = getEqnsVars(varargin{1:N});
numvars = length(vars);

if isempty(eqns)
    varargout{1} = sym([]);
    return
end

if numvars == 0
    error(message('symbolic:sym:vpasolve:NoVariablesFound'));
end

if ~isempty(X0)
    X0 = checkX(X0, numvars);
end

if size(X0, 2) > 1
   isStartingPoint = logical(privsubsref(X0,':',2) == privsubsref(X0,':',1));

end

if random
    if (size(X0, 2) == 1) || (...    % a vector of starting values
       (~isempty(X0)) && ...         % initial guess provided
       all(all(~isnan(X0))) &&  ...  % searchrange for all variables?
       (size(X0, 2) > 1) && ...
       all(isStartingPoint))         % all init data are starting values
       warning(message('symbolic:sym:vpasolve:NoRandomEffect'));
    end
    sol = eng.feval('symobj::vpasolve',eqns,vars,X0,'Random');
else
    sol = eng.feval('symobj::vpasolve',eqns,vars,X0);
end

nosol = char(eng.feval('_index',sol,'"NoSolution"'));
if strcmp(nosol,'TRUE')
    varargout = cell(1,nargout);
    varargout{1} = sym([]);
else
    varargout = assignOutputs(nargout,sol);
end

end

function out = assignOutputs(nout,sol)
% Helper functions to assign results to the outputs captured in solution
% tables generated on the MuPAD side.

out = cell(1,nout);
eng = symengine;

symvars = eng.feval('_index',sol,'"VariableNames"');
emptysol = char(eng.feval('_index',sol,'"EmptySolution"'));
solTable = eng.feval('_index',sol,'"Sols"');
set = eng.feval('_index',sol,'"SetSolution"');
if (isscalar(symvars) && nout <= 1) || strcmp(emptysol,'TRUE')
   % One variable and at most one output.
   % Return a single scalar or vector sym.
   variable = eng.feval('_index',symvars,1);
   val = eng.feval('_index',solTable,variable);
   val = eng.feval('symobj::extractscalar',val);
   if isempty(val)
       val = set;
   end
   out{1} = sort(val);
   if strcmp(emptysol,'TRUE') && ~isscalar(symvars)
       warning(message('symbolic:solve:warnmsg4'));
   end
else
   % Several variables.
   nvars = length(symvars);
   S = [];
   for j = 1:nvars
       variable = eng.feval('_index',symvars,j);
       name = char(variable);
       val = eng.feval('_index',solTable,variable);
       S.(name) = eng.feval('symobj::extractscalar',val);
   end
   if nout <= 1
      % At most one output, return the structure.
      out{1} = S;
   elseif nout == nvars
      % Same number of outputs as variables.
      v = fieldnames(S);
      for j = 1:nvars
         out{j} = S.(v{j});
      end
   else
      error(message('symbolic:dsolve:errmsg5', nvars, nout))
   end
end

end

function Y = checkX(X, numvars)
if numvars == 1
    Y = checkSingleVarX(X);
else
    Y = checkMultiVarX(X, numvars);
end
end

function Y = checkSingleVarX(X)
if isscalar(X)
    Y = X;
elseif isvector(X) && length(X) == 2
    % X is a range, put into normal form
    Y = reshape(X,[1 2]);
else
    error(message('symbolic:sym:vpasolve:Incompatible'));
end
end

function Y = checkMultiVarX(X, numvars)
if isscalar(X)
    % scalar expansion of start value into column vector
    elems = {};
    elems(1:numvars) = {X};
    Y = vertcat(elems{:});
elseif isequal(size(X),[numvars,2]) % maximal supported dimension of X is 2    
    % range 
    Y = X;
elseif isvector(X) && length(X) == numvars
    % vector start value 
    Y = reshape(X,[numvars 1]);
elseif isvector(X)
    % has a vector but does not match the number of variables
    error(message('symbolic:sym:vpasolve:StartPointsDoNotMatchVariables'));
elseif size(X,1) ~= numvars && size(X,2) == 2
    error(message('symbolic:sym:vpasolve:IncompatibleSearchRanges'));
else 
    % got a matrix but wrong size
    error(message('symbolic:sym:vpasolve:Expecting1Or2Columns'));
end
end

