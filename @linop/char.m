function s = char(A)
% CHAR  Convert chebop to pretty-printed string.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

if isempty(A)
  s = '   (empty chebop)';
else
  s = '   operating on chebfuns defined on:';
  s = char(s,' ');
  s = char(s,['  ' char(A.fundomain)],' ');

  if all(A.blocksize==[1 1])
    if ~isempty(A.varmat)
      s = char(s,char(A.varmat),' ');
    end
    if ~isempty(A.oparray)
      s = char(s, '   with functional representation:',' ',...
        ['     ' char(A.oparray)], ' ');
    end
  else
    s = char(s,sprintf('   with %ix%i block definitions',A.blocksize),' ');
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
