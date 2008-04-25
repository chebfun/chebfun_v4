function display(A)

loose = ~isequal(get(0,'FormatSpacing'),'compact');
if loose, disp(' '), end
disp([inputname(1) ' = chebop']);
if loose, disp(' '), end

if isempty(A)
  disp( '   (empty)' )
else
  disp( '   operating on chebfuns defined on:' )
  if loose, disp(' '), end
  disp( ['  ' char(A.fundomain)] )
  if loose, disp(' '), end
  disp( char(A.varmat) );
  if ~isempty(A.oper(chebfun(1,A.fundomain)))
    if loose, disp(' '), end
    disp( '   and functional representation:' )
    if loose, disp(' '), end
    disp( ['     ' char(A.oper)] )
    if loose, disp(' '), end
  end
  if A.numbc > 0
    if A.numbc==1
      disp( ['   and ' int2str(A.numbc) ' boundary condition'] )
    else
      disp( ['   and ' int2str(A.numbc) ' boundary conditions'] )
    end
    if loose, disp(' '), end
  end
end
