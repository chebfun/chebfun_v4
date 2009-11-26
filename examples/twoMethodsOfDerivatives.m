% We show two methods to obtain derivatives in the chebfun system.
%
% The first method uses spectral differentiation matrices. While the first
% derivative obtained by that method has high accuracy, this method starts
% to lose accuracy as we go to higher order derivatives. This is caused
% that we are actually just differentiating a polynomial, so once we ask
% for a derivative of higher order than the original polynomial, we would
% expect to get the zero function on the domain.
%
% The second method uses automatic differentiation (AD). This method
% returns the correct derivative no matter how high order we go, but has
% the drawback that higher order derivatives become more expensive in
% computation time to to obtain.
%
% Asgeir Birkisson, 2009

%% Using spectral differentiation
[d,x] = domain(-1,1);
expx = exp(x);

for i = 1:15
    expx = diff(expx);
    norms(i) = norm(exp(x) - expx);
end
figure; semilogy(norms,'*-')
title(['Difference between correct value of derivative and ' ...
    'calculated value using spectral diff.'])

% Since exp(x) has the length 15, we expect the following to be zero (which
% it is).
disp(['The norm of the 15th derivative of exp(x)  ' ...
    10 'obtained by spectral differentiation is ' ...
    num2str(norm(diff(exp(x),length(exp(x))))) '.']);

%% Using AD
[d,x] = domain(-1,1);
expx = exp(x);

for i = 1:15
    tic
    expx = diag(diff(expx,x));
    norms(i) = norm(exp(x) - expx);
    compTimes(i) = toc;
end
figure; plot(norms,'*-')
title(['Difference between correct value of derivative and ' ...
    'calculated value using AD']);

figure; semilogy(compTimes,'*-');
title('Computation time to obtain derivative using AD')

