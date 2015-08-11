function Y = wrightOmega(X)
%WRIGHTOMEGA    Symbolic Wright Omega function.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'wrightOmega');
end
