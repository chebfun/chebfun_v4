function display(X)
% DISPLAY	Display fun
% DISPLAY(F) is called when the semicolon is not used at the end of a statement.
% DISPLAY(F) shows the type of fun and the function values at the
% Chebyshev points.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if isequal(get(0,'FormatSpacing'),'compact')
  if (isempty(X))
    disp([inputname(1) ' = empty fun']);
  elseif (X.trans & ~X.td)
    disp([inputname(1) ' = row fun']);
  elseif (~X.trans & ~X.td)
    disp([inputname(1) ' = column fun']);
  else
    disp([inputname(1) ' = matrix fun']);
  end
  disp([X.val])
else
  disp(' ')
  if (X.trans & ~X.td)
    disp([inputname(1) ' = row fun']);
  elseif (~X.trans & ~X.td)
    disp([inputname(1) ' = column fun']);
  else
    disp([inputname(1) ' = matrix fun']);
  end
  disp(' ');
  disp([X.val])
end
