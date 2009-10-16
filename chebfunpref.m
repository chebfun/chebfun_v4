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
% value.
%
% S = CHEBFUNPREF will return the current preferences in a structure, which 
% may then be used in the form CHEBFUNPREF(P) to reload them or be passed 
% to the chebfun constructor.
%
% S = CHEBFUNPREF('factory') returns a structure S with the factory values
% without restoring them. V = CHEBFUNPREF(PREFNAME,'factory') returns the 
% factory value V for preference PREFNAME without changing it. 
%
% CHEBFUNPREF creates a persistent variable that stores the these preferences.
% CLEAR ALL will not clear preferences, but MUNLOCK CHEBFUNPREF will (as will
% quitting Matlab).
%
% CHEBFUN PREFERENCES (case sensitive)
%
% splitting - Spliting option. Must be either true (1) or false (0).
%        Factory value is false.
%
% minsamples - Minimum number of points used by the constructor. The 
%        contructed fun or chebfun might be shorter as a result of the 
%        simplify command. MUST BE 2^n+1 to conform with fun/growfun.
%        Factory value is 9.
%
% maxdegree - Maximum degree used by the constructor in SPLITTING OFF mode.
%        Factory value is 2^16.
%
% maxlength - Maximum number of points used by the constructor in SPLITTING
%        ON mode. Factory value is 6000.
%
% splitdegree - Maximum degree per fun used by the constructor in SPLITTING
%        ON mode. Note: 2^n conforms with the way fun/growfun
%        works. Factory value is 128.
%
% resampling -  Resample option. Must be either true (1) or false (0).
%        Factory value is true.
%
% domain - Domain of definition of a chebfun. Factory definition is [-1 1].
%
% eps - Relative tolerance. Factory value is 2^-52 (eps).
%
% sampletest - Extra test in the construction of chebfuns to avoid
%   aliasing. Factory value is true.
%
% blowup - Allow and check for functions which blow up on the domain.
%
% Examples
%       chebfunpref
%       chebfunpref('minn', 17)
%       chebfunpref('minn','factory')
%       chebfunpref('factory')
%
% See also SPLITTING, RESAMPLING
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

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
        % Move on to longer precess.
    end  
    
% Return preference structure if no input is provided.    
elseif nargin == 0 && ~isempty(prefs)
     varargout = { prefs };
end        
% -----------------------------------------------


% If the above didn't work, go through the longer process:

% These are the options
options =    {'splitting', 'minsamples', 'maxdegree', 'maxlength', 'splitdegree', 'resampling', 'domain', 'eps', 'sampletest', 'blowup'};
factoryvals = {false,       9,            2^16,      6000,      128,          true,         [-1 1],   2^-52,        true, true};

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
elseif nargin>=1
    % Error catching ...
    [truepref, indpref] = ismember(varargin{1},options);
    if ~truepref
        error('CHEBFUN:chebfunpref:argin','unknown chebfun preference')
    end
end

% first call, set factory values
if isempty(prefs)
    
    for k = 1:length(factoryvals)
        prefs.(options{k}) = factoryvals{k};
    end
    
    mlock %locks the currently running M-file so that clear functions do not remove it.
          % Use munlock and clear chebfunpref if you edit this file.
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
            error('CHEBFUN:chebfunpref:argin','invalid second argument')
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
        warning('CHEBFUN:chebfunpref:argin','eps value below machine precision. eps set to 2^-52');
    end
    % Set preference!
    prefs.(varargin{1}) = varargin{2};
    
    % To avoid error messages
    if nargout > 0
        varargout = {};
    end
    
    
    
else
    error('CHEBFUN:chebfunpref:argin','Check number of input arguments.')
end

