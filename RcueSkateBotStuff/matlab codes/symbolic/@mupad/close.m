function close(nb, varargin) 
%CLOSE Close a notebook    
%    close(NB) closes notebook NB.
%
%    close(NB, 'force') closes notebook NB without asking for saving
%    the changes. All modifications will be lost.
%
%    See also: mupad

%    Copyright 2013 The MathWorks, Inc.

p = inputParser;
p.addRequired('nb');
p.addOptional('force', '', @(x) ischar(x) && strcmpi(x,'force') );
p.parse(nb, varargin{:});

forceClose = ~isempty(p.Results.force);

nb(~isvalid(nb)) = [];
for k = 1:numel(nb)
    nbk = nb(k);
    if ~isempty(nbk.name)
        mupaduimex('CloseNotebook', nbk.name, forceClose);
        % slvnv toolbox tests still needs this. See comment
        % in mupad.m.
        appnb = getappdata(0,'SymbolicMuPADNotebooks');
        if ~isempty(appnb)
            appnb(appnb == nbk) = [];
            setappdata(0,'SymbolicMuPADNotebooks',appnb);
        end
    end
end

end
