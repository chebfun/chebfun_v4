function varargout = chebfunpref(varargin)
% CHEBFUNPREF Settings for chebfuns.
%
% By itself, CHEBFUNPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBFUNPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBFUNPREF('FACTORY') restore all preferences to their factory defined 
% values.
%
% CHEBFUNPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL. If PREFVAL is 'FACTORY', PREFNAME is set to its factory defined
% value.
%
% CHEBFUNPREF creates a persistent variable that stores the these preferences. 
% CLEAR ALL will not clear preferences, but quiting Matlab will.
%
% CHEBFUN PREFERENCES 
%
% MinN - Minimum number of points used by the constructor. The contructed
%        fun or chebfun might be shorter as a result of the simplify
%        command. MUST BE 2^n+1 to conform with fun/growfun.
%        Factory value is 9.
%
% MaxN - Maximum number of points used by the constructor in SPLITTING 
%        OFF mode. Factory value is 2^16+1.
%
% Nsplit - Maximum number of points used by the constructor in SPLITTING ON
%        mode. Note: 2^n+1 conforms with the way fun/growfun works. 
%        Factory value is 129.
%
% Splitting - Spliting option. Must be either true (1) or false (0).
%        Factory value is true.
%
% Resample -  Resample option. Must be either true (1) or false (0).
%        Factory value is true.
%
% Domain - Domain of definition of a chebfun. Factory definition is [-1 1].
%
% Examples
%       chebfunpref
%       chebfunpref('MinN', 17)
%       chebfunpref('MinN','factory')
%       chebfunpref('factory')
%
% See also SPLITTING, RESAMPLE
%

% persistent variables are known only to the function in which they are declared.
persistent prefs
mlock %locks the currently running M-file so that clear functions do not remove it.
% Use munlock and clear chebfunpref if you edit this file.

% These are the options
options =    {'minn', 'maxn', 'nsplit', 'splitting', 'resample', 'domain', 'factory'};
factoryvals = {9,     2^16+1,   129,     true,        true,      [-1 1]};

% convert input to lower case and check for errors.
if nargin>=1
    varargin{1} = lower(varargin{1}); 
    [truepref, indpref] = ismember(varargin{1},options);
    if ~truepref
        error('CHEBFUN:chebfunpref:UnkonwnPref','unknown chebfun preference')
    end
end

% Restore defaults ?
factory_flag = false;
if nargin >= 1 && strcmp(varargin{1},'factory')
    prefs = [];
    factory_flag = true;
    if nargin >1
        warning('CHEBFUN:chebfunpref:argin','second argument ignored')
    end
end
  
% first call, set factory values
if isempty(prefs) 
    for k = 1:length(factoryvals)
         prefs.(options{k}) = factoryvals{k};
    end
end

% Probably should use some nicer error catching...
if nargin==0 || factory_flag
    varargout = { prefs };
elseif nargin==1 && not(factory_flag)
    varargout = { prefs.(varargin{1}) };
elseif nargin==2

    % Set preference to its factory value.
    if strncmpi(varargin{2},'factory',3)
        prefs.(options{indpref}) = factoryvals{indpref};

    else
        if ischar(varargin{2})
            error('CHEBFUN:chebfunpref:argin','invalid second argument')
        end

        % If preference is 'minn', check for consistency!
        if strcmp(varargin{1},'minn')
            minn = varargin{2};
            varargin{2} = max(2,2^floor(log2(minn-1))+1);
        end

        % Set preference!
        prefs.(varargin{1}) = varargin{2};

    end
        
else
    error('CHEBFUN:chebfunpref:argin','Check number of input arguments.')
end
