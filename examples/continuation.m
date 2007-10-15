f = chebfun('exp(x)');
l = length(f);
R = 1*log(10)/l;
N = 24;             % right number of equally spaced points
zz = R*exp(2i*pi*(0:N-1)'/N);
c = fft(f(zz))/N;
c = real(c);
c = c./R.^(0:length(c)-1)';
disp(['       computed    '...  % table headings
        '         exact     '])
disp([c 1./gamma(1:N)'])        % results, approximate and exact