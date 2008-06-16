function display(V)
% DISPLAY  Pretty-print a varmat.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = varmat']);
if loose, disp(' '), end

s = char(V);
disp(s)
if loose, disp(' '), end

end
