function t = subsref(d,s)

% d(1) or d(2)
% d(:) or d.ends (endpoints)
% d.break
% d.break(i)

valid = false;
switch(s(1).type)
  case '()'
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
  error('domain:subsref:invalid','Invalid reference syntax.')
end
        
end