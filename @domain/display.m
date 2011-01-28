function display(r)
% DISPLAY Pretty-print domain to the command output.
%
% See also CHEBOP/CHAR.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, fprintf('\n'), end
disp([inputname(1) ' = domain']);
if loose, fprintf('\n'), end
fprintf( [char(r) '\n'] )
if loose, fprintf('\n'), end