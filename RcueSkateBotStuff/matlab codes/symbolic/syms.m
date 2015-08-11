function syms(varargin)
%SYMS   Short-cut for constructing symbolic variables.
%   SYMS arg1 arg2 ...
%   is short-hand notation for creating symbolic variables
%      arg1 = sym('arg1');
%      arg2 = sym('arg2'); ...
%   or, if the argument has the form f(x1,x2,...), for
%   creating symbolic variables
%      x1 = sym('x1');
%      x2 = sym('x2');
%      ...
%      f = symfun(sym('f(x1,x2,...)',{x1, x2, ...});
%   The outputs are created in the current workspace.
%
%   SYMS  ... ASSUMPTION
%   additionally puts an assumption on the variables created.
%   The ASSUMPTION can be 'real' or 'positive'.
%   SYMS  ... clear
%   clears any assumptions on the variables created, including those
%   made with the ASSUME command.
%
%   Each input argument must begin with a letter and must contain only
%   alphanumeric characters.
%
%   By itself, SYMS lists the symbolic objects in the workspace.
%
%   Example 1:
%      syms x beta real
%   is equivalent to:
%      x = sym('x','real');
%      beta = sym('beta','real');
%
%   To clear the symbolic objects x and beta of 'real' or 'positive' status, type
%      syms x beta clear
%
%   Example 2:
%      syms x(t) a
%   is equivalent to:
%      a = sym('a');
%      t = sym('t');
%      x = symfun(sym('x(t)'), [t]);
%
%   See also SYM, SYMFUN.

%   Deprecated API:
%   The 'unreal' keyword can be used instead of 'clear'.

%   Copyright 1993-2013 The MathWorks, Inc.

if nargin < 1
   w = evalin('caller','whos');
   clsnames = {w.class};
   k = strcmp('sym',clsnames) | strcmp('symfun',clsnames);
   disp(' ')
   disp({w(k).name})
   disp(' ')
   return
end
[vars,funs,control] = getnames(varargin);

for k = 1:length(vars)
    x = vars{k};
    if ~isempty(control)
        assignin('caller',x,sym(x,control));
    else
        assignin('caller',x,sym(x));
    end
end
for k = 1:size(funs,1)
    x = funs{k,1};
    fvars = funs{k,2};
    basefun = sym(x);
    basesym = feval(symengine,basefun,fvars{:});
    y = symfun(basesym,[fvars{:}]);
    assignin('caller',x,y);
end

function [vars,funs,control] = getnames(args)
n = numel(args);
control = '';
if any(strcmp(args{end},{'real','unreal','clear','positive'}))
    control = args{end};
    n = n-1;
end
vars = {};
funs = cell(0,3);
for k = 1:n
    x = args{k};
    if isvarname(x)
        vars(end+1) = args(k); %#ok<AGROW>.
    elseif any(x=='(')
        funs(end+1,:) = parsefun(x); %#ok<AGROW>.
        vars = [vars funs{end,3}]; %#ok<AGROW>.
    else
        error(message('symbolic:sym:errmsg1'))
    end
end
vars = unique(vars);

function parts = parsefun(x)
    p1 = find(x=='(',1)+1;
    p2 = find(x==')',1)-1;
    cvars = x(p1:p2);
    commas = find(cvars==',', 1);
    if ~isempty(commas)
        cvars = regexp(cvars,',','split');
        cvars = strtrim(cvars);
    else
        cvars = {cvars};
    end
    fvars = cellfun(@(x)sym(x),cvars,'UniformOutput',false);
    varnames = cellfun(@(x)isvarname(x),cvars);
    name = x(1:p1-2);
    parts = {name,fvars,cvars};
    if ~isvarname(name) || ~all(varnames)
        error(message('symbolic:sym:errmsg1'))
    end
