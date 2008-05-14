function display(A)
% DISPLAY Pretty-print a chebop.

% Toby Driscoll, 12 May 2008.
% Copyright 2008.

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = chebop']);
if loose, disp(' '), end
s = char(A);
if ~loose   
  s( all(isspace(s),2), : ) = [];  % remove blank lines
end
disp(s)

end

