function s = char(A)
% CHAR  Convert linop to pretty-printed string.

% Copyright 2008 by Toby Driscoll.
% See http://www.maths.ox.ac.uk/chebfun.

%  Last commit: $Author$: $Rev$:
%  $Date$:

if isempty(A)
  s = '   (empty linop)';
else
  s = '   operating on chebfuns defined on:';
  s = char(s,' ');
  s = char(s,['  ' char(A.fundomain)],' ');

  if all(A.blocksize==[1 1])
    if ~isempty(A.varmat)
      s = char(s,char(A.varmat,A.fundomain),' ');
    end
    if ~isempty(A.oparray)
      s = char(s, '   with functional representation:',' ',...
        ['     ' char(A.oparray)], ' ');
    end
  else
    s = char(s,sprintf('   with %ix%i block definitions',A.blocksize),' ');
  end
    
  if any(A.difforder(:)~=0)
      if numel(A.difforder) == 1
        s = char(s, ['   and differential order ' num2str(A.difforder)],' ');
      else
        dostr = [];
        do = A.difforder; sdo = size(do);
        for j = 1:sdo(1);
            for k = 1:sdo(2)
                dostr = [dostr ' ' num2str(do(j,k))];
            end
            dostr = [dostr ' ;'];
        end
        dostr(end-1:end) = [];
        s = char(s, ['   and differential order [' dostr, ' ]']);
      end
  end    
  
  if A.numbc > 0
    if A.numbc==1
      s = char(s,['   and ' int2str(A.numbc) ' boundary condition'],' ' );
    else
      s = char(s,['   and ' int2str(A.numbc) ' boundary conditions'],' ' );
    end
  end
end
