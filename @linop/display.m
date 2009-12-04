function display(A)
% DISPLAY Pretty-print a linop.
% DISPLAY is called automatically when a statement that results in a linop
% output is not terminated with a semicolon.
% See www.comlab.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = linop']);
if loose, disp(' '), end
s = char(A);
if ~loose   
  s( all(isspace(s),2), : ) = [];  % remove blank lines
end
disp(s)

end

