function C = horzcat(varargin)

C = varmat( @hcat );

   function B = hcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = horzcat( A{:} );
   end
 
 end