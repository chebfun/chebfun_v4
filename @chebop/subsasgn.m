function A = subsasgn(A,s,B)

valid = false;
switch s(1).type
  case '()'
    t = s(1).subs;
    if length(t)==2 && isequal(t{2},':')
      valid = true;
      if ~iscell(B)
        A = addconstraint(A,t{1},B);
      else
        A = addconstraint(A,t{1},B{1},B{2});
      end
     end
    
  case '.'
    switch s(1).subs
      case 'bc'
        if length(s)==1  % no index specified
          A = clearconstraint(A);
          idx = 1;
          valid = true;
        elseif isequal(s(2).type,'()') && length(s(2).subs)==1
          % Don't allow gaps in the constraint structure for now. Needs to
          % be revisited later.
          idx = min(1+length(A.constraint),s(2).subs{1});
          valid = true;
        end
        if valid 
          if isnumeric(B)
            % Homogeneous Dirichlet.
            A = setconstraint(idx,A,B);
          elseif iscell(B)
            A = setconstraint(idx,A,B{:});
          else
            valid = false;
          end
        end
      case 'scale'
        A.scale = B;
        valid = true;
    end
end

if ~valid
  error('chebop:subsasgn:invalid','Invalid assignment syntax.')
end
