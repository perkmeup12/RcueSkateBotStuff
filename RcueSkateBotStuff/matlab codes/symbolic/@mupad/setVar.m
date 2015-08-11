function setVar(nb,var,y)
%setVar Assign variable in a notebook.
%    setVar(NB,VAR,Y) assigns the sym object Y to variable VAR in the
%    MuPAD notebook NB. VAR must be a valid variable name (see ISVARNAME).
%    setVar(NB,Y) uses VAR=inputname(2) if the expression specifying Y
%    is a simple unsubscripted variable name and VAR='ans' otherwise.
%
%    Example:
%      syms x
%      y = sin(x);
%      setVar(nb,y)
%      setVar(nb,'f',x^2+1)
%
%    See also: mupad, getVar, sym, isvarname, inputname

%   Copyright 2011-2013 The MathWorks, Inc.

narginchk(2,3);
if nargin == 2
    y = var;
    if ischar(y) && isvarname(y)
        error(message('symbolic:mupad:setVar:MissingValue'));
    end
    var = inputname(2);
    if isempty(var)
        var = 'ans';
    end
end
if (isempty(mupaduimex('GetWindowTitle', nb.name)))
    error(message('symbolic:mupad:InvalidNotebookHandle'));  
end
if ~isvarname(var)
    error(message('symbolic:mupad:setVar:InvalidName'));
end

if ~isa(y,'sym')
    error(message('symbolic:mupad:setVar:InvalidValue'));
end
cc = charcmd(y);
if isequal(cc,var)
    error(message('symbolic:mupad:setVar:RecursiveAssignment'));
end
cmd = sprintf('%s := %s:', var, cc);
evalin(symengine,cmd);
for k = 1:numel(nb)
    nbk = nb(k);
    
    var64 = feval(symengine,'stdlib::to64', var);
    mucmd = sprintf('stdlib::from64("%s"):', char(var64));
    mupaduimex('EvaluateCommand', nbk.name, mucmd);

end

cmd = sprintf('delete %s', var);
evalin(symengine,cmd);
end
