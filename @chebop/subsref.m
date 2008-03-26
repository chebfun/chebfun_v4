function A = subsref(A,s)

valid = false;
switch s(1).type
  case '{}'                          % return a realization (feval)
    t = s(1).subs;
    if length(t)==1 && isnumeric(t{1})  
      A = feval(A,t{1});
      valid = true;
    end
  case '()'                          % slice the varmat
    if length(s(1).subs)==2
      A = chebop( subsref(A.varmat,s), [], A.fundomain );
      valid = true;
    end
 end

if ~valid
  error('chebop:subsref:invalid','Invalid reference syntax.')
end
