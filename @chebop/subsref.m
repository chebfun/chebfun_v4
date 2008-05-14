function A = subsref(A,s)
%SUBSREF  Extract information from a chebop.
% A{N} returns a realization of the chebop A at dimension N. If N is
% infinite, the functional form of the operator is returned as a function
% handle.
%
% A(I,J) returns a chebop that selects certain rows or columns from the
% finite-dimensional realizations of A. A(1,:) and A(end,:) are examples of
% valid syntax. Normally this syntax is not needed at the user level, but 
% it may be useful for expressing nonseparated boundary conditions, for
% example.
%
% A.bc returns a structure describing the boundary conditions expected for 
% functions in the domain of A. The result has fields 'left' and 'right',
% each of which is itself an array of structs with fields 'op' describing
% the operator on the solution at the boundary and 'val' with the imposed
% value there.
%
% A.scale returns the global scale set for linear system solution, as
% described in the documentation for mldivide.
%
% See also chebop/subsasgn, chebop/and, chebop/mldivide.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

valid = false;
switch s(1).type
  case '{}'                              
  case '()'                          
    t = s(1).subs;
    if length(s(1).subs)==2          % slice the varmat
      A = chebop( subsref(A.varmat,s), @(u) [], A.fundomain );
      valid = true;
    elseif length(t)==1 && isnumeric(t{1})  % return a realization (feval)
      A = feval(A,t{1});
      valid = true;
   end
  case '.'
    switch(s(1).subs)
      case 'bc'
        A = getbc(A);
        valid = true;
      case 'scale'
        A = A.scale;
        valid = true;
    end
 end

if ~valid
  error('chebop:subsref:invalid','Invalid reference syntax.')
end
