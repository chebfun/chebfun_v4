function C = vertcat(varargin)
% VERTCAT  Vertical concatenation of varmats.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = varmat( @vcat );

   function B = vcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = vertcat( A{:} );
     issp = cellfun( @issparse, A );
     if any(~issp), B = full(B); end
   end
 
 end