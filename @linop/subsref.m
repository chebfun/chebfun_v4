function A = subsref(A,s)
%SUBSREF  Extract information from a linop.
% A{N} returns a realization of the linop A at dimension N. If N is
% infinite, the functional form of the operator is returned as a function
% handle. If N is finite, any boundary conditions on A will be applied to
% some rows of A. (This is equivalent to the output of FEVAL(A,N,'bc').)
%
% A(I,J) returns a linop that selects certain rows or columns from the
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
% See also linop/subsasgn, linop/feval, linop/and.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:


valid = false;
switch s(1).type
  case '{}'                              
  case '()'                          
    t = s(1).subs;
    if isa(t{1},'chebfun')
      A = mtimes(A,t{1});
      valid = true;
    elseif length(t)==2
      % Will return first row, last row, or both only.
      firstrow = t{1}==1;
      lastrow = isinf(t{1}) & real(t{1})==0;
      pts = [];
      if any(firstrow), pts = [pts; A.fundomain(1)]; end
      if any(lastrow), pts = [pts; A.fundomain(2)]; end
      if isequal(t{2},':') && ~isempty(pts)
        mat = subsref(A.varmat,s);
        op = @(u) feval(A*u,pts);
        A = linop(mat,op,A.fundomain );
        valid = true;
      end
    elseif length(t)==1 && isnumeric(t{1})  % return a realization (feval)
      if A.numbc > 0
        A = feval(A,t{1},'bc');
      else
        A = feval(A,t{1});
      end
      valid = true;
   end
  case '.'
    valid = true;
    switch(s(1).subs)
      case 'bc'
        A = getbc(A);
      case 'lbc'
        A = getbc(A);
        A = A.left;
        if length(s)>1
          A = subsref(A,s(2:end));  % respect deeper indexing
        end
      case 'rbc'
        A = getbc(A);
        A = A.right;
        if length(s)>1
          A = subsref(A,s(2:end));  % respect deeper indexing
        end
      case 'scale'
        A = A.scale;
      case 'numbc'
        A = A.numbc;
      case 'difforder'
        A = A.difforder;
      case 'ID'
        A = A.ID;
      otherwise 
        valid = false;
    end
 end

if ~valid
  error('linop:subsref:invalid','Invalid reference syntax.')
end
