function C = horzcat(varargin)
% HORZCAT  Horizontally concatenate varmats.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = varmat( @hcat );

   function B = hcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = horzcat( A{:} );
     issp = cellfun( @issparse, A );
     if any(~issp), B = full(B); end
   end
 
 end