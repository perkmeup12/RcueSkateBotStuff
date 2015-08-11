classdef (InferiorClasses={?sym}) symfun < sym
    %SYMFUN   Symbolic function
    %   F = SYMFUN(FORMULA,INPUTS) returns a symbolic function
    %   with inputs INPUTS and body FORMULA. INPUTS must be a
    %   sym array of symbolic variables and FORMULA is a
    %   sym object expression.
    %
    %   Symbolic functions can represent both abstract functions
    %   as well as functions with a definition. To represent
    %   an abstract function use a formula like sym('f(x)').
    %
    %   The SYMS function and subscripted assignment provide a
    %   convenient syntax for defining symbolic functions.
    %
    %   Examples:
    %    syms f x y
    %    f = symfun(x+y, [x y])
    %    f(1,2)                 % returns 3
    %
    %    syms z(s,t)
    %    z(s,t) = s+t;
    %    f(s,t) - z(s,t)        % returns 0
    %
    %   See also SYMS, SYM/ARGNAMES, SYM/FORMULA, DSOLVE

    %   Copyright 2011-2012 The MathWorks, Inc.
    
    properties (Access=private)
        vars = sym([]);
    end
    properties (Access=private,Transient=true)
        fun = []; % if evaluation has happened the fun hold the MuPAD function
        matrixfun = []; % holds the nonscalar elements if any
    end
    methods
        function y = symfun(x,inputs)
            if isnumeric(x) 
                x = sym(x);
            end
            y = y@sym(formula(x));
            if ~isa(x,'sym') 
                error(message('symbolic:symfun:SymExpected'));
            end
            % check variables are simple names
            y.vars = validateArgNames(inputs);
        end

        function y = argnames(x)
            %ARGNAMES   Symbolic function input variables
            %   ARGNAMES(F) returns a sym array [X1, X2, ... ] of symbolic
            %   variables for F(X1, X2, ...).
            %
            %   Example
            %    syms f(x,y)
            %    argnames(f)    % returns [x, y]
            %
            %   See also SYM/FORMULA
            y = x.vars;
        end

        function c = isequal(a,b,varargin)
        %ISEQUAL     Symbolic function isequal test.
        %   ISEQUAL(A,B) returns true iff A and B are identical.
            
        if ~isa(a,'symfun') || ~isa(b,'symfun') || ~isequal(a.vars, b.vars)
            c = false;
        else
            mupc = mupadmex('symobj::isequal', a.s, b.s, 0);
            c = strcmp(mupc,'TRUE');
            if c && nargin > 2 
                c = isequal(b,varargin{:});
            end
        end
        end

        function c = isequaln(a,b,varargin)
        %ISEQUALN     Symbolic function isequal test.
        %   ISEQUALN(A,B) returns true iff A and B are identical treating
        %                 NaNs as equal.
            
        if ~isa(a,'symfun') || ~isa(b,'symfun') || ~isequal(a.vars, b.vars)
            c = false;
        else
            mupc = mupadmex('symobj::isequaln', a.s, b.s, 0);
            c = strcmp(mupc,'TRUE');
            if c && nargin > 2 
                c = isequaln(b,varargin{:});
            end
        end
        end
        
    end
    methods (Hidden=true)

        function Y = sym(X,a)
            if nargin == 2
                Y = sym(formula(X),a);
            else
                Y = X;
            end
        end
        
        function delete(x)
            if builtin('numel',x)==1 && ~isempty(x.fun) && inmem('-isloaded','mupadmex')
                h = x.fun;
                mupadmex(h, 1);
                h = x.matrixfun;
                if ~isempty(h)
                    cellfun(@(ref)mupadmex(ref, 1), h);
                end
            end
        end
        
        function varargout = subsindex(varargin)  %#ok<STOUT>
            error(message('symbolic:symfun:subsindex'))
        end

        function B = subsref(A,S)
        %SUBSREF Subscripted reference for a sym array. 
        %     B = SUBSREF(A,S) is called for the syntax A(I).  S is a structure array
        %     with the fields:
        %         type -- string containing '()' specifying the subscript type.
        %                 Only parenthesis subscripting is allowed.
        %         subs -- Cell array or string containing the actual subscripts.
        %
        %   See also SYM.
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            if length(S)>1
                error(message('symbolic:sym:NestedIndex'));
            end
            if strcmp(S.type,'()')
                Avars = A.vars;
                inds = S.subs;
                if length(inds) ~= length(Avars)
                    error(message('symbolic:symfun:subsref', length(Avars), length(inds)))
                end
                strs = cellfun(@ischar,inds);
                if any(strcmp(inds(strs),':'))
                    error(message('symbolic:symfun:subsrefColon'))
                end
                B = feval(A,inds{:});
            else
                error(message('symbolic:symfun:Indexing'));
            end
        end

        function C = privResolveOutput(C,A)
            C = symfun(C, A.vars);
        end
        
        function C = privResolveOutputAndDelete(C,A,x)
            if isa(A, 'symfun')
                fargs = privsubsref(A.vars, logical(A.vars ~= x));
                % if no variables are left, C remains a sym
                if ~isempty(fargs)
                    C = symfun(C, fargs);
                end    
            end    
        end

        function argout = privResolveArgs(varargin)
            sfun = [];
            argout = varargin;
            n = nargin;
            for k=1:n
                arg = varargin{k};
                if isa(arg,'symfun')
                    sfun = arg;
                    break
                end
            end
            fvars = sfun.vars;
            for k=1:n
                arg = varargin{k};
                if isa(arg,'sym') && builtin('numel',arg) ~= 1
                    argout{k} = normalizesym(arg);
                elseif ~isa(arg,'sym')
                    argout{k} = sym(arg);
                end
                if isa(arg,'symfun') && ~isequal(fvars,arg.vars)
                    error(message('symbolic:symfun:InputMatch'));
                else
                    argout{k} = symfun(argout{k},fvars);
                end
            end
        end

        function y = exist(varargin)
            y = 0;
        end

        function varargout = end(varargin) %#ok<STOUT>
            error(message('symbolic:symfun:EndNotImplemented'));
        end
    end
end

function args = validateArgNames(args)
%validateArgNames   When creating symfuns make sure the arguments are simple sym object names
if ~isa(args,'sym') || ~isvector(args)
    error(message('symbolic:symfun:VarsExpected'))
end
args2 = unique(args);
if length(args2) ~= length(args)
    error(message('symbolic:symfun:VarsExpected'))
end
for k=1:length(args)
    arg = args(k);
    if ~isvarname(char(arg)) || ...
            ~strcmp(mupadmex(['testtype(' charcmd(arg) ',Type::Indeterminate)'],0),'TRUE')
        error(message('symbolic:symfun:VarsExpected'))
    end
end
end
