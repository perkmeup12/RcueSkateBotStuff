function [varargout] = size(~,~)
%SIZE Size of a symfun array.

%   Copyright 2011 The MathWorks, Inc.

if nargin > 1
    if nargout > 1
      error(message('MATLAB:TooManyOutputs'));
    end
    varargout = {1};
elseif nargout < 2
    varargout{1} = [1 1];
else
    for k = 1:nargout
        varargout{k} = 1; %#ok<AGROW>
    end
end
