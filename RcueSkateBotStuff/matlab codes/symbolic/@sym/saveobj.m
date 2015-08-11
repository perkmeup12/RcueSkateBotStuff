function y = saveobj(x)
%SAVEOBJ    Save symbolic object
%   Y = SAVEOBJ(X) converts symbolic object X into a form that can be
%   saved to disk safely.
    
%   Copyright 2008-2013 The MathWorks, Inc.
    
y = privResolveArgs(x);
y = y{1};
M = mupadmex('symobj::toString', x.s);
y.s = ['symobj::fromString("' char(M) '")'];
