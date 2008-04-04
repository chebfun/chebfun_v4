function display(V)

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = varmat']);
if loose, disp(' '), end

s = char(V);
disp(s)
