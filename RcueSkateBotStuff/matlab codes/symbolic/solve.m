function varargout = solve(varargin)
%SOLVE  Symbolic solution of algebraic equations.
%   SOLVE(eqn1,eqn2,...,eqnN)
%   SOLVE(eqn1,eqn2,...,eqnN,var1,var2,...,varN)
%
%   The eqns are symbolic expressions or strings specifying equations.  The
%   vars are symbolic variables or strings specifying the unknown variables.
%   If the expressions are not equations SOLVE seeks zeros of the expressions.
%   Otherwise SOLVE seeks solutions to the equations.
%   If not specified, the unknowns in the system are determined by SYMVAR.
%   If no analytical solution is found and the number of equations equals
%   the number of dependent variables, a numeric solution is attempted.
%
%   Three different types of output are possible.  For one equation and one
%   output, the resulting solution is returned, with multiple solutions to
%   a nonlinear equation in a symbolic vector.  For several equations and
%   several outputs, the results are sorted in the same order as the
%   variables var1,var2,...,varN in the call to SOLVE.  In case no variables
%   are given in the call to SOLVE, the results are sorted in lexicographic
%   order and assigned to the outputs.  For several equations and a single
%   output, a structure containing the solutions is returned.
%
%   SOLVE(...,'IgnoreAnalyticConstraints',VAL) controls the level of
%   mathematical rigor to use on the analytical constraints of the solution
%   (branch cuts, division by zero, etc). The options for VAL are TRUE or
%   FALSE. Specify FALSE to use the highest level of mathematical rigor
%   in finding any solutions. The default is FALSE.
%
%   SOLVE(...,'PrincipalValue',VAL) controls whether SOLVE should return
%   multiple solutions, including parameterized infinite solution sets
%   (if VAL is FALSE), or just a single solution (when VAL is TRUE).
%   The default is FALSE.
%
%   SOLVE(...,'IgnoreProperties',VAL) controls if SOLVE should take
%   assumptions on variables into account. VAL can be TRUE or FALSE.
%   The default is FALSE (i.e., take assumptions into account).
%
%   SOLVE(...,'Real',VAL) allows to put the solver into "real mode."
%   In "real mode," only real solutions such that all intermediate values
%   of the input expression are real are searched. VAL can be TRUE
%   or FALSE. The default is FALSE.
%
%   SOLVE(...,'MaxDegree',n) controls the maximum degree of polynomials
%   for which explicit formulas will be used during the computation.
%   n must be a positive integer smaller than 5. The default is 3.
%
%
%   Example 1:
%      syms p x r
%      solve(p*sin(x) == r) chooses 'x' as the unknown and returns
%
%        ans =
%               asin(r/p)
%          pi - asin(r/p)
%
%   Example 2:
%      syms x y
%      [Sx,Sy] = solve(x^2 + x*y + y == 3,x^2 - 4*x + 3 == 0) returns
%
%        Sx =
%         1
%         3
%
%        Sy =
%            1
%         -3/2
%
%   Example 3:
%      syms x y
%      S = solve(x^2*y^2 - 2*x - 1 == 0,x^2 - y^2 - 1 == 0) returns
%      the solutions in a structure.
%
%        S =
%          x: [8x1 sym]
%          y: [8x1 sym]
%
%   Example 4:
%      syms a u v
%      [Su,Sv] = solve(a*u^2 + v^2 == 0,u - v == 1) regards 'a' as a
%      parameter and solves the two equations for u and v.
%
%   Example 5:
%      syms a u v w
%      S = solve(a*u^2 + v^2,u - v == 1,a,u) regards 'v' as a
%      parameter, solves the two equations, and returns S.a and S.u.
%
%      When assigning the result to several outputs, the order in which
%      the result is returned depends on the order in which the variables
%      are given in the call to solve:
%      [U,V] = solve(u + v,u - v == 1, u, v) assigns the value for u to U
%      and the value for v to V. In contrast to that
%      [U,V] = solve(u + v,u - v == 1, v, u) assigns the value for v to U
%      and the value of u to V.
%
%   Example 6:
%      syms a u v
%      [Sa,Su,Sv] = solve(a*u^2 + v^2,u - v == 1,a^2 - 5*a + 6) solves
%      the three equations for a, u and v.
%
%   Example 7:
%      syms x
%      S = solve(x^(5/2) == 8^(sym(10/3))) returns all three complex solutions:
%
%        S =
%                                                        16
%         - 4*5^(1/2) - 4 + 4*2^(1/2)*(5 - 5^(1/2))^(1/2)*i
%         - 4*5^(1/2) - 4 - 4*2^(1/2)*(5 - 5^(1/2))^(1/2)*i
%
%   Example 8:
%      syms x
%      S = solve(x^(5/2) == 8^(sym(10/3)), 'PrincipalValue', true) selects one of these:
%
%        S =
%        - 4*5^(1/2) - 4 + 4*2^(1/2)*(5 - 5^(1/2))^(1/2)*i
%
%   Example 9:
%      syms x
%      S = solve(x^(5/2) == 8^(sym(10/3)), 'IgnoreAnalyticConstraints', true)
%      ignores branch cuts during internal simplifications and, in this case,
%      also returns only one solution:
%
%        S =
%        16
%
%   Example 10:
%      syms t positive
%      solve(t^2-1)
%
%        ans =
%        1
%
%   Example 11:
%      solve(t^2-1, 'IgnoreProperties', true)
%
%        ans =
%          1
%         -1
%
%   Example 12:
%      solve(x^3-1) returns all three complex roots:
%
%        ans =
%                             1
%         - 1/2 + (3^(1/2)*i)/2
%         - 1/2 - (3^(1/2)*i)/2
%
%      solve(x^3-1, 'Real', true) only returns the real root:
%
%        ans =
%        1
%
%   See also DSOLVE, SUBS.

%   Copyright 1993-2011 The MathWorks, Inc.

% Collect input arguments together in either equation or variable lists.

eng = symengine;

[eqns,vars,options] = getEqns(varargin{:});

if isempty(eqns)
   warning(message('symbolic:solve:warnmsg1'))
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
end

if isempty(options)
  sol = eng.feval('symobj::solvefull',eqns,vars);
else
  sol = eng.feval('symobj::solvefull',eqns,vars,options);
end

% If still no solution, give up.
failsol = char(eng.feval('_index',sol,'"FailedSolution"'));
nosol = char(eng.feval('_index',sol,'"NoSolution"'));
if strcmp(nosol,'TRUE') || strcmp(failsol,'TRUE')
   warning(message('symbolic:solve:warnmsg3'));
   varargout = cell(1,nargout);
   varargout{1} = sym([]);
   return
end

dropped = eng.feval('_index',sol,'"Dropped"');
if ~isempty(dropped)
    dropped = char(eng.feval('output::tableForm',dropped,'String'));
    dropped(dropped=='"') = [];
    dropped = sprintf(['\n' dropped]);
    warning(message('symbolic:solve:ParametrizedFamily',dropped));
end

varargout = assignOutputs(nargout,sol,sym(vars));

if isempty(varargout{1})
   warning(message('symbolic:solve:warnmsg3'));
end

% Parse the result.
function out = assignOutputs(nout,sol,vars)
out = cell(1,nout);
eng = symengine;
symvars = eng.feval('_index',sol,'"VariableNames"');
emptysol = char(eng.feval('_index',sol,'"EmptySolution"'));
solTable = eng.feval('_index',sol,'"Sols"');
set = eng.feval('_index',sol,'"SetSolution"');
if (isscalar(symvars) && nout <= 1) || strcmp(emptysol,'TRUE')

   % One variable and at most one output.
   % Return a single scalar or vector sym.
   val = eng.feval('_index',solTable,symvars(1));
   val = eng.feval('symobj::extractscalar',val);
   if isempty(val)
       val = set;
   end
   out{1} = val;

   if strcmp(emptysol,'TRUE') && ~isscalar(symvars)
       warning(message('symbolic:solve:warnmsg4'));
   end

else

   % Several variables.
   nvars = length(symvars);

   S = [];
   for j = 1:nvars
       variable = symvars(j);
       name = char(variable);
       val = eng.feval('_index',solTable,variable);
       S.(name) = eng.feval('symobj::extractscalar',val);
   end

   if nout <= 1

       % At most one output, return the structure.
       out{1} = S;

   elseif nout == nvars

      % Same number of outputs as variables.
      if ~isempty(vars) && nout == length(vars)
          for j = 1:nvars
             v = eng.feval('_index',vars,j);
             out{j} = S.(char(v));
          end
      else
          % Match results in lexicographic order to outputs.
          v = sort(fieldnames(S));
          for j = 1:nvars
             out{j} = S.(v{j});
          end
      end

   else
      error(message('symbolic:dsolve:errmsg5', nvars, nout))
   end
end

%-------------------------

function [eqns,vars,options] = getEqns(varargin)
eqns = [];
vars = [];
options = [];
k = 0;
while k < nargin
  k = k+1;
  v = varargin{k};
  vc = tochar(v);
  TrueFalseOpt = {'IgnoreAnalyticConstraints', 'IgnoreSpecialCases', ...
      'PrincipalValue', 'IgnoreProperties', 'Real'};
  if any(strcmpi(vc, TrueFalseOpt))
      vc = normalizeCase(vc, TrueFalseOpt);  
      [k, options] = processOnOff(k, options, v, vc, nargin, varargin);
  elseif strcmpi(vc, 'MaxDegree')
      [k, options] = processMaxDegree(k, options, v, nargin, varargin);
  elseif isVar(vc, eqns)
      vars = processVar(vars, v, vc);
  elseif isa(v,'symfun')
      eqns = processSymfun(v,eqns);
  elseif isa(v,'sym')
      eqns = [eqns v(:).']; %#ok<AGROW>
  else
      eqns = processString(eqns, v, vc);
  end
end
vars = ['[' vars ']'];
if vars(2)==','
  vars(2)=' ';
end
if ~isempty(options) && options(1)==','
  options(1)=' ';
end

function vcnew = normalizeCase(vc, options)
for i=1:numel(options)
    if strcmpi(vc, options{i})
        vcnew = options{i};
        return
    end    
end


function y = isVar(vc, eqns)
  y = ~isempty(eqns) && all(isstrprop(vc,'alphanum') | vc == '_' | vc == ',' | vc == ' ');

function vc = tochar(v)
  if isa(v,'logical')
      if v
          vc = 'TRUE';
      else
          vc = 'FALSE';
      end
  else
      vc = char(v);
  end

function [k, options] = processOnOff(k, options, v, vc, nargs, args)
    if k == nargs
      error(message('symbolic:sym:optRequiresArg', v))
    end
    k = k+1;
    value = args{k};
    if value == true
      value = 'TRUE';
    elseif value == false
      value = 'FALSE';
    elseif strcmp(vc, 'IgnoreAnalyticConstraints') && isa(value, 'char')
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
    options = [options ', ' vc '=' value];

function [k, options] = processMaxDegree(k, options, v, nargs, args)
    if k == nargs
      error(message('symbolic:sym:optRequiresArg', v))
    end
    k = k+1;
    value = args{k};
    if isnumeric(value) && 0 < value && 5 > value && round(value) == value
      options = [options ', MaxDegree =' int2str(value)];
    else
      error(message('symbolic:sym:badArgForOpt', v))
    end

function vars = processVar(vars, v, vc)
    if isa(v,'sym') && any(strcmp(vc,{'beta','gamma','psi','theta','zeta','D','E','O','Ei','Si','Ci','I'}))
      vc = [vc '_Var'];
    end
    vc(vc == ' ') = [];
    vars = [vars ',' vc];

function eqns = processString(eqns, v, vc)
    [t,stat] = mupadmex(vc,0);
    if stat
      error(message('symbolic:solve:errmsg1', v))
    end
    if ~isempty(t)
      % use a set syntax to preserve the list items without
      % causing the string to be parsed as MATLAB arrays [a b]
      t = sym(['{' vc '}']);
      eqns = [eqns t(:).'];
    end

function eqns = processSymfun(v,eqns)
    sv = formula(v);
    eqns = [eqns sv(:).'];
