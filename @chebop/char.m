function s = char(A)
% CHAR  Convert chebop to pretty-printed string.

% Toby Driscoll, 12 May 2008.
% Copyright 2008.

if isempty(A)
  s = '   (empty chebop)';
else
  s = '   operating on chebfuns defined on:';
  s = char(s,' ');
  s = char(s,['  ' char(A.fundomain)],' ');
  s = char(s,char(A.varmat),' ');
  if ~isempty(A.oper(chebfun(1,A.fundomain)))
    s = char(s, '   and functional representation:',' ',...
      ['     ' char(A.oper)], ' ');
  end
  if A.difforder~=0
    s = char(s, ['   and differential order ' num2str(A.difforder)],' ');
  end    
  if A.numbc > 0
    if A.numbc==1
      s = char(s,['   and ' int2str(A.numbc) ' boundary condition'],' ' );
    else
      s = char(s,['   and ' int2str(A.numbc) ' boundary conditions'],' ' );
    end
  end
end
