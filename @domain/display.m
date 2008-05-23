function display(r)
% DISPLAY Pretty-print domain to the command output.
%
% See also CHEBOP/CHAR.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = domain']);
if loose, disp(' '), end

fprintf( [char(r) '\n\n'] )