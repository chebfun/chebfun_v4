function varargout = chebfunpref(varargin)
% CHEBFUNPREF Settings for chebfuns.
%
% By itself, CHEBFUNPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBFUNPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBFUNPREF('factory') restore all preferences to their factory defined
% values.
%
% CHEBFUNPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL. If PREFVAL is 'factory', PREFNAME is set to its factory defined
% value. S = CHEBFUNPREF(PREFNAME,PREFVAL) will store the current state of
% chebfunpref to S before changing PREFNAME.
%
% S = CHEBFUNPREF will return the current preferences in a structure, which 
% may then be used in the form CHEBFUNPREF(P) to reload them or be passed 
% to the chebfun constructor.
%
% S = CHEBFUNPREF('factory') returns a structure S with the factory values
% without restoring them. V = CHEBFUNPREF(PREFNAME,'factory') returns the 
% factory value V for preference PREFNAME without changing it. 
%
% CHEBFUNPREF creates a persistent variable that stores these preferences.
% CLEAR ALL will not clear preferences, but MUNLOCK CHEBFUNPREF followed by
% CLEAR CHEBFUNPREF will (quitting Matlab also clears this variable).
%
% CHEBFUN PREFERENCES (case sensitive)
%
% splitting - Splitting option, true (1) or false (0).
%        If true, breakpoints between funs may be introduced where a
%        discontinuity in a function or a low-order derivative is detected,
%        or if a global polynomial representation will be too long.
%        If false, breakpoints will be introduced only at points where 
%        discontinuities are being created, e.g. by ABS(F) at points where
%        a chebfun F passes through zero.  Factory value is false.
%
% minsamples - Minimum number of points used by the constructor. The 
%        constructed fun or chebfun might be shorter as a result of the 
%        simplify command. Must be of the form 2^n+1.  Factory value is 9.
%
% maxdegree - Maximum degree used by the constructor in SPLITTING OFF mode.
%        Factory value is 2^16.
%
% maxlength - Maximum number of points used by the constructor in SPLITTING
%        ON mode.  Factory value is 6000.
%
% splitdegree - Maximum degree per fun used by the constructor in SPLITTING
%        ON mode.  Values should normally be of the form 2^n.
%        Factory value is 128.
%
% resampling -  Resample option, true (1) or false (0).
%        If true, every function value is computed afresh as the constructor
%        tries grids of size 9, 17, 33, etc.  If false, old values are
%        reused.  (This sounds like an obvious speedup for most applications
%        but in fact often does not result in an improvement.)
%        Factory value is false.
%
% domain - Default interval of definition of a chebfun. 
%        Factory definition is [-1 1].
%
% eps -  Relative tolerance used in construction and subsequent operations.
%        Factory value is 2^-52 (Matlab's factory value of machine epsilon).
%
% sampletest - Safety test option, true (1) or false (0).
%        If true, the constructor tests the function at one more arbitrary
%        point to minimize the risk of missing signals between grid points.
%        Factory value is true.
%
% blowup - Blowup option:
%        BLOWUP=0: bounded functions only
%        BLOWUP=1: poles are permitted (integer order)
%        BLOWUP=2: blowup of integer or non-integer orders permitted (experimental)
%        Factory value 0.
%
% chebkind - Interpolation points for the construction of chebfuns:
%        CHEBKIND = 1: Chebyshev points of the first kind (experimental)
%        CHEBKIND = 2: Chebyshev points of the secnod kind (recommended)
%        Factory value is 2. 
%
% extrapolate - Extrapolation at endpoints, true (1) or false (0). 
%        If true, function values at endpoints maybe extrapolated from
%        interior values rather than sampled. Extrapolation is used
%        independently of this option if a function evaluation returns NaN.
%        In some cases, however, functions values at end points maybe
%        inaccurate or undefined, and enabling extrapolation maybe helpful.
%        Factory value is 0.
%
% plot_numpts - Number of points used to plot a chebfun. 
%        Factory value is 2001.
%
% Examples
%        chebfunpref
%        chebfunpref('minsamples', 17)
%        chebfunpref('minsamples','factory')
%        chebfunpref('factory')
%
% See also SPLITTING, RESAMPLING, BLOWUP
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 


% persistent variables are known only to the function in which they are
% declared.
persistent prefs

% To speedup preference checks, try this first. 
% -----------------------------------------------
if nargin == 1
    try
        varargout{1} = prefs.(varargin{1});
        return
    catch
        % Move on to longer process.
    end  
    
% Return preference structure if no input is provided.    
elseif nargin == 0 && ~isempty(prefs)
     varargout = { prefs };
end        
% -----------------------------------------------


% If the above didn't work, go through the longer process:

% These are the options
options =    {'splitting', 'minsamples', 'maxdegree', 'maxlength', 'splitdegree', 'resampling', 'domain', 'eps', 'sampletest', 'blowup', 'chebkind', 'extrapolate','plot_numpts','polishroots','addepth'};
factoryvals = {false,       9,            2^16,         6000,        128,           false,        [-1 1],  2^-52,    true,     false,     2,          false,         2001,         true,          25};
% Note: The proper number of points for Chebyshev points of the first kind
% is 2^k (not 2^k+1 as for the second kind).

% Restore defaults ?
factory_flag = false;
if nargin == 1 
    if isstruct(varargin{1})
        % Assign prefs from structure input
        prefs = varargin{1};
        return
    elseif strncmpi(varargin{1},'factory',3)
        if nargout == 0
            % Restore defaults
            prefs = [];
            factory_flag = true;
        else
            % Return factory values without changing chebfunpref
            for k = 1:length(factoryvals)
                varargout.(options{k}) = factoryvals{k};
            end
            varargout = {varargout};
            return
        end
    end        
elseif nargin==2
    % Error catching ...
    [truepref, indpref] = ismember(varargin{1},options);
    if ~truepref
        error('CHEBFUN:chebfunpref:argin', ...
        ['Unknown chebfun preference "',varargin{1},'".'])
    end
elseif nargin > 2
    if nargout == 1
        varargout = {chebfunpref};
    end
    while ~isempty(varargin)  
        if numel(varargin) == 1
            error('CHEBFUN:chebfunpref:argin2','Incorrect number of input arguments.');
        end
        chebfunpref(varargin{1:2});
        varargin(1:2) = [];
    end
    return
end

% first call, set factory values
if isempty(prefs)
    
    for k = 1:length(factoryvals)
        prefs.(options{k}) = factoryvals{k};
    end
    
    if nargout == 1
        varargout = {prefs};
    end
    
    mlock %locks the currently running M-file so that clear functions do not remove it.
          % Use munlock and clear chebfunpref if you edit this file.
elseif nargout == 1
    varargout = {prefs};
end

% Assign output values
if nargin==0 || factory_flag
    varargout = { prefs };
elseif nargin==1 && not(factory_flag)
    varargout = { prefs.(varargin{1}) };
elseif nargin==2
    
    
    if ischar(varargin{2})
        
        if strncmpi(varargin{2},'factory',3)
            val = factoryvals{indpref};
            if nargout == 0
                % Set preference to its factory value.
                prefs.(options{indpref}) = val;
            else
                % Return factory value without changing chebfunpref variable
                varargout = {val};
            end
            return
            
        elseif strcmpi(varargin{2},'on')
            varargin{2} = true;
        elseif strcmpi(varargin{2},'off')
            varargin{2} = false;
        else
            %  if ischar(varargin{2})
            error('CHEBFUN:chebfunpref:argin','Invalid second argument.')
        end
        
    end
    
    %         % If preference is 'minn', check for consistency!
    %         if strcmp(varargin{1},'minn')
    %             minn = varargin{2};
    %             varargin{2} = max(2,2^floor(log2(minn-1))+1);
    %         end
    % If preference is 'eps', check for consistency!
    if strcmp(varargin{1},'eps') && varargin{2}<2^-52
        varargin{2} = 2^-52;
        warning('CHEBFUN:chebfunpref:argin','eps value below machine precision. eps set to 2^-52.');
    end
    % Set preference!
    prefs.(varargin{1}) = varargin{2};
    
    % To avoid error messages
%     if nargout > 0
%         varargout = {};
%     end
    
    if ~prefs.resampling && prefs.chebkind == 1
        warning('CHEBFUN:resampling_kind','RESAMPLING has been turned ON. Chebyshev points of 1st kind are being used.')
        prefs.resampling = true;
    end
    
    
else
    error('CHEBFUN:chebfunpref:argin','Check number of input arguments.')
end