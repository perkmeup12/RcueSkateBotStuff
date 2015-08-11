function Y = bernoulli(n, x)
% BERNOULLI Bernoulli numbers and Bernoulli polynomials.
%    Y = BERNOULLI(N, X) is the N-th Bernoulli polynomial.
%    It is defined as
%    BERNOULLI(n, x) = limit(diff(t*exp(x*t)/(exp(t) - 1), t, n), t, 0)
%    Y = BERNOULLI(N) is the N-th Bernoulli number.
%    It is defined as
%    BERNOULLI(n) = bernoulli(n, 0).
%    See also EULER.

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    Y = useSymForSingle(@bernoulli, n);
else
    Y = useSymForSingle(@bernoulli, n, x);
end
