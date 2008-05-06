function varargout = chebfunpref(varargin)
% CHEBFUNPREF Settings for chebfuns.
%
% By itself, CHEBFUNPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBFUNPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBFUNPREF('DEFAULTS') restore all preferences to their dafault values.
%
% CHEBFUNPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL.
%
% CHEBFUN PREFERENCES
%
% MinN - Minimum number of points used by the constructor. The contructed
%        fun or chebfun might be shorter as a result of the simplify
%        command. MUST BE 2^n+1 to conform with fun/growfun. Default is 9.
%
% MaxN - Maximum number of points used by the constructor in SPLITTING 
%        OFF mode. Default is 2^16+1.
%
% Nsplit - Maximum number of points used by the constructor in SPLITTING ON
%        mode. Note: 2^n+1 conforms with the way fun/growfun works. Default
%        is 129.
%
% Splitting - Spliting option. Must be either true (1) or false (0).
%        Default is true.
%
% Resample -  Resample option. Must be either true (1) or false (0).
%        Default is true.
%
% Domain - Domain of definition of a chebfun. Default is [-1 1].
%
% See also SPLITTING, RESAMPLE.
%

persistent prefs

% These are the options
options = {'minn', 'maxn', 'nsplit', 'splitting', 'resample', 'domain', 'defaults'};

% convert input to lower case and check for errors.
if nargin>=1
    varargin{1} = lower(varargin{1});
    if ~(ismember(varargin{1},options))
        error('CHEBFUN:chebfunpref:UnkonwnPref','unknown chebfun preference')
    end
end

% Restore defaults ?
default_flag = false;
if nargin >= 1 && strcmp(varargin{1},'defaults')
    prefs = [];
    default_flag = true;
    if nargin >1
        warning('CHEBFUN:chebfunpref:argin','second argument ignored')
    end
end
    
if isempty(prefs) % first call, default values
    prefs.minn = 9;         % 2^n+1 to conform with fun/growfun
    prefs.nsplit = 129;     % 2^n+1 conforms with the way fun/growfun works.    
    prefs.maxn = 2^16+1;    % 2^n+1 conforms with the way fun/growfun works.    
    prefs.splitting = true; % true or false
    prefs.resample = true;  % true or false
    prefs.domain = [-1 1];  % interval    
end

% Probably should use some nicer error catching...
if nargin==0 || default_flag
    varargout = { prefs };
elseif nargin==1 && not(default_flag)
    varargout = { prefs.(varargin{1}) };
elseif nargin==2

    % If preference is 'minn', check for consistency!
    if strcmp(varargin{1},'minn')
        minn = varargin{2};
        varargin{2} = max(2,2^floor(log2(minn-1))+1);      
    end
    
    % Set preference!
    prefs.(varargin{1}) = varargin{2};
    
else
    error('CHEBFUN:chebfunpref:argin','Check number of input arguments.')
end