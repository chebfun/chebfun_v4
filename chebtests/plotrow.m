function pass = plotrow

% Rodrigo Platte, Ricardo Pachon
% Tests whether row chebfuns are plotted

x = chebfun(@(x) x);
figure, plot([x x.^2 x.^3].','.-r'), close
pass = true;