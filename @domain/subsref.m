function t = subsref(d,s)
% SUBSREF Access data from a domain.
% Given domain D, D(1) and D(2) return the left and right endpoints of D.
% 
% D(:) or D.ends returns both endpoints as a vector.
%
% D.break returns the breakpoints (excluding endpoints). You can access a
% single breakpoint via D.break(I).

valid = false;
switch(s(1).type)
  case '()'
    if isempty(d)
      error('domain:subsref:empty',...
        'Cannot reference an endpoint of an empty domain.')
    end
    k = s(1).subs{1};
    valid = true;
    if isequal(k,1)
      t = d.ends(1);
    elseif isequal(k,2)
      t = d.ends(end);
    elseif isequal(k,':')
      t = d.ends([1 end]);
    else
      valid = false;
    end
  case '.'
    valid = true;
    switch(s(1).subs)
      case 'break'
        t = d.ends(2:end-1);
        if length(s)==2 && isequal(s(2).type,'()')
          if ~isequal(s(2).subs{1},':')
          t = t(s(2).subs{1});
          end
        end
      case 'ends'
        t = d.ends([1 end]);
      otherwise
        valid = false;
    end
end
        
if ~valid
  error('domain:subsref:invalid','Invalid reference.')
end
        
end