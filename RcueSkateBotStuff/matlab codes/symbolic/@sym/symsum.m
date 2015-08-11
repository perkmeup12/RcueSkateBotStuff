function r = symsum(f,varargin)
%SYMSUM Symbolic summation.
%   SYMSUM(f) evaluates the sum of a series, where expression f defines the 
%   terms of a series, with respect to the default symbolic variable 
%   defaultVar determined by symvar. The value of the default variable 
%   changes from 0 to defaultVar - 1. If f is a constant, the summation is 
%   with respect to 'x'.
%
%   SYMSUM(f,x) evaluates the sum of a series, where expression f defines 
%   the terms of a series, with respect to the symbolic variable x. The 
%   value of the variable x changes from 0 to x - 1.
%
%   SYMSUM(f,a,b) evaluates the sum of a series, where expression f defines 
%   the terms of a series, with respect to the default symbolic variable 
%   defaultVar determined by symvar. The value of the default variable 
%   changes from a to b. Specifying the range from a to b can also be done    
%   using a row or column vector with two elements, i.e., valid calls are     
%   also SYMSUM(f,[a,b]) or SYMSUM(f,[a b]) and SYMSUM(f,[a;b]).              
%, 
%   SYMSUM(f,x,a,b) evaluates the sum of a series, where expression f 
%   defines the terms of a series, with respect to the symbolic variable x. 
%   The value of the variable x changes from a to b. Specifying the range     
%   from a to b can also be done using a row or column vector with two        
%   elements, i.e., valid calls are also SYMSUM(f,x,[a,b]) or                 
%   SYMSUM(f,x,[a b]) and SYMSUM(f,x,[a;b]).                                                                 
%
%   Examples:
%      symsum(k)                     k^2/2 - k/2
%      symsum(k,0,n-1)               (n*(n - 1))/2
%      symsum(k,0,n)                 (n*(n + 1))/2
%      simplify(symsum(k^2,0,n))     n^3/3 + n^2/2 + n/6
%      symsum(k^2,0,10)              385
%      symsum(k^2,[0,10])            385
%      symsum(k^2,11,10)             0
%      symsum(1/k^2)                 -psi(k, 1)
%      symsum(1/k^2,1,Inf)           pi^2/6
%
%   See also SYM/INT, SYM/SYMPROD.

%   Copyright 1993-2013 The MathWorks, Inc.

narginchk(1,4);
args = varargin;

for i = 1:nargin-1 
    if isa(args{i},'symfun') 
        args{i} = formula(args{i});
    end
end

args = privResolveArgs(f,args{:});
fsym = formula(args{1});
u = sym([]);
v = sym([]);

if nargin == 1
    x = symvar(fsym,1);
    if isempty(x)
        x = sym('x'); 
    end
elseif nargin == 2
    x = formula(args{2});
    if isvector(x) && numel(x) == 2 
        u = privsubsref(x,1);
        v = privsubsref(x,2);
    end
elseif nargin == 3
    x = formula(args{2});
    a = formula(args{3});
    if isvector(a) && numel(a) == 2 
        u = privsubsref(a,1);
        v = privsubsref(a,2);
    end
elseif nargin == 4 
    x = formula(args{2});
    a = formula(args{3});
    b = formula(args{4});
    if ~isscalar(a) 
        error(message('symbolic:sym:symsum:InvalidLowerSummationIndex'));
    elseif ~isscalar(b) 
        error(message('symbolic:sym:symsum:InvalidUpperSummationIndex'));
    end
end

if isempty(u) && nargin <= 2
   % Indefinite summation
   indefinite = true;
   if ~isscalar(x) || ~isAllVars(x) 
       error(message('symbolic:sym:symsum:InvalidSummationIndex', char(x)));
   end
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symsum',x.s);
else
   % Definite summation
   indefinite = false;
   if ~isempty(u) 
      a = u;
      b = v;
      if nargin == 2 
          x = symvar(fsym,1);
      end
   elseif nargin == 3
      b = a;
      a = x;
      x = symvar(fsym,1);
   end
   if isempty(x) 
       x = sym('x'); 
   elseif ~isscalar(x) || ~isAllVars(x) 
       error(message('symbolic:sym:symsum:InvalidSummationIndex', char(x)));
   end
   if isnan(a) || isnan(b) 
       error(message('symbolic:sym:symsum:BoundsMustNotBeNaN'));
   end
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symsum',x.s,a.s,b.s);
end

if isa(f,'symfun') 
    if indefinite
        r = privResolveOutput(rSym, f);
    else
        r = privResolveOutputAndDelete(rSym, f, x);
    end    
else
    r = rSym;
end

