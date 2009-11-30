function display(A)
% DISPLAY Pretty-print an anon
% DISPLAY is called automatically when a statement that results in an anon
% output is not terminated with a semicolon.
%
% Asgeir Birkisson, 2009

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = anon']);
if loose, disp(' '), end
s = [];
s = char(s,['Function = ' A.function],' ');
s = char(s,['Variables name = ' char(A.variablesName)],' ');
s = char(s,'Workspace = ');
disp(s);
disp(A.workspace{:});

end

