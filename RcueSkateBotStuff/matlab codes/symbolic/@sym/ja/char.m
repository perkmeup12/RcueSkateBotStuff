% CHAR   スカラ、またはシンボリックな配列を文字列に変換
%
% CHAR(A,d) は、A を文字列表現に変換します。
% スカラ A に対する CHAR(A) は、単にA.s です。
% CHAR(A,1) は、'vector([...])' の形式になります。
% CHAR(A,2) は、'matrix([[...],[...]])' の形式になります。
% d >= 3 に対する CHAR(A,d) は、つぎの形式になります。
%      'array([1..m,1..n,1..p],[(1,1,1)=xxx,...,(m,n,p)=xxx])'
% CHAR(A) は、d = ndims(A) を使います。


%   Copyright 1993-2004 The MathWorks, Inc.
