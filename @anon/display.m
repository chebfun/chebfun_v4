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
if length(A.variablesName)==1
  s = char(s,['Variable name = ' A.variablesName{1}],' ');
else
  s = char(s,'Variable names = ',' ',char(A.variablesName),' ');
end
s = char(s,'Workspace = ',' ');
disp(s);
display(A.workspace)

end

