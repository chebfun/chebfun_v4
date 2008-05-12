function display(r)
% DISPLAY Pretty-print domain to the command output.
%
% See also CHEBOP/CHAR.

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = domain']);
if loose, disp(' '), end

fprintf( [char(r) '\n\n'] )