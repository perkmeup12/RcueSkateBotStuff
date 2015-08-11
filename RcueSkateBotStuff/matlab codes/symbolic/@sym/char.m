function M = char(A,varargin)
%CHAR   Convert scalar or array sym to string.
%   CHAR(A) returns a string representation of the symbolic object A
%   in MuPAD syntax.

%   Copyright 1993-2013 The MathWorks, Inc.

if nargin > 1 
    error(message('symbolic:Char:secondArgument'));    
end

% Do not use privResolveArgs here unless necessary,
% since it loses information on A's digits setting
if ~isa(A, 'sym')
    Asym = privResolveArgs(A);
    A = Asym{1};
end
if builtin('numel',A) ~= 1
    A = normalizesym(A);
end

M = mupadmex('symobj::char', A.s, 0);

M = strrep(M,'_Var','');
if strncmp(M,'"',1)
    M = M(2:end-1);  % remove quotes
end
