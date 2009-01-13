function pass = plotrow

% Rodrigo Platte Jan 2009
% Tests whether row chebfuns are plotted

x = chebfun(@(x) x);
figure, plot([x x.^2].','.-r'), close
pass = true;