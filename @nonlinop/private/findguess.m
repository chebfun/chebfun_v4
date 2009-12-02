function guess = findguess(N)
% FINDGUESS Constructs initial guess for the solution of BVPs
%
% FINDGUESS starts with a quasimatrix with one column (the zero chebfun),
% then adds another column with the zero function to the quasimatrix until
% it's able to apply the operator to the quasimatrix (which means that the
% quasimatrix is then of the correct size).

dom = N.dom;
cheb0 = chebfun(0,dom);
guess = cheb0;
success = 0;
counter = 0;
while ~success && counter < 10
    try
        feval(N.op,guess);
        success = 1;
    catch
        guess = [guess cheb0];
        counter = counter+1;
    end  
end