function display(X)
%DISPLAY Display function for syms.

%   Copyright 1993-2013 The MathWorks, Inc.

% get the correct number of digits to display for symfuns:
numbers = regexp(X(1).s, '^_symans_(\d+)', 'tokens');
if ~isempty(numbers)
  oldDigits = digits(numbers{1}{1});
  resetDigits = onCleanup(@() digits(oldDigits));
end

Xsym = privResolveArgs(X);
X = Xsym{1};
loose = isequal(get(0,'FormatSpacing'),'loose');
if loose, disp(' '), end
namestr = inputname(1);
if isempty(namestr)
    namestr = 'ans';
end
if isa(X,'symfun')
    vars = argnames(X);
    cvars = privToCell(vars);
    cvars = cellfun(@char,cvars,'UniformOutput',false);
    vars = sprintf('%s, ',cvars{:});
    vars(end-1:end)=[];
    namestr = [namestr '(' vars ')'];
end
displayTags = isappdata(0,'SymObjectDisplayTags');
if displayTags
    disp('<symVariableDisplay>');
end
fX = formula(X);
if isempty(fX) || ndims(fX) <= 2
   disp([namestr ' =']);
   if loose, disp(' '), end
   disp(X,true)
else
   p = size(fX);
   p = p(3:end);
   for k = 1:prod(p)
      if loose, disp(' '), end
      disp([namestr '(:,:,' int2strnd(k,p) ') = '])
      if loose, disp(' '), end
      sub = privsubsref(X,':',':',k);
      disp(sub);
   end
end
if displayTags
    disp('</symVariableDisplay>');
end

% ------------------------

function s = int2strnd(k,p)
s = '';
k = k-1;
for j = 1:length(p)
   d = mod(k,p(j));
   s = [s int2str(d+1) ',']; %#ok<AGROW>
   k = (k - d)/p(j);
end
s(end) = [];