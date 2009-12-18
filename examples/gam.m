% This script displays some of the new features in version 3 for unbounded 
% functions by demonstrating with the gamma function on the interval [-4 4].
%
% Nick Hale, Dec 2009

% The gamma function on [-4 4] has simplie poles at the negative integers and zero

gamm = chebfun('gamma(x)',[-4 4],'blowup','on','splitting','on')

% Chebfun determines the location of this , and the correct order (shown by 'exps')

% We can now treat the gamma function as any other chebfun.
% For example, we can: 

% find it's reciprocal

gammi = 1./gamm

% compute square root of abs(gamma)

sqrtgamm = real(sqrt(abs(gamm)))

% plot these functions

plot(gamm,'b',gammi,'r', sqrtgamm,'-g'), hold on
legend('gamma function', '1/gamma(x)', 'sqrt(abs(gamma(x)))')

% plot the critical points

r = roots(diff(gamm));
ri = roots(diff(gammi));
rs = roots(diff(sqrtgamm));

plot(r,gamm(r),'.b',ri,gammi(ri),'.r',rs,sqrtgamm(rs),'.g'), hold off
title('Gamma function on [-4 4] and it''s critical points')

% And much more!!




