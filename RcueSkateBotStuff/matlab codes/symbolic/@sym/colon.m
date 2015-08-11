function c = colon(a,d,b)
%COLON  Symbolic colon operator.
%   COLON(A,B) overloads symbolic A:B.
%   COLON(A,D,B) overloads symbolic A:D:B.
%
%   Example:
%       0:sym(1/3):1 is [  0, 1/3, 2/3,  1]

%   Copyright 1993-2013 The MathWorks, Inc.

a = sym(a);
if numel(a) > 1
    a = a(1); 
end
if nargin == 2
   b = d;
   d = 1;
end
if numel(d) > 1
    d = d(1);   
end
if isempty(a) || isempty(b) || isempty(d) || d == 0
   c = sym([]);
else
   if numel(b) > 1
       b = b(1);   
   end
   try
       n = double((b-a)/d);
   catch me
       if strcmp(me.identifier,'symbolic:sym:double:cantconvert')
           error(message('symbolic:colon:unknownStep', char( a ), char( sym( b ) ), char( sym( d ) )));
       else
           rethrow(me);
       end
   end
   c = a + (0:n)*d;
end
