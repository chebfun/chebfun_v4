function A = subsref(A,s)
%SUBSREF Extract information from a chebop.
%
% A{N} returns a realization of the chebop A at dimension N. If N is
% infinite, the functional form of the operator is returned as a function
% handle.
%
% A(I,J) returns a chebop that selects certain rows or columns from the
% finite-dimensional realizations of A. A(1,:) and A(end,:) are examples of
% valid syntax.
%
% A.bc returns a structure describing the boundary conditions expected for 
% functions in the domain of A. The result has fields 'left' and 'right',
% each of which is itself an array of structs with fields 'op' describing
% the operator on the solution at the boundary and 'val' with the imposed
% value there.
%
% See also chebop/subsasgn, chebop/and.

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
      A = chebop( subsref(A.varmat,s), @(u) [], A.fundomain );
      valid = true;
    end
  case '.'
    if isequal(s(1).subs,'bc')
      A = getbc(A);
      valid = true;
    end
 end

if ~valid
  error('chebop:subsref:invalid','Invalid reference syntax.')
end
