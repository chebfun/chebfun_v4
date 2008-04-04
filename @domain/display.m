function display(r)

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = domain']);
if loose, disp(' '), end

fprintf( [char(r) '\n\n'] )