function display(A)
% DISPLAY  Pretty-print an oparray.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.


loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = oparray']);
if loose, disp(' '), end

s = char(A);
disp(s)
if loose, disp(' '), end

end
