function C = vertcat(varargin)
% VERTCAT  Vertical concatenation of varmats.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

% Take out empties.
empty = cellfun( @isempty, varargin );
varargin(empty) = [];

C = varmat( @vcat );

   function B = vcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = vertcat( A{:} );
     issp = cellfun( @issparse, A );
     if any(~issp), B = full(B); end
   end
 
 end