function y = feval(F,varargin)
%FEVAL  Evaluate symbolic function
%   feval(F,x1,...,xn) evaluates the symbolic function F
%   at the given arguments x1, ..., xn. If any of the
%   arguments are matrices or n-dimensional arrays the
%   function is vectorized over the matrix elements. The
%   syntax F(x1...xn) is equivalent to feval(F,x1...xn).
% 
%   If the body of F is nonscalar and any of the inputs
%   is nonscalar then the output is a cell array the
%   shape of the body of F and each element is the
%   evaluation of the corresponding element of the body
%   of F.

%   Copyright 2011 The MathWorks, Inc.

if ~isa(F,'symfun')
    y = builtin('feval',F,varargin{:});
    return;
end
Fvars = privToCell(F.vars);
cc = mupadmex('symobj::size', F.s, 0);
siz = eval(cc);
Ffun = F.fun;
if isempty(Ffun)
    % initialize the function handles
    F.fun = makeFun(Fvars, F.s);
    if prod(siz) > 1 
        F.matrixfun = makeMatrixFun(siz, Fvars, F.s);
    end
end
if prod(siz) == 1 || all(cellfun(@isscalar,varargin)) 
    y = evalScalarFun(F.fun, varargin);
else
    y = evalMatrixFun(siz, F.matrixfun, varargin);
end

function Ffun = makeFun(Fvars, def)
strs = cellfun(@(t){charcmd(t)},Fvars);
Ffun = mupadmex('fp::unapply',def,strs{:},11);

function y = makeMatrixFun(siz, Fvars, Ffun)
y = cell(siz);
N = prod(siz);
for k=1:N
    B = mupadmex('symobj::subsref',Ffun,num2str(k));
    y{k} = makeFun(Fvars, charcmd(B));
end

function y = evalMatrixFun(siz, Ffun, inds)
y = cell(siz);
N = prod(siz);
for k=1:N
    y{k} = evalScalarFun(Ffun{k}, inds);
end

function y = evalScalarFun(Ffun, inds)
refs = cell(size(inds));
for k=1:length(inds)
    val = inds{k};
    if isa(val,'sym')
        inds{k} = charcmd(val);
    else
        val = sym(val);
        refs{k} = val; % hold onto the reference to prevent gc
        inds{k} = charcmd(val);
    end
end
y = mupadmex('symobj::zipargs',Ffun,inds{:});
