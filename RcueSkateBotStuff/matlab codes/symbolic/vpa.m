function r = vpa(s,d)
%VPA    Variable precision arithmetic.
%   R = VPA(S) numerically evaluates each element of the double matrix
%   S using variable precision floating point arithmetic with D decimal
%   digit accuracy, where D is the current setting of DIGITS.
%   The resulting R is a SYM.
%
%   VPA(S,D) uses D digits, instead of the current setting of DIGITS.
%   D is an integer or the SYM representation of a number.
%
%   It is important to avoid the evaluation of an expression using double
%   precision floating point arithmetic before it is passed to VPA.
%   For example,
%      phi = vpa((1+sqrt(5))/2)
%   first computes a 16-digit approximation to the golden ratio, then
%   converts that approximation to one with d digits, where d is the current
%   setting of DIGITS.  To get full precision, use unevaluated string or
%   symbolic arguments,
%      phi = vpa('(1+sqrt(5))/2')
%   or
%      s = sym('sqrt(5)')
%      phi = vpa((1+s)/2);
%
%   Additional examples:
%      vpa(pi,780) shows six consecutive 9's near digit 770 in the
%         decimal expansion of pi.
%
%      vpa(hilb(2),5) returns
%
%         [    1., .50000]
%         [.50000, .33333]
%
%   See also DOUBLE, DIGITS, SUBS.

%   Copyright 1993-2012 The MathWorks, Inc.

if nargin == 2
    oldd = digits;
    digits(d);
    tmp = onCleanup(@()digits(oldd));
end
if ischar(s)
    ss = evalin(symengine,s);
else
    ss = sym(s);
end
r = vpa(ss);
