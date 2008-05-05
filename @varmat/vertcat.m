function C = vertcat(varargin)

C = varmat( @vcat );

   function B = vcat(n)
     A = cellfun( @(A) feval(A,n), varargin, 'uniform',0);
     B = vertcat( A{:} );
   end
 
 end