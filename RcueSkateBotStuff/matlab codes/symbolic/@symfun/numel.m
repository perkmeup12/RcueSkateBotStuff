function y = numel(~,varargin)
%NUMEL Number of elements in a symfun array.
%   N = NUMEL(A) returns the number of elements in the sym array A.
%
%   N = NUMEL(A, VARARGIN) returns the number of subscripted elements, N, in
%   A(index1, index2, ..., indexN), where VARARGIN is a cell array whose
%   elements are index1, index2, ... indexN.
%
%   See also SYM, SIZE.

%   Copyright 2011 The MathWorks, Inc.

y = 1;
