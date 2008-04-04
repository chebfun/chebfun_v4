function A = and(A,bc)
% &     Set boundary conditions for a chebop.
%
% (A & BC) returns a chebop the same as A but with boundary conditions
% defined by BC. If A had any boundary conditions, they are discarded.
%
% There are multiple options for BC:
%
%   'dirichlet' or {'dirichlet',X} :  set value to zero or to X
%   'neumann' or {'neumann',z}     :  set derivative to zero or to X
%   B or {B,z}                     :  B is a chebop defining boundary operator          
%   'periodic'                     :  periodicity up to diff. order
%
% In addition, BC may be a struct with fields 'left' and 'right'. Each
% field can be any of the first three options above. If one wants to impose
% multiple conditions at one boundary, then the field needs to be a struct
% array with fields 'op' and 'val'. For example:
%
%   lbc = struct( 'op', {'dirichlet','neumann'}, 'val', {1,0} );
%   bc = struct( 'left', lbc, 'right', struct([]) );
%   A = (A & bc);
%
% It may be more convenient in this context to use A.lbc and A.rbc 
% assignment syntax instead. See CHEBOP/SUBSASGN for more information.
%
% One use of & is to apply boundary conditions that were read off of
% another chebop. For example, A = (A & B.bc);
%
% Note that A = (A & BC) is a synonym for A.bc = BC. However, the & syntax
% creates a new object that can be renamed or used inline, as an argument to
% another function.
%
% See also chebop/subsref, chebop/subsasgn.

A = setbc(A,bc);

end