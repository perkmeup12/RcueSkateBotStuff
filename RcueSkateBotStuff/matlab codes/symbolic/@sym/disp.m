function disp(X,novars)
%DISP   Displays a sym as text.
%   DISP(S) displays the scalar or array sym,
%   without printing the sym name.

%   Copyright 1993-2013 The MathWorks, Inc.

Xsym = privResolveArgs(X);
X = Xsym{1};

if nargin == 1
    novars = false;
end
loose = isequal(get(0,'FormatSpacing'),'loose');
fX = formula(X);
sz = size(fX);
displayTags = isappdata(0,'SymObjectDisplayTags');
if displayTags
    disp('<symDisplay>');
end
if prod(sz) == 0
    if isequal(sz,[0,0]) 
        str = getString(message('symbolic:sym:disp:EmptySym'));
    else 
        by = getString(message('symbolic:sym:disp:by'));
        parts = arrayfun(@(x){int2str(x)},sz);
        parts(2,1:length(sz)-1) = {by};
        str = [parts{:}];        
        str = getString(message('symbolic:sym:disp:EmptySymWithSize',str));
    end
    disp(str) 
elseif all(sz == 1)
    allstrs = mupadmex('symobj::allstrs',X.s,0);
    allstrs = strrep(allstrs(2:end-1),'_Var','');
    if ~isempty(strfind(allstrs,'_symans'))
        warning(message('symbolic:sym:disp:UndefinedVariable'));
        return;
    end
    disp(allstrs);
else
    % Find maximum string length of the elements of X
    p = sz;
    d = length(p);
    allstrs = mupadmex('symobj::allstrs', X.s, 0);
    allstrs = strrep(allstrs,'_Var','');
    if ~isempty(strfind(allstrs,'_symans'))
        warning(message('symbolic:sym:disp:UndefinedVariable'));
        return;
    end
    allstrs = allstrs(2:end-3); % 3 covers the trailing #!"
    strs = regexp(allstrs,'#!','split');
    strs = reshape(strs,sz);
    lengths = cellfun('length',strs);
    while ~ismatrix(lengths)
        lengths = max(lengths,[],ndims(lengths));
    end
    len = max(lengths,[],1);
    
   for k = 1:prod(p(3:end))
      if d > 2
         if loose, disp(' '), end
         disp([inputname(1) '(:,:,' int2strnd(k,p(3:end)) ') = '])
         if loose, disp(' '), end
      end
      % Pad each element with the appropriate number of blanks
      for i = 1:p(1)
         str = '[';
         for j = 1:p(2)
            s = strs{i,j,k};
            s(s=='`') = [];
            str = [str blanks(len(j)-length(s)+1) s ','];%#ok
         end
         str(end) = ']';
         if p(2) == 1; str = str(2:end-1); end
         disp(str)
      end
   end
end
if displayTags
    disp('</symDisplay>');
end
if isa(X,'symfun') && ~novars
    vars = argnames(X);
    cvars = privToCell(vars);
    for k=1:length(vars)
        cvars{k} = char(cvars{k});
    end
    vars = sprintf('%s, ',cvars{:});
    vars(end-1:end)=[];
    disp(getString(message('symbolic:sym:disp:SymVars', vars)))
end
if loose, disp(' '), end
collectGarbage(symengine);
end

% ------------------------

function s = int2strnd(k,p)
s = '';
k = k-1;
for j = 1:length(p)
   d = mod(k,p(j));
   s = [s int2str(d+1) ',']; %#ok
   k = (k - d)/p(j);
end
s(end) = [];
end

