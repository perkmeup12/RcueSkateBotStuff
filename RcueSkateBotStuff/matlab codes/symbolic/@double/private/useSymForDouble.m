function res = useSymForDouble(fn, varargin)
  for i = 1:nargin-1
    if ~isnumeric(varargin{i})
      error(message('symbolic:symbolic:NonNumericParameter'));
    end
  end
  oldDigits = digits(16);
  args = cellfun(@(x)vpa(x), varargin, 'UniformOutput', false);
  cleanupObj = onCleanup(@() digits(oldDigits));
  res = double(fn(args{:}));
end
