function r = symprod(f,varargin)
%SYMPROD Symbolic product.
%   SYMPROD(f) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the default symbolic 
%   variable defaultVar determined by symvar. The value of the default 
%   variable changes from 1 to defaultVar. If f is a constant, the product
%   is with respect to 'x'.
%
%   SYMPROD(f,x) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the symbolic variable x. 
%   The value of the variable x changes from 1 to x.
%
%   SYMPROD(f,a,b) evaluates the product of a series, where expression f 
%   defines the terms of a series, with respect to the default symbolic 
%   variable defaultVar determined by symvar. The value of the default       
%   variable changes from a to b. Specifying the range from a to b can       
%   also be done using a row or column vector with two elements, i.e.,       
%   valid calls are also SYMPROD(f,[a,b]) or SYMPROD(f,[a b]) and            
%   SYMPROD(f,[a;b]).                                                        
%
%   SYMPROD(f,x,a,b) evaluates the product of a series, where expression f
%   defines the terms of a series, with respect to the symbolic variable x. 
%   The value of the variable x changes from a to b. Specifying the range    
%   from a to b can also be done using a row or column vector with two       
%   elements, i.e., valid calls are also SYMPROD(f,x,[a,b]) or               
%   SYMPROD(f,x,[a b]) and SYMPROD(f,x,[a;b]).                                                                 
%
%   Examples:
%      syms l k n
%      symprod(k)                            factorial(k)
%      symprod(k,1,n)                        factorial(n)
%      symprod(k,[1,n])                      factorial(n)
%      symprod('1/k*l',l,1,n)                (k*factorial(n))/k^(n + 1)
%      symprod(1/k*l,l,1,n)                  (k*factorial(n))/k^(n + 1)
%      symprod(1/k*l,l,[1,n])                (k*factorial(n))/k^(n + 1)
%      symprod(l^2/(l^2 - 1), l, 2, Inf)     2 
%
%   See also SYM/INT, SYM/SYMSUM.

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
        error(message('symbolic:sym:symprod:InvalidLowerProductIndex'));
    elseif ~isscalar(b) 
        error(message('symbolic:sym:symprod:InvalidUpperProductIndex'));
    end
end

if isempty(u) && nargin <= 2
   % Indefinite product
   indefinite = true;
   if ~isscalar(x) || ~isAllVars(x) 
       error(message('symbolic:sym:symprod:InvalidProductIndex', char(x)));
   end
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symprod',x.s);
else
   % Definite product
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
       error(message('symbolic:sym:symprod:InvalidProductIndex', char(x)));
   end
   if isnan(a) || isnan(b) 
       error(message('symbolic:sym:symprod:BoundsMustNotBeNaN'));
   end
   rSym = mupadmex('symobj::map',fsym.s,'symobj::symprod',x.s,a.s,b.s);
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
