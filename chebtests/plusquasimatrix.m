function pass = plus_qm

% Rodrigo Platte Jun 2009
% make sure plus requires quasimatrices of same sizes

 f = chebfun('x');
 pass = false;
 try
    g = [f 2*f]+f;
 catch
     pass = true;
 end
