classdef mupadengine < handle
    %MUPADENGINE MuPAD symbolic engine
    %   The MUPADENGINE class is the interface to the MuPAD symbolic engine
    %   used by the SYM class. Use the SYMENGINE function to obtain the active
    %   engine.
    %
    %   Example:
    %      eng = symengine;
    % 
    %   See also: symengine, mupadengine/feval, mupadengine/evalin, mupadengine/doc
    
    %   Copyright 2008-2011 The MathWorks, Inc.
    
    properties
        kind = 'mupad';
    end
    
    properties (GetAccess='private',SetAccess='private',Transient=true)
        cleanup = false;
    end
    
    
    methods(Hidden=true)
        function addlistener(obj)
            notUsed(obj,'addlistener');
        end
        function gt(obj)
            notUsed(obj,'gt');
        end
        function ge(obj)
            notUsed(obj,'ge');
        end
        function le(obj)
            notUsed(obj,'le');
        end
        function lt(obj)
            notUsed(obj,'lt');
        end
        function findobj(obj)
            notUsed(obj,'findobj');
        end
        function findprop(obj)
            notUsed(obj,'findprop');
        end
        function notify(obj)
            notUsed(obj,'notify');
        end
        function notUsed(~,op) 
            error(message('symbolic:mupadengine:UnsupportedOperation', op));
        end
    end
    
    methods
        
        function engine = mupadengine(cleanup)
            %MUPADENGINE Constructor
            %   The MUPADENGINE constructor should not be called by users.
            %   Call SYMENGINE to obtain the active engine.
            
            %   MUPADENGINE(CLEANUP) sets the cleanup state to true/false.
            if nargin ~= 1
                error(message('symbolic:mupadengine:DirectCall'));
            end
            mlock;
            engine.cleanup = cleanup;
        end
        
        function delete(engine)
        if engine.cleanup && inmem('-isloaded','mupadmex')
            mupadmex(' ',6); % destroy the kernel process
        end
        end
        
        function [result,status] = evalin(~,statement,outtype) %#ok<INUSD>
            %EVALIN Evaluate a MuPAD expression
            %   RESULT = EVALIN(ENGINE,EXPR) evaluates EXPR in the MuPAD
            %   engine ENGINE and returns the RESULT as a sym object. If
            %   the statement did not return a value the MuPAD null() value
            %   of type DOM_NULL is returned. MuPAD sequences are wrapped 
            %   into lists. 
            %
            %   [RESULT,STATUS] = EVALIN(...) returns the error status
            %   in status and error message in RESULT if status is non-zero.
            %   If status is zero RESULT is a sym object and otherwise RESULT
            %   is a string.
            %
            %   Example:
            %   y = evalin(symengine,'k^2$k=1..5')
            %
            %   See also: symengine, mupadengine/feval
            
            %   EVALIN(...,'char') returns a char result instead of a sym object.

            if nargin == 3
                [res,status] = mupadmex(statement,0);
            else
                [res,status] = mupadmex(statement);
            end
            % Handle any error messages
            if status ~= 0 && nargout < 2
                error(message('symbolic:mupadengine:evalin:errmsg2',res));
            end
            % Handle statements 
            if isa(res,'sym')
                [y,flag] = isNullObjOrSeq(res);
            else
                y = false;
                flag = ' ';
            end
            
            if strcmp(flag, 'sequence') 
                res = makeListOutOfMuPADSequences(res);                
                result = res;
            elseif nargout > 0 || ~isa(res,'sym') || ~y 
                % replace a null() output with empty object
                if isa(res,'sym') && y == true 
                    if strcmp(flag,'null()')
                        res = sym([]);
                    end
                end
                result = res; 
            end
        end
        
        function [S,err] = feval(engine,fcn,varargin)
            %FEVAL Evaluate a MuPAD function
            %   RESULT = FEVAL(ENGINE,FCN,x1,...,xn) evaluates the MuPAD function
            %   specified by FCN, which must be a function name or sym object, 
            %   at the given arguments x1,...,xn in the MuPAD engine ENGINE.
            %   The result is a sym object. Those x values that are not strings
            %   or sym objects are converted to sym objects.
            %
            %   [RESULT,STATUS] = FEVAL(ENGINE,FCN,...) returns the error status
            %   in STATUS and error message in RESULT if the status is non-zero.
            %   If the status is zero, RESULT is a sym object and otherwise RESULT
            %   is a string.
            %
            %   Example:
            %   syms x
            %   f = tan(x);
            %   g = feval(symengine,'rewrite',f,'sincos')
            %
            %   See also: symengine, mupadengine/evalin
            
            narginchk(2,inf);
            if ~isa(fcn,'sym') && ~isfuncname(fcn)
                error(message('symbolic:mupadengine:feval:InvalidFunction', fcn));
            end
            [stmt,fcn2,args2] = feval2eval(fcn,varargin); %#ok extra args are for holding sym references
            [S,err] = evalin(engine,stmt);
            if nargout < 2 && err ~= 0
                if strfind(S,'Error: Singularity')
                    S = sym(NaN);
                elseif strncmp(S,'Error: symbolic:',16) && ~isempty(strfind(S,'# '))
                    symengine('error',S(8:find(S=='[',1)-2));
                else
                    error(message('symbolic:mupadengine:feval:FevalError',S));
                end
            end
        end
        
        function trace(~,onoff) 
            %TRACE Turn on MuPAD command tracing
            %    TRACE(ENGINE,'on') causes subsequent MuPAD commands and results to be printed.
            %    TRACE(ENGINE,'off') turns off this facility.
            %
            %    See also: symengine
            
            narginchk(2,2);
            if ~any(strcmp(onoff,{'on','off'}))
                error(message('symbolic:mupadengine:trace:OnOff'));
            end
            mupadmex(onoff,5);
        end
        
        function doc(~,topic) 
            %DOC Open MuPAD documentation
            %   DOC(ENGINE) opens the MuPAD Help browser.
            %   DOC(ENGINE,CMD) opens to the specified MuPAD command.
            %
            %   Example:
            %   doc(symengine,'int')
            %
            %   See also: symengine
            
            if nargin == 1
                helpview(fullfile(docroot,'symbolic','helptargets.map'),'getting-started-with-mupad');
            else
                doc(['mupad/' topic]);
            end
        end
        
        function reset(engine) %#ok<MANU>
            %RESET Reset MuPAD engine
            %   RESET(ENGINE) restarts the MuPAD symbolic engine. All sym
            %   objects should be cleared and recomputed.
            %
            %   Example:
            %   reset(symengine)
            %
            %   See also: symengine
            
            if ispc
                clear mupadmex
            else
                mupadmex(' ',6);
            end
        end
        
        function read(engine,file)
            %READ Read MuPAD program file
            %    READ(ENGINE,FILE) reads the MuPAD program file FILE
            %    into the symbolic engine. FILE can include full or
            %    relative path information. If FILE does not have
            %    a path component and no extension and the name
            %    [FILE '.mu'] exists on the MATLAB path then the
            %    file returned by WHICH is read. 
            %    
            %    MuPAD aliases defined in the file are ignored. To
            %    read a file that contains aliases or uses the aliases
            %    predefined by MATLAB call the FEVAL method on the
            %    MUPADENGINE class to call the MuPAD read function.
            %    
            %    Example:
            %    read(symengine,'my_mupad_functions');
            %
            %    See also: SYMENGINE, PATH, WHICH, OPEN, MUPADENGINE/RESET, MUPADENGINE/FEVAL
            [path,f,ext] = fileparts(file);
            if isempty(path) && isempty(ext)
                file = [file '.mu'];
                file2 = which(file);
                if isempty(file2)
                    error(message('symbolic:mupadengine:read:FileNotFound',file));
                else
                    file = file2;
                end
            else
                if isempty(ext)
                    ext = '.mu';
                end
                if ~isfullpath(path)
                    path = fullfile(pwd,path);
                end
                file = fullfile(path,[f ext]);
            end
            evalin(engine,['read("' escape(file) '",Plain)']);
        end

        function disp(engine) %#ok<MANU>
            disp('MuPAD symbolic engine');
        end
        
        function collectGarbage(engine) %#ok<MANU>
            %collectGarbage Release unused memory in MuPAD
            %   collectGarbage(ENGINE) informs the MuPAD engine of results
            %   that are no longer needed by MATLAB. MuPAD may then reduce
            %   the amount of memory used by the process.
            %
            %   See also: symengine
            
            mupadmex(' ',2);
        end
    end
end

% replace \ with \\ while leaving \\ alone
function cmd = escape(cmd)
    cmd = strrep(cmd,'\','\\');
end

function y = isfullpath(path)
% Return true if path is a fully qualified path
if ispc
    y = length(path)>1 && (path(2)==':' ||...
        strcmp(path(1:2),'\\') || ...
        strcmp(path(1:2),'//'));
else
    y = ~isempty(path) && path(1)=='/';
end
end

function ok = isfuncname(fcn)
% Return true if fcn is id or pkg::id
ok = false;
if ischar(fcn)
    fcn(fcn==':') = [];
    fcn(fcn=='_') = [];
    ok = isvarname(fcn);
end
end

function [statement,fcn2,args2] = feval2eval(fcn,args)
%FEVAL2EVAL Transform feval call into eval for mupadengine class
%   STMT = FEVAL2EVAL(FCN,ARGS) constructs the string FCN(ARGS{:}) to
%   evaluate in the symbolic engine.
fcn2 = fcn;   % to hold references
args2 = args; % to hold references
if ~ischar(fcn)
    if ~isa(fcn,'sym')
        fcn2 = sym(fcn);
    end
    statement = ['(' charcmd(fcn2) ')'];
else
    statement = fcn;
end
statement(end+1) = '(';
for k2 = 1:length(args)
    v = args{k2};
    if ~ischar(v)
        if ~isa(v,'sym')
            v = sym(v);
            args2{k2} = v;
        end
        v = charcmd(v);
    end
    statement = [statement v ','];  %#ok<AGROW>
end
if statement(end)==','
    statement(end) = ')';
else
    statement(end+1) = ')';
end
end

function path = mupadroot %#ok<DEFNU>
% mupadroot is one level up and over from mupadmex 
    mupmex = which('mupadmex');
    path = fileparts(mupmex);
    path = fullfile(path,'..','mupad');
end

