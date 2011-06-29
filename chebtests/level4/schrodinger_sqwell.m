function pass = schrodinger_sqwell

% Tests eigs with piecewise constant coefficient, on a Schrodinger 
% wavefunction on square well potential. Exact solution computed in
% mathematica for these well parameters (unbounded domain). 

% piecewise constant potential function
d = [-40 0 6 46];         % domain with breakpoints 
U = chebfun({2,0,2},d);

N = chebop(@(psi) -diff(psi,2) + U.*psi, d, 0, 0);  % Schrodinger operator

[Psi,E] = eigs(N,2,0);   
energies = diag(E);

lambdaMMA = [ 0.422476214321786465165559636043; 
  0.836288791108712929906950164520];   % exact on unbounded domain

pass = norm( sqrt(energies) - lambdaMMA ) < 1e-11;
