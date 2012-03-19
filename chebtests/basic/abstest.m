
function pass = abstest

% Tests an absolute value (this didn't work briefly
% in March 2012 due to a bug).

tol = 500*chebfunpref('eps');

gam = chebfun('gamma(x)',[-4 4],'blowup','on','splitting','on');
absgam = abs(gam);
pass = abs(absgam(.5)-abs(gam(.5))) < tol;
