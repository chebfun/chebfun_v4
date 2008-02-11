function varargout = chebfunpref(varargin)
% CHEBFUNPREF Settings for chebfuns.
%
% By itself, CHEBFUNPREF returns a structure with current preferences as
% fields/values. Use it to find out what preferences are available.
%
% CHEBFUNPREF(PREFNAME) returns the value corresponding to the preference
% named in the string PREFNAME.
%
% CHEBFUNPREF(PREFNAME,PREFVAL) sets the preference PREFNAME to the value
% PREFVAL.
%
% See also SPLITTING.

% Toby Driscoll, 11 February 2008.

persistent prefs

if isempty(prefs)  % first call, default values
  prefs.maxn = 128;
  prefs.splitting = true;
  prefs.degree_mode = 1;
end

% Probably should use some nicer error catching...
if nargin==0
  varargout = { prefs };
elseif nargin==1
  varargout = { prefs.(varargin{1}) };
else
  prefs.(varargin{1}) = varargin{2};
end
