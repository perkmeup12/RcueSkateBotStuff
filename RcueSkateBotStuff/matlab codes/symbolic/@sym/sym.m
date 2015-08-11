classdef sym < handle
    %SYM    Construct symbolic numbers, variables and objects.
    %   S = SYM(A) constructs an object S, of class 'sym', from A.
    %   If the input argument is a string, the result is a symbolic number
    %   or variable.  If the input argument is a numeric scalar or matrix,
    %   the result is a symbolic representation of the given numeric values.
    %   If the input is a function handle the result is the symbolic form
    %   of the body of the function handle.
    %
    %   x = sym('x') creates the symbolic variable with name 'x' and stores the
    %   result in x.  x = sym('x','real') also assumes that x is real, so that
    %   conj(x) is equal to x.  alpha = sym('alpha') and r = sym('Rho','real')
    %   are other examples.  Similarly, k = sym('k','positive') makes k a
    %   positive (real) variable.  x = sym('x','clear') restores x to a
    %   formal variable with no additional properties (i.e., insures that x
    %   is NEITHER real NOR positive). Defining the symbol 'i' will use
    %   sqrt(-1) in place of the imaginary i until 'clear' is used.
    %   See also: SYMS.
    %
    %    A = sym('A',[M N]) creates M-by-N vectors or matrices of symbolic scalar
    %   variables. Elements of vectors have names of the form Ak and elements
    %   of matrices have names of the form Ai_j where k,i or j range over 1:M
    %   or 1:N. The form can be controlled exactly by using '%d' in the first
    %   input (eg 'A%d%d' will make names Aij).
    %   A = sym('A',N) creates an N-by-N matrix.
    %   sym(A,ASSUMPTION) makes or clears assumptions on A as described in
    %   the previous paragraph.
    %
    %   Statements like pi = sym('pi') and delta = sym('1/10') create symbolic
    %   numbers which avoid the floating point approximations inherent in the
    %   values of pi and 1/10.  The pi created in this way temporarily replaces
    %   the built-in numeric function with the same name.
    %
    %   S = sym(A,flag) converts a numeric scalar or matrix to symbolic form.
    %   The technique for converting floating point numbers is specified by
    %   the optional second argument, which may be 'f', 'r', 'e' or 'd'.
    %   The default is 'r'.
    %
    %   'f' stands for 'floating point'.  All values are transformed from
    %   double precision to exact numeric values N*2^e for integers N and e.
    %
    %   'r' stands for 'rational'.  Floating point numbers obtained by
    %   evaluating expressions of the form p/q, p*pi/q, sqrt(p), 2^q and 10^q
    %   for modest sized integers p and q are converted to the corresponding
    %   symbolic form.  This effectively compensates for the roundoff error
    %   involved in the original evaluation, but may not represent the floating
    %   point value precisely.  If no simple rational approximation can be
    %   found, the 'f' form is used.
    %
    %   'e' stands for 'estimate error'.  The 'r' form is supplemented by a
    %   term involving the variable 'eps' which estimates the difference
    %   between the theoretical rational expression and its actual floating
    %   point value.  For example, sym(3*pi/4,'e') is 3*pi/4-103*eps/249.
    %
    %   'd' stands for 'decimal'.  The number of digits is taken from the
    %   current setting of DIGITS used by VPA.  Using fewer than 16 digits
    %   reduces accuracy, while more than 16 digits may not be warranted.
    %   For example, with digits(10), sym(4/3,'d') is 1.333333333, while
    %   with digits(20), sym(4/3,'d') is 1.3333333333333332593,
    %   which does not end in a string of 3's, but is an accurate decimal
    %   representation of the double-precision floating point number nearest
    %   to 4/3.
    %
    %   See also SYMS, CLASS, DIGITS, VPA.

    %   The flag 'unreal' is the same as 'clear'.

    %   Copyright 1993-2013 The MathWorks, Inc.

    properties (Access=protected)
        s
    end
    methods(Static)
        function y = loadobj(x)
        %LOADOBJ    Load symbolic object
        %   Y = LOADOBJ(X) is called when loading symbolic objects

        if isa(x,'struct')
            if isscalar(x)
                cx = {x.s};
            else
                cx = reshape({x.s},size(x));
            end
            y = sym(cx);
        else
            n = builtin('numel',x);
            if n > 1
                % x is an ndim sym
                cx = reshape({x.s},size(x));
                y = sym(cx);
            elseif n == 0
                y = reshape(sym([]),size(x));
            else
                y = x;
            end
        end
        end

        function y = zeros(varargin)
        %ZEROS  Symbolic version of the builtin function ZEROS.
            y = sym(zeros(varargin{:}));
        end

        function y = ones(varargin)
        %ONES  Symbolic version of the builtin function ONES.
            y = sym(ones(varargin{:}));
        end

        function y = empty(varargin)
        %EMPTY  Symbolic version of the builtin function EMPTY.
            y = sym(zeros(varargin{:}));
        end

        function y = inf(varargin)
        %INF  Symbolic version of the builtin function INF.
            y = sym(inf(varargin{:}));
        end

        function y = nan(varargin)
        %NAN  Symbolic version of the builtin function NAN.
            y = sym(nan(varargin{:}));
        end

        function y = eye(varargin)
        %EYE  Symbolic version of the builtin function EYE.
            y = sym(eye(varargin{:}));
        end

        function y = cast(a)
        %CAST  Symbolic version of the builtin function CAST.
            y = sym(a);
        end
    end
    methods
        function S = sym(x,a)

        [~] = symengine;
        if nargin == 1
            S.s = tomupad(x,'');
        elseif nargin == 0
            % Default constructor
            S.s = '0';
        else
            S.s = tomupad(x,a);
        end
        end % sym constructor

        function delete(h)
        if builtin('numel',h)==1 && inmem('-isloaded','mupadmex')
            mupadmex(h.s,1);
        end
        end

        function y = argnames(~)
            %ARGNAMES   Symbolic function input variables
            %   ARGNAMES(F) returns a sym array [X1, X2, ... ] of symbolic
            %   variables for F(X1, X2, ...).
            y = sym([]);
        end

        function y = formula(x)
            %FORMULA   Symbolic function formula body
            %   FORMULA(F) returns the definition of symbolic
            %   function F as a sym object expression.
            %
            %   Examples:
            %    syms f(x,y)
            %    f(x,y) = x+y;
            %    formula(f)    % returns x+y
            %
            %    syms y(x)
            %    formula(y)    % returns y(x)
            %
            %   See also SYMFUN/ARGNAMES
            y = sym(mupadmex(x.s,11));
        end

        function y = length(x)
        %LENGTH   Length of symbolic vector.
        %   LENGTH(X) returns the length of vector X.  It is equivalent
        %   to MAX(SIZE(X)) for non-empty arrays and 0 for empty ones.
        %
        %   See also NUMEL.
        xsym = privResolveArgs(x);
        x = xsym{1};
        sz = size(x);
        if prod(sz)==0
            y = 0;
        else
            y = max(sz);
        end
        end

        %---------------   Arithmetic  -----------------
        function Y = uminus(X)
        %UMINUS Symbolic negation.
        Y = privUnaryOp(X, 'symobj::map', '_negate');
        end

        function Y = uplus(X)
        %UPLUS Unary plus.
        Xsym = privResolveArgs(X);
        X = Xsym{1};
        Y = X;
        end

        function X = times(A, B)
        %TIMES  Symbolic array multiplication.
        %   TIMES(A,B) overloads symbolic A .* B.
        X = privBinaryOp(A, B, 'symobj::zip', '_mult');
        end

        function X = mtimes(A, B)
        %TIMES  Symbolic matrix multiplication.
        %   MTIMES(A,B) overloads symbolic A * B.
        X = privBinaryOp(A, B, 'symobj::mtimes');
        end

        function B = mpower(A,p)
        %POWER  Symbolic matrix power.
        %   POWER(A,p) overloads symbolic A^p.
        %
        %   Example;
        %      A = [x y; alpha 2]
        %      A^2 returns [x^2+alpha*y  x*y+2*y; alpha*x+2*alpha  alpha*y+4].
        B = privBinaryOp(A, p, 'symobj::mpower');
        end

        function B = power(A,p)
        %POWER  Symbolic array power.
        %   POWER(A,p) overloads symbolic A.^p.
        %
        %   Examples:
        %      A = [x 10 y; alpha 2 5];
        %      A .^ 2 returns [x^2 100 y^2; alpha^2 4 25].
        %      A .^ x returns [x^x 10^x y^x; alpha^x 2^x 5^x].
        %      A .^ A returns [x^x 1.0000e+10 y^y; alpha^alpha 4 3125].
        %      A .^ [1 2 3; 4 5 6] returns [x 100 y^3; alpha^4 32 15625].
        %      A .^ magic(3) is an error.
        B = privBinaryOp(A, p, 'symobj::zip', '_power');
        end

        function X = rdivide(A, B)
        %RDIVIDE Symbolic array right division.
        %   RDIVIDE(A,B) overloads symbolic A ./ B.
        %
        %   See also SYM/LDIVIDE, SYM/MRDIVIDE, SYM/MLDIVIDE, SYM/QUOREM.
        X = privBinaryOp(A, B, 'symobj::zip', 'symobj::divide');
        end

        function X = ldivide(A, B)
        %LDIVIDE Symbolic array left division.
        %   LDIVIDE(A,B) overloads symbolic A .\ B.
        %
        %   See also SYM/RDIVIDE, SYM/MRDIVIDE, SYM/MLDIVIDE, SYM/QUOREM.
        X = privBinaryOp(B, A, 'symobj::zip', 'symobj::divide');
        end

        function X = mrdivide(A, B)
        %/  Slash or symbolic right matrix divide.
        %   A/B is the matrix division of B into A, which is roughly the
        %   same as A*INV(B) , except it is computed in a different way.
        %   More precisely, A/B = (B'\A')'. See SYM/MLDIVIDE for details.
        %   Warning messages are produced if X does not exist or is not unique.
        %   Rectangular matrices A are allowed, but the equations must be
        %   consistent; a least squares solution is not computed.
        %
        %   See also SYM/MLDIVIDE, SYM/RDIVIDE, SYM/LDIVIDE, SYM/QUOREM.
        X = privBinaryOp(A, B, 'symobj::mrdivide');
        end

        function X = mldivide(A, B)
        %MLDIVIDE Symbolic matrix left division.
        %   MLDIVIDE(A,B) overloads symbolic A \ B.
        %   X = A\B solves the symbolic linear equations A*X = B.
        %   Warning messages are produced if X does not exist or is not unique.
        %   Rectangular matrices A are allowed, but the equations must be
        %   consistent; a least squares solution is not computed.
        %
        %   See also SYM/MRDIVIDE, SYM/LDIVIDE, SYM/RDIVIDE, SYM/QUOREM.
        X = privBinaryOp(A, B, 'symobj::mldivide');
        end

        %---------------   Logical Operators    -----------------

        function X = eq(A, B)
            %EQ     Symbolic equality test.
            %   EQ(A,B) overloads symbolic A == B. If A and B are integers,
            %   rational numbers, floating point values or complex numbers
            %   then A == B compares the values and returns true or false.
            %   Otherwise A == B returns a sym object of the unevaluated equation
            %   which can be passed to other functions like solve. To force
            %   the equation to perform a comparison call LOGICAL or isAlways.
            %   LOGICAL will compare the two sides structurally. isAlways will
            %   compare the two sides mathematically.
            %
            %   See also SYM/LOGICAL, SYM/isAlways
            X = privComparison(A, B, '_equal', 'FALSE', 'FALSE');
        end

        function X = ne(A, B)
            %NE     Symbolic inequality test.
            %   NE(A,B) overloads symbolic A ~= B.  The result is the opposite of
            %   A == B.
            X = privComparison(A, B, '_unequal', 'FALSE', 'TRUE');
        end

        function X = logical(A)
            %LOGICAL     Convert symbolic expression to logical array
            %    Y = LOGICAL(X) converts each element of the symbolic
            %   array X into the value true or false.
            %   Symbolic equations are converted to true
            %   only if the left and right sides are identically
            %   the same. Otherwise the equation is converted to
            %   false. Inequalities which cannot be proved will
            %   throw an error.
            %
            %   See also: sym/isAlways
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            X = mupadmex('symobj::logical',A.s,9);
        end

        function X = all(A,varargin)
            %ALL     True if all symbolic values are true
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            B = mupadmex('symobj::all',A.s,9);
            X = all(B,varargin{:});
        end

        function varargout = find(A,varargin)
            %FIND    Find non-zero elements of symbolic arrays
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            B = mupadmex('symobj::find',A.s,9);
            if nargout == 3
                [i,j] = find(B,varargin{:});
                c = sym(i);
                for k = 1:length(i)
                    c(k) = privTrinaryOp(A, i(k), j(k), '_index');
                end
                varargout{1} = i;
                varargout{2} = j;
                if size(A,1) == 1
                    varargout{3} = c;
                else
                    varargout{3} = c.';
                end
            else
                [varargout{1:nargout}] = find(B,varargin{:});
            end
        end

        function X = any(A,varargin)
            %ANY     True if any symbolic value is true
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            B = mupadmex('symobj::all',A.s,9);
            X = any(B,varargin{:});
        end

        function c = isequal(a,b,varargin)
        %ISEQUAL     Symbolic isequal test.
        %   ISEQUAL(A,B) returns true iff A and B are identical.
        args = privResolveArgs(a, b, varargin{:});
        mupc = mupadmex('symobj::isequal', args{1}.s, args{2}.s, 0);
        c = strcmp(mupc,'TRUE');
        if c && nargin > 2
            c = isequal(b,varargin{:});
        end
        end

        function c = isequaln(a,b,varargin)
        %ISEQUALN     Symbolic isequaln test.
        %   ISEQUALN(A,B) returns true iff A and B are identical
        %   treating NaNs as equal.
        args = privResolveArgs(a, b, varargin{:});
        mupc = mupadmex('symobj::isequaln', args{1}.s, args{2}.s, 0);
        c = strcmp(mupc,'TRUE');
        if c && nargin > 2
            c = isequaln(b,varargin{:});
        end
        end

        function X = gt(A,B)
            %GT     Symbolic greater-than.
            X = privComparison(B, A, '_less', 'TRUE', 'FALSE');
        end

        function X = lt(A,B)
            %LT     Symbolic less-than.
            X = privComparison(A, B, '_less', 'TRUE', 'FALSE');
        end

        function X = ge(A,B)
            %GE     Symbolic greater-than-or-equal.
            X = privComparison(B, A, '_leequal', 'TRUE', 'FALSE');
        end

        function X = le(A,B)
            %LE     Symbolic less-than-or-equal.
            X = privComparison(A, B, '_leequal', 'TRUE', 'FALSE');
        end

        function assume(cond,set)
            %ASSUME Assume symbolic relationship.
            %   ASSUME(COND) sets the condition COND to be true. When you
            %   set an assumption, the toolbox replaces any previous
            %   assumptions on the free variables in COND with the new
            %   assumption.
            %   ASSUME(X,SET) assumes the variable X is in the specified
            %   set. Specify SET as 'integer','rational', or 'real'.
            %
            %   Example
            %     syms x
            %     assume(x > 1)
            %     isAlways(sqrt(x^2) > 1)  % returns true
            %     sym(x,'clear')           % removes assumptions
            %
            %   See also SYM, SYM/assumeAlso,ASSUMPTIONS.
            if builtin('numel',cond) ~= 1,  cond = normalizesym(cond);  end
            if isa(cond,'symfun')
                error(message('symbolic:sym:AssumptionOnFunctionsNotSupported'));
            end
            if nargin == 2
                mset = setToMuPADSet(set);
                assumeAll(cond.s,mset,true,false);
            else
                assumeAll(cond.s,'',true,false);
            end
        end

        function assumeAlso(cond,set)
            %assumeAlso Add symbolic assumption.
            %   assumeAlso(COND) sets the condition COND to be true
            %   in addition to all previous assumptions.
            %   assumeAlso(X,SET) assumes the variable X is in the specified
            %   set. Specify SET as 'integer','rational', or 'real'.
            %
            %   Example
            %     syms x y
            %     assume(x < y)
            %     assumeAlso(y > 0)
            %     isAlways(x^2 >= y^2)  % returns true
            %     syms x y clear        % removes assumptions
            %
            %   See also SYM, SYM/ASSUME, ASSUMPTIONS.
            if builtin('numel',cond) ~= 1,  cond = normalizesym(cond);  end
            if isa(cond,'symfun')
                error(message('symbolic:sym:AssumptionOnFunctionsNotSupported'));
            end
            if nargin == 2
                mset = setToMuPADSet(set);
                assumeAll(cond.s,mset,true,true);
            else
                assumeAll(cond.s,'',true,true);
            end
        end

        function X = and(A,B)
            %AND     Symbolic & (and).
            X = privBinaryOp(A, B, 'symobj::zip', 'symobj::_and');
        end

        function X = or(A,B)
            %OR     Symbolic | (or).
            X = privBinaryOp(A, B, 'symobj::zip', 'symobj::_or');
        end

        function X = xor(A,B)
            %XOR     Symbolic exclusive-or.
            X = privBinaryOp(A, B, 'symobj::zip', 'symobj::_xor');
        end

        function X = not(A)
            %NOT     Symbolic ~ (not).
            X = privUnaryOp(A, 'symobj::map', '_not');
        end

        function r = isreal(x)
        %ISREAL True for real symbolic array
        %   ISREAL(X) returns true if X equals conj(X) and false otherwise.
        r = isequal(x,conj(x));
        end

        function y = isscalar(x)
        %ISSCALAR True if symbolic array is a scalar
        %   ISSCALAR(S) returns logical true (1) if S is a 1 x 1 symbolic matrix
        %   and logical false (0) otherwise.
        xsym = privResolveArgs(x);
        x = xsym{1};
        y = numel(x)==1;
        end

        function y = isempty(x)
        %ISEMPTY True for empty symbolic array
        %   ISEMPTY(X) returns 1 if X is an empty array and 0 otherwise. An
        %   empty array has no elements, that is prod(size(X))==0.
        xsym = privResolveArgs(x);
        x = xsym{1};
        y = numel(x)==0;
        end

        %---------------   Conversions  -----------------

        function X = double(S)
        %DOUBLE Converts symbolic matrix to MATLAB double.
        %   DOUBLE(S) converts the symbolic matrix S to a matrix of double
        %   precision floating point numbers.  S must not contain any symbolic
        %   variables, except 'eps'.
        %
        %   See also SYM, VPA.
        if builtin('numel',S) ~= 1 
            S = normalizesym(S);  
        end
        siz = size(formula(S));
        Xstr = mupadmex('symobj::double', S.s, 0);
        X = eval(Xstr);
        if prod(siz) ~= 1
            X = reshape(X,siz);
        end
        end

        function g = inline(f,varargin)
        %INLINE Generate an inline object from a sym object
        %     G = INLINE(F) generates an inline object G from the symbolic
        %     expression F using the matlabFunction sym method.
        %
        %     See also: matlabFunction

        f = sym(f);
        if builtin('numel',f) ~= 1,  f = normalizesym(f);  end
        func = matlabFunction(f);
        c = func2str(func);
        paren = find(c==')',1);
        g = inline(c(paren+1:end),varargin{:}); %#ok<DINLN>
        end

        function S = single(X)
        %SINGLE Converts symbolic matrix to single precision.
        %   SINGLE(S) converts the symbolic matrix S to a matrix of single
        %   precision floating point numbers.  S must not contain any symbolic
        %   variables, except 'eps'.
        %
        %   See also SYM, SYM/VPA, SYM/DOUBLE.
        S = single(double(X));
        end

        function Y = int8(X)
        %INT8 Converts symbolic matrix to signed 8-bit integers.
        %   INT8(S) converts a symbolic matrix S to a matrix of
        %   signed 8-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT16, INT32, INT64, UINT8, UINT16, UINT32, UINT64.
        Y = int8(int64(X));
        end

        function Y = int16(X)
        %INT16 Converts symbolic matrix to signed 16-bit integers.
        %   INT16(S) converts a symbolic matrix S to a matrix of
        %   signed 16-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT32, INT64, UINT8, UINT16, UINT32, UINT64.
        Y = int16(int64(X));
        end

        function Y = int32(X)
        %INT32 Converts symbolic matrix to signed 32-bit integers.
        %   INT32(S) converts a symbolic matrix S to a matrix of
        %   signed 32-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT64, UINT8, UINT16, UINT32, UINT64.
        Y = int32(int64(X));
        end

        function Y = int64(X)
        %INT64 Converts symbolic matrix to signed 64-bit integers.
        %   INT64(S) converts a symbolic matrix S to a matrix of
        %   signed 64-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT32, UINT8, UINT16, UINT32, UINT64.
        Xsym = privResolveArgs(X);
        X = Xsym{1};
        siz = size(formula(X));
        Xd = mupadmex('symobj::double', X.s);
        Xstr = mupadmex('symobj::map', Xd.s, 'round', 0);
        Y = eval(['int64(' Xstr ')']);
        if prod(siz) ~= 1
            Y = reshape(Y,siz);
        end
        end

        function Y = uint8(X)
        %UINT8 Converts symbolic matrix to unsigned 8-bit integers.
        %   UINT8(S) converts a symbolic matrix S to a matrix of
        %   unsigned 8-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT32, INT64, UINT16, UINT32, UINT64.
        Y = uint8(uint64(X));
        end

        function Y = uint16(X)
        %UINT16 Converts symbolic matrix to unsigned 16-bit integers.
        %   UINT16(S) converts a symbolic matrix S to a matrix of
        %   unsigned 16-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT32, INT64, UINT8, UINT32, UINT64.
        Y = uint16(uint64(X));
        end

        function Y = uint32(X)
        %UINT32 Converts symbolic matrix to unsigned 32-bit integers.
        %   UINT32(S) converts a symbolic matrix S to a matrix of
        %   unsigned 32-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT32, INT64, UINT8, UINT16, UINT64.
        Y = uint32(uint64(X));
        end

        function Y = uint64(X)
        %UINT64 Converts symbolic matrix to unsigned 64-bit integers.
        %   UINT64(S) converts a symbolic matrix S to a matrix of
        %   unsigned 64-bit integers.
        %
        %   See also SYM, VPA, SINGLE, DOUBLE,
        %   INT8, INT16, INT32, INT64, UINT8, UINT16, UINT32.
        Xsym = privResolveArgs(X);
        X = Xsym{1};
        siz = size(formula(X));
        Xd = mupadmex('symobj::double', X.s);
        Xstr = mupadmex('symobj::map', Xd.s, 'round', 0);
        Y = eval(['uint64(' Xstr ')']);
        if prod(siz) ~= 1
            Y = reshape(Y,siz);
        end
        end

        function Y = full(X)
        %FULL Create non-sparse array
        %   Y = FULL(X) creates a full symbolic array from X.
        Y = X;
        end

    end % public methods

    methods (Hidden=true)

        %---------------   Indexing  -----------------

        function X = subsindex(A)
            %SUBSINDEX Symbolic subsindex function
            if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
            kind = mupadmex('symobj::subsindex',A.s,0);
            if kind(2) == 'L'
                X = find(mupadmex('symobj::logical',A.s,9)) - 1;
            elseif kind(2) == 'D' || isempty(A)
                X = double(A) - 1;
            else
                error(message('symbolic:sym:subscript:InvalidIndexOrFunction'));
            end
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
        if builtin('numel',A) ~= 1
            A = normalizesym(A);
        end
        if length(S)>1
            error(message('symbolic:sym:NestedIndex'));
        end
        inds = S.subs;
        refs = cell(length(inds),1);
        for k=1:length(inds)
            [inds{k},refs{k}] = privformat(inds{k});
        end
        B = mupadmex('symobj::subsref',A.s,inds{:});
        end

        function y = end(x,varargin)
        %END Last index in an indexing expression for a sym array.
        %   END(A,K,N) is called for indexing expressions involving the sym
        %   array A when END is part of the K-th index out of N indices.  For example,
        %   the expression A(end-1,:) calls A's END method with END(A,1,2).
        %
        %   See also SYM.
        xsym = privResolveArgs(x);
        x = xsym{1};
        sz = size(x);
        k = varargin{1};
        n = varargin{2};
        if n < length(sz) && k==n
            sz(n) = prod(sz(n:end));
        end
        y = sz(k);
        end

        function C = subsasgn(A,S,B)
        %SUBSASGN Subscripted assignment for a sym array.
        %     A = SUBSASGN(A,S,B) is called for the syntax A(I)=B.  S is a structure
        %     array with the fields:
        %         type -- string containing '()' specifying the subscript type.
        %                 Only parenthesis subscripting is allowed.
        %         subs -- Cell array or string containing the actual subscripts.
        %
        %   See also SYM.
            if ~isa(A,'sym')
                A = sym(A);
            end
            if builtin('numel',A) ~= 1
                A = normalizesym(A);
            end
            if isempty(A) && ~isequal(size(A),[0,0])
                error(message('symbolic:sym:IndexedAssignmentOnEmptyObjectsNotSupported'));
            end
            if ~isa(B,'sym')
                B = sym(B);
            end
            if builtin('numel',B) ~= 1
                B = normalizesym(B);
            end
            if length(S)>1
                error(message('symbolic:sym:NestedIndex'));
            end
            if ~strcmp(S.type,'()')
                error(message('symbolic:sym:InvalidIndexingAssignment'));
            end
            inds = S.subs;
            dosubs = ~isa(A,'symfun');
            if dosubs
                dosubs = false;
                for k=1:length(inds)
                    if ~isa(inds{k},'sym')
                        dosubs = true;
                        break;
                    end
                end
            end
            if dosubs
                refs = cell(length(inds),1);
                for k=1:length(inds)
                    [inds{k},refs{k}] = privformat(inds{k});
                end
                if isequal(size(A),[0,0])
                    % make sure to match Core MATLAB's format: set
                    % up auxiliary object to be filled.
                    S = builtin('subsasgn',[],S,zeros(size(B)));
                    A = sym(S);
                end
                C = mupadmex('symobj::subsasgn',A.s,B.s,inds{:});
            else
                C = symfun(B,[inds{:}]);
            end
        end

        function y = makeListOutOfMuPADSequences(x)
            y = mupadmex(['DOM_LIST(', x.s, ')']);
        end

        function [y,flag] = isNullObjOrSeq(x)
        %isNullObjOrSeq Test for null object or sequence
        %   [y,flag] = isNullObjOrSeq(X) returns true if X is a sym object
        %   for the MuPAD null object or the MuPAD sequence. In case y is
        %   true, the second argument indicates whether X is the MuPAD
        %   null object or a MuPAD sequence. In case y is false, the
        %   return value for flag is the empty string.
        xsym = privResolveArgs(x);
        x = xsym{1};
        str = mupadmex('type', x.s, 0);
        y = strcmp(str,'') || strcmp(str,'DOM_NULL');
        if y == true
            flag = 'null()';
        else
            y = strcmp(str,'"_exprseq"');
            if y == true
                flag = 'sequence';
            else
                flag = ' ';
            end
        end
        end

        function argout = privResolveArgs(varargin)
            argout = varargin;
            n = nargin;
            for k=1:n
                arg = varargin{k};
                if isa(arg,'sym') && builtin('numel',arg) ~= 1
                    argout{k} = normalizesym(arg);
                elseif ~isa(arg,'sym')
                    argout{k} = sym(arg);
                end
            end
        end

        function C = privResolveOutput(C,~)
        end

        function C = privResolveOutputAndDelete(C,~,~)
        end
        
        function C = privTrinaryOp(A,B,C,op,varargin)
            args = privResolveArgs(A, B, C);
            Csym = mupadmex(op,args{1}.s, args{2}.s, args{3}.s, varargin{:});
            C = privResolveOutput(Csym, args{1});
        end

        function C = privBinaryOp(A,B,op,varargin)
            args = privResolveArgs(A, B);
            Csym = mupadmex(op,args{1}.s, args{2}.s, varargin{:});
            C = privResolveOutput(Csym, args{1});
        end

        function B = privUnaryOp(A,op,varargin)
            args = privResolveArgs(A);
            Csym = mupadmex(op,args{1}.s,varargin{:});
            B = privResolveOutput(Csym,A);
        end

        function X = privComparison(A,B,op,project,flipnan)
            args = privResolveArgs(A, B);
            [Xsym, indets] = mupadmexnout('symobj::eq', args{1}, args{2}.s, ...
                op, project, flipnan);
            c = char(indets);
            if c(1) == 'F'
                X = mupadmex('symobj::logical',Xsym.s,9);
            else
                X = privResolveOutput(Xsym, args{1});
            end
        end

        function M = charcmd(A)
        %CHARCMD   Convert scalar or array sym to string command form
        %   CHARCMD(A) converts A to its string representation for sending commands
        %   to the symbolic engine.
        if builtin('numel',A) ~= 1,  A = normalizesym(A);  end
        M = A.s;
        end

        function varargout = mupadmexnout(fcn,varargin)
        %MUPADMEXNOUT
        %    This is an undocumented function that may be removed in a future release.
        args = varargin;
        for k=1:nargin-1
            arg = args{k};
            if isa(arg,'sym')
                args{k} = arg.s;
            end
        end
        out = mupadmex(fcn,args{:});
        varargout = cell(1,nargout);
        for k=1:nargout
            varargout{k} = mupadmex(sprintf('%s[%d]',out.s,k));
        end
        end

        function y = privsubsref(x,varargin)
        %PRIVSUBSREF Private access to subsref
        %   Y = PRIVSUBSREF(X,I1,I2,...) returns the subsref X(I1,I2,..). Methods
        %   in the sym class can call this to avoid calling the builtin subsref.
        refs = cell(length(varargin),1);
        for k=1:length(varargin)
            [varargin{k},refs{k}] = privformat(varargin{k});
        end
        y = mupadmex('symobj::subsref',x.s,varargin{:});
        end

        function y = privsubsasgn(x,b,varargin)
        %PRIVSUBSASGN Private access to subsasgn
        %   Y = PRIVSUBSASGN(X,B,I1,I2,...) returns the subsasgn X(I1,I2,..)=B. Methods
        %   in the sym class can call this to avoid calling the builtin subsasgn.
        refs = cell(length(varargin),1);
        for k=1:length(varargin)
            [varargin{k},refs{k}] = privformat(varargin{k});
        end
        y = mupadmex('symobj::subsasgn',x.s,b.s,varargin{:});
        end

        function y = privToCell(x)
            y = arrayfun(@(t){t},x);
        end

        function y = normalizesym(x)
        %NORMALIZESYM Normalize an n-dim array sym to 9b semantics
        %   Y = NORMALIZESYM(X) checks if X is an n-dim array loaded
        %   from 9a mat file and converts it to a scalar ptr-to-array
        %   value used in 9b.
        sz = builtin('size',x);
        if prod(sz) == 0
            y = reshape(sym([]),sz);
        else
            c = cell(sz);
            for k=1:prod(sz)
                c{k} = x(k).s;
            end
            y = sym(c);
        end
        end

        function ezhelper(fcn,f,varargin)
        %EZHELPER Helper function for ezmesh, ezmeshc and ezsurf
        %   EZHELPER(FCN,F,...) turns sym object F into a function handle
        %   and calls the regular ez-function FCN.
        %   EZHELPER(FCN,X,Y,Z,...) turns sym objects X,Y,Z into a function handle
        %   and calls the regular ez-function FCN.
        if (length(varargin) >= 2) && (isa(varargin{1},'sym') || isa(varargin{2},'sym'))
            y = varargin{1};
            z = varargin{2};
            vars = unique([symvar(f) symvar(y) symvar(z)]);
            F = matlabFunction(f,'vars',vars);
            Y = matlabFunction(y,'vars',vars);
            Z = matlabFunction(z,'vars',vars);
            checkNoSyms(varargin(3:end));
            fcn(F,Y,Z,varargin{3:end});
            title(texlabel(['x = ' char(f) ', y = ' char(y) ', z = ' char(z)]));
        else
            F = matlabFunction(f);
            checkNoSyms(varargin);
            fcn(F,varargin{:});
            title(texlabel(char(f)));
        end
        end

        function generateCode(t,lang,opts)
        %generateCode Helper function for code generation
        %   generateCode(t,lang,opts) generates code for lang for the expression
        %   with name t and options opts.

        if nargout > 0
            error(message('symbolic:sym:generateCode:NoOutput'));
        end
        gent = mupadmex('symobj::optimize',t.s);
        file = opts.file;
        [fid,msg] = fopen(file,'wt');
        if fid == -1
            error(message('symbolic:sym:generateCode:FileError', file, msg));
        end
        tmp = onCleanup(@()fclose(fid));
        for k = 1:length(gent)
            expr = sprintf('%s[%d]',gent.s, k);
            tk = mupadmex(['generate::' lang], expr, 0);
            str = strtrim(sprintf(tk));
            str(str == '"') = [];
            fprintf(fid,'%s',str);
        end
        end

    end    % private methods

end % classdef

%---------------   Subfunctions   -----------------

function S = tomupad(x,a)
%TOMUPAD    Convert input to sym reference string
% Called by sym constructor to take 'x' (just about anything) and possible
% assumption 'a' and return the reference string S. This function is recursive
% since it calls mupadmex and it can call back into sym with _symansNNN.
% The reference string for simple variable names like 'x' or 'foo' is
% the variable name (with possible _Var appended). If 'a' is a size vector
% then a vector or matrix symbolic variable is constructed.

if isa(x,'function_handle')
    x = funchandle2ref(x);
end

% avoid conversion to double for large integers that lose precision there:

if isa(x,'char')
    if ~isempty(x) && x(1)=='_'
        % answer from mupadmex _symansNNN
        S = x;
    else
        S = convertCharWithOption(x,a);
    end
elseif isnumeric(x) || islogical(x)
    if isempty(a), a = 'r'; end
    S = cell2ref(numeric2cellstr(x,a));
elseif isa(x,'sym')
    xsym = privResolveArgs(x);
    x = xsym{1};
    S = mupadmex(x.s,11);  % make a new reference
    privAssumptions(S,x.s,a);
elseif iscell(x)
    S = cell2ref(x);
else
    error(message('symbolic:sym:sym:errmsg7', class( x )))
end
end

function privAssumptions(x,name,a)
%ASSUMPTIONS   Handle assumptions on names
%   Does error checking and checking for 'i' and then makes
%   real/unreal/clear/positive assumption on sym object or string x
if strcmp(x,'i')
    if assumeI(a)
        return;
    end
end
if isempty(a)
    return;
end
if ~strcmp(a,'real') && ~strcmp(a,'unreal') && ~strcmp(a,'positive') && ~strcmp(a,'clear')
    error(message('symbolic:sym:sym:errmsg1'));
elseif ~isempty(name) && name(1)=='_'
    assumeAll(name,a);
elseif ~isvarname(name)
    error(message('symbolic:sym:sym:errmsg2'))
else
    privAssume(x,a,false,false);
end
end

function assumeAll(x,a,general,append)
%assumeAll make assumptions on a vector or matrix sym object.
if nargin == 2
    general = false;
    append = false;
end
if ~isempty(x) && x(1)=='_'
    sz = eval(mupadmex('symobj::size',x,0));
    total = prod(sz);
    for k=1:total
        name = mupadmex('symobj::subsref',x,num2str(k),0);
        privAssume(name,a,general,append);
    end
else
    privAssume(x,a,general,append);
end
end

function privAssume(x,a,general,append)
%PRIVASSUME   Makes or clears assumptions about x
if x(1)=='_'
    x = mupadmex(x,0);
end
if append
    fun = 'assumeAlso';
else
    fun = 'assume';
end
if ~general && ~isvarname(x)
    error(message('symbolic:sym:VariableExpected', x));
end
if isempty(a)
    mupadmex(fun, x);
else
    switch a
        case 'real'
            mupadmex(fun, x, 'Type::Real');
        case {'unreal','clear'}
            mupadmex('unassume', x);
            mupadmex('unalias', x);
        case 'positive'
            mupadmex([fun '(' x ' > 0):']);
        otherwise
            mupadmex(fun, x, a);
    end
end
end

function skip = assumeI(a)
%assumeI makes or clears assumptions about sqrt(-1).
mupadmex('unalias(i,sqrtmone):');
skip = strcmp(a,'clear') || strcmp(a,'unreal');
if skip
    mupadmex('alias(i=I):');
    mupadmex('i',8);
else
    mupadmex('alias(sqrtmone=I):');
    mupadmex('sqrtmone',8);
end
end

function S = numeric2cellstr(x,a)
%NUMERIC2CELLSTR  Convert numeric array to cell of strings.
%    converts a numeric array x into a cell string array of
%    the same size but with each element the string form of the corresponding
%    numeric element. The input 'a' determines the form of the conversion.
S = cell(size(x));
if strcmp(a,'d')
    digs = digits;
end
for k = 1:numel(x)
    if isinteger(x(k))
        S{k} = symInt2Str(x(k));
    else
        switch a
            case 'f'
                S{k} = symf(double(x(k)));
            case 'r'
                S{k} = symr(double(x(k)));
            case 'e'
                S{k} = syme(double(x(k)));
            case 'd'
                S{k} = symd(double(x(k)),digs);
            otherwise
                error(message('symbolic:sym:sym:errmsg6', a));
        end
    end
end
end

function S = cell2ref(x)
%CELL2REF  Convert cell array x into a MuPAD reference string S
% x can be a cell array of strings or sym objects
y = x;
if ~iscellstr(x)
    y = tocellstr(x);
end
S = mupadmex(y);
end

function y = tocellstr(x)
%TOCELLSTR   Convert sym objects in cell array x into reference string.
y = x;
for k=1:numel(x)
    if isa(x{k},'sym')
        y{k} = x{k}.s;
    end
end
end

function S = funchandle2ref(x)
%FUNCHANDLE2REF convert func handle x to string form
str = char(x);
ind1 = find(str == '(',1);
ind2 = find(str == ')',1);
inputs = str(ind1+1:ind2-1);
if ~isempty(inputs)
    S = regexp(inputs, ',', 'split');
    S = cellfun(@sym, S, 'UniformOutput', false);
    S = x(S{:});
else
    S = sym(x());
end
end

function S = symf(x)
%SYMF   Hexadecimal symbolic representation of floating point numbers.

if imag(x) > 0
    S = ['(' symf(real(x)) ')+(' symf(imag(x)) ')*' cplxunit];
elseif imag(x) < 0
    S = ['(' symf(real(x)) ')-(' symf(abs(imag(x))) ')*' cplxunit];
elseif isinf(x)
    if x > 0
        S = 'Inf';
    else
        S = '-Inf';
    end
elseif isnan(x)
    S = 'NaN';
elseif x == 0
    S = '0';
else
    S = symfl(x);
end
end

function [S,err] = symr(x)
%SYMR   Rational symbolic representation.
[S,err] = mupadmex(' ',x,3);
end

function S = syme(x)
%SYME   Symbolic representation with error estimate.

if imag(x) > 0
    S = ['(' syme(real(x)) ')+(' syme(imag(x)) ')*' cplxunit];
elseif imag(x) < 0
    S = ['(' syme(real(x)) ')-(' syme(abs(imag(x))) ')*' cplxunit];
elseif isinf(x)
    if x > 0
        S = 'Inf';
    else
        S = '-Inf';
    end
elseif isnan(x)
    S = 'NaN';
else
    [S,err] = symr(x);
    if err ~= 0
        err = eval(tofloat(['(' symfl(x) ')-(' S ')'],'32'))/eps;
    end
    if err ~= 0
        [n,d] = rat(err,1.e-5);
        if n == 0 || abs(n) > 100000
            [n,d] = rat(err/x,1.e-3);
            if n > 0
                S = [S '*(1+' int2str(n) '*eps/' int2str(d) ')'];
            else
                S = [S '*(1' int2str(n) '*eps/' int2str(d) ')'];
            end
            return
        end
        if n == 1
            S = [S '+eps'];
        elseif n == -1
            S = [S '-eps'];
        elseif n > 0
            S = [S '+' int2str(n) '*eps'];
        else
            S = [S int2str(n) '*eps'];
        end
        if d ~= 1
            S = [S '/' int2str(d)];
        end
    end
end
end

function S = symd(x,d)
%SYMD   Decimal symbolic representation.

if imag(x) > 0
    S = ['(' symd(real(x),d) ')+(' symd(imag(x),d) ')*' cplxunit];
elseif imag(x) < 0
    S = ['(' symd(real(x),d) ')-(' symd(abs(imag(x)),d) ')*' cplxunit];
elseif isinf(x)
    if x > 0
        S = 'Inf';
    else
        S = '-Inf';
    end
elseif isnan(x)
    S = 'NaN';
else
    S = tofloat(symfl(x),int2str(d));
end
end

function f = symfl(x)
%SYMFL  Exact representation of floating point number.
f = mupadmex(' ',double(x),4);
end

function s = convertCharWithOption(x,a)
%convertCharWithOption(X,A)
%   Convert the string X to the name or array of names that MuPAD will use.
%   X is the user-supplied name. A is the assumption or size of the matrix
%   of names to generate.
    if isnumeric(a)
        s = createCharMatrix(x,a);
    elseif isa(a,'char')
        s = convertChar(x);
        privAssumptions(s,x,a);
    else
        error(message('symbolic:sym:SecondInputClass'));
    end
end

function s = convertChar(x)
% convertChar(X) converts the string X, including MuPAD array output, to either
% a name that is a valid variable name in MuPAD or an expression.
% Also checks for MATLAB array syntax for backwards compatibility.
% Variable names are checked for overlap with MuPAD names and appends
% _Var to the name and returns a reference if the name is used by MuPAD.
x = strtrim(x);
if isvarname(x)
    s = convertName(x);
else
    s = convertExpression(x);
end
end

function s = createCharMatrix(x,a)
% Create a symbolic vector or matrix from the variable name x and size vector a.
    a = double(a);
    a(a<0) = 0;
    if any(~isfinite(a))
        error(message('symbolic:sym:InvalidSize'));
    end
    if any(fix(a)~=a)
        error(message('symbolic:sym:NonIntegerSize'));
    end
    if ~isvarname(strrep(x,'%d',''))
        error(message('symbolic:sym:SimpleVariable'));
    end
    if numel(a) == 1
        s = createCharMatrixChecked(x,[a a]);
    elseif numel(a) == 2
        s = createCharMatrixChecked(x,a);
    else
        error(message('symbolic:sym:MatrixArray'));
    end
end

function x = appendDefaultVectorFormat(x)
% Append the default vector format string if needed
    if ~any(x == '%')
        x = [x '%d'];
    end
end

function x = appendDefaultMatrixFormat(x,formats)
% Append the default matrix format string if needed
    if formats == 0
        x = [x '%d_%d'];
    elseif formats == 1
        error(message('symbolic:sym:FormatTooShort'));
    end
end

function s = createCharMatrixChecked(x,a)
% Create a symbolic matrix from x and size a with total elements n
    total = prod(a);
    a = a(:).';
    formats = length(find(x == '%'));
    if any(a==1) && formats < 2
        x = appendDefaultVectorFormat(x);
        s = cellfun(@(k)sprintf(x,k),num2cell(1:total),'UniformOutput',false);
    else
        x = appendDefaultMatrixFormat(x,formats);
        s = cellfun(@(k)createCharMatrixElement(x,a,k),num2cell(1:total),'UniformOutput',false);
    end
    s = reshape(s,a);
    s = mupadmex(s);
end

function s = createCharMatrixElement(x,a,k)
    [m,n] = ind2sub(a,k);
    s = sprintf(x,m,n);
end

function s = convertName(x)
%VARNAME2REF converts a variable name x into a MuPAD name s.
% The MuPAD name may have _Var appended to distinguish it from
% a predefined MuPAD symbol (like beta or D).
s = x;
if ~strcmp(x,'pi') && (length(x)>1 || any(x=='DIOE'))
    % ask MuPAD to check if the name is defined and if so append _Var
    s = mupadmex('symobj::fixupVar',x,0);
end
% Remove aliases for complex unit if 'i'
if isequal(x,'i')
    mupadmex('unalias(i,sqrtmone):');
end
end

function s = convertExpression(x)
%EXPRESSION2REF converts the string expression x into a string ref s.
% The output x is the modified string expression in MuPAD syntax.
if isempty(x)
    x = 'matrix(0,0)';
end
if x(1) == '['
    x = convertMATLABsyntax(x);
end
[s,err] = mupadmex({x});
if err
    error(message('symbolic:sym:sym:errmsg9',s))
end
end

function x = convertMATLABsyntax(x)
%convertMATLABsyntax rewrites a MATLAB-style array into a MuPAD array.
x = convertSpaces(x);
% String contains square brackets, so it is not a scalar.
if x(1) == '['
    x = convertBrackets(x);
end
x = ['matrix([' x '])'];
end

function x = convertSpaces(x)
%convertSpaces makes the space-separated array syntax into MuPAD syntax
% If the string is of the form, M = '[x - 1 x + 2;x * 3 x / 4]'
% then find all of the alpha-numeric chararacters (id), the
% arithmetic operators (+ - / * ^) (op), and spaces (sp) and
% combine them into a vector V = 3*sp + 2*op + id.  That is,
% id = isalphanum(M); op = isop(M); sp = find(M == ' ').  Let
% spaces receive the value 3, operators 2, and alpha-numeric
% characters 1.  Whenever the sequence 1 3 1 occurs, replace it
% with 1 4 1.  Insert a comma whenever the number 4 occurs.
% First remove all multiple blanks to create at most one blank.
sp = (x == ' ');  % Location of all the spaces.
b = findrun(sp); % Beginning (b) indices.
sp(b) = 0;  % Mark the beginning of multiple blanks.
x(sp) = []; % Set multiple blanks to empty string.
V = isalphanum(x) + 2*isop(x) + 3*(x == ' ');
if length(V) >= 3
    d = V(2:end-1)==3 & V(1:end-2)==1 & V(3:end)==1;
    V(find(d)+1) = 4;
end
x(V == 4) = ',';
end

function x = convertBrackets(x)
%convertBrackets makes MATLAB brackets look like MuPAD array.
% Make '[a11 a12 ...; a21 a22 ...; ... ]' look like MuPAD array.
% Version 1 compatibility.  Possibly useful elsewhere.
% Replace multiple blanks with single blanks.
k = strfind(x,'  ');
while ~isempty(k);
    x(k) = [];
    k = strfind(x,'  ');
end
% Replace blanks surrounded by letters, digits or parens with commas.
for k = strfind(x,' ');
    if (isalphanum(x(k-1)) || x(k-1) == ')') && ...
            (isalphanum(x(k+1)) || x(k+1) == '(')
        x(k) = ',';
    end
end
% Replace semicolons with '],['.
for k = fliplr(strfind(x,';'))
    x = [x(1:k-1) '],[' x(k+1:end)];
end
end

function b = findrun(x)
%FINDRUN Finds the runs of like elements in a vector.
%   FINDRUN(V) returns the beginning (b)
%   indices of the runs of like elements in the vector V.

d = diff([0 x 0]);
b = find(d == 1);
end

function B = isalphanum(S)
%ISALPHANUM is True for alpha-numeric characters.
%   ISALPHANUM(S) returns 1 for alpha-numeric characters or
%   underscores and 0 otherwise.
%
%   Example:  S = 'x*exp(x - y) + cosh(x*s^2)'
%             isalphanum(S)   returns
%            (1,0,1,1,1,0,1,0,0,0,1,0,0,0,0,1,1,1,1,0,1,0,1,0,1,0)

B = isletter(S) | (S >= '0' & S <= '9') | (S == '_');
end

function B = isop(S)
%ISOP is True for + - * / or ^.
%   ISOP(S) returns 1 for plus, minus, times, divide, or
%   exponentiation operators and 0 otherwise.

B = (S == '+') | (S == '-') | (S == '*') | ...
    (S == '/') | (S == '^');
end

function s = cplxunit
%CPLXUNIT  Return the current name for sqrt(-1)
s = mupadmex('I',0);
if isequal(s,'sqrtmone')
    s = 'sqrt(-1)';
end
end

function y = tofloat(x,d)
%TOFLOAT   Convert expression to vpa
%    Y = TOFLOAT(X,D) converts expression in string X to vpa with digits D.
y = mupadmex('symobj::float', x, d, 0);
end

function [s,refs] = privformat(x)
%PRIVFORMAT   Format array into MuPAD indexing string
%   [S,REFS] = PRIVFORMAT(X) turns X into a string S tailored for calling
%   MuPAD's indexing code. REFS is the array of any sym objects needed
%   to hold references needed by S (to prevent early garbage collection).
refs = [];
if isa(x,'sym')
    x = subsindex(x)+1;
end
if isscalar(x)
    s = privformatscalar(x);
elseif ismatrix(x)
    s = privformatmatrix(x);
else
    [s,refs] = privformatarray(x);
end
end

function s = privformatscalar(x)
%PRIVFORMATSCALAR  Format scalar object for indexing
if ischar(x) && strcmp(x,':')
    s = '#COLON';
elseif islogical(x)
    s = logical2str(x);
else
    x = double(x);
    checkindex(x);
    s = int2str(x);
end
end

function s  = privformatmatrix(x)
%PRIVFORMATMATRIX  Format matrix object for indexing
d = size(x);
s = sprintf('matrix(%d,%d,[',d(1),d(2));
if isnumeric(x) || ischar(x)
    x = double(x);
    checkindex(x);
    s = [s sprintf('%d,',x.')];
elseif islogical(x)
    x2 = num2cell(x);
    x2 = cellfun(@logical2str,x2,'UniformOutput',false);
    x2 = x2.';
    x2 = x2(:).';
    x2(2,:) = {','};
    s = [s x2{:}];
else
    error(message('symbolic:sym:subscript:InvalidIndex'));
end
if s(end)==','
    s = s(1:end-1);
end
s = [s '])'];
end

function [s,refs]  = privformatarray(x)
%PRIVFORMATARRAY  Format n-d array object for indexing
if isnumeric(x) || ischar(x)
    x = double(x);
    checkindex(x);
    x2 = num2cell(x);
    refs = sym(cellfun(@num2str,x2,'UniformOutput',false));
    s = charcmd(refs);
elseif islogical(x)
    x2 = num2cell(x);
    refs = sym(cellfun(@logical2str,x2,'UniformOutput',false));
    s = charcmd(refs);
else
    error(message('symbolic:sym:subscript:InvalidIndex'));
end
end

function checkindex(x)
%CHECKINDEX   Error check for valid indexing expression
%   CHECKINDEX(X) errors if X is not a valid indexing expression
fin = isfinite(x);
flint = fix(x)==x;
pos = x>0;
if ~all(fin(:)) || ~all(flint(:)) || ~isreal(x) || ~all(pos(:))
    error(message('symbolic:sym:badsubscript'));
end
end

function y=logical2str(x)
%LOGICAL2STR  Convert logical value to MuPAD string equivalent
if x
    y = 'TRUE';
else
    y = 'FALSE';
end
end

function checkNoSyms(args)
    if any(cellfun(@(arg)isa(arg,'sym'),args))
        error(message('symbolic:ezhelper:TooManySyms'));
    end
end

function mset = setToMuPADSet(set)
%setToMuPADSet Convert a string name for a set to a MuPAD identifier
switch(set)
    case 'integer'
        mset = 'Z_';
    case 'rational'
        mset = 'Q_';
    case 'real'
        mset = 'R_';
    otherwise
        error(message('symbolic:sym:AssumptionMustBeRealRationalInteger'))
end
end

