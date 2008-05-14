function display(V)
% DISPLAY  Pretty-print a varmat.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.


loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = varmat']);
if loose, disp(' '), end

s = char(V);
disp(s)

end
