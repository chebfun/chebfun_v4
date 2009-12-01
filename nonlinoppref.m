function varargout = nonlinoppref(varargin)
% NONLINOPPREF settings for nonlinear backslash
%
% More details and more options to follow.
%
% Options to be added include: Update tolerance, Residual tolerance,
% (absolute or relative tolerance). Fixed stepsize. Automatic finding of
% stepsize. Different search direction. Simplified Newton (i.e. same
% Jacobian used for many iterations).
%
% Asgeir Birkisson, 2009

persistent prefs

if isempty(prefs)  % first call, default values
  prefs.plotting = 0;
  prefs.tolerance = 1e-10;
end

% Probably should use some nicer error catching...
if nargin==0
  varargout = { prefs };
elseif nargin==1
  varargout = { prefs.(varargin{1}) };
else
  prefs.(varargin{1}) = varargin{2};
end