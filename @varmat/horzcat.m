function C = horzcat(varargin)
% HORZCAT  Horizontally concatenate varmats.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = varmat( @hcat );

   function B = hcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = horzcat( A{:} );
     issp = cellfun( @issparse, A );
     if any(~issp), B = full(B); end
   end
 
 end