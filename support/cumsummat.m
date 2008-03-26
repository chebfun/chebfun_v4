function J = cumsummat(N)

% Slow algorithm!
N = N-1;
theta = pi*(N:-1:0)'/N;
T = cos( theta*(0:N) );  % coeffs -> values

k = 1:N;
B = diag(1./(2*k),-1) - diag(1./(2*(k-1)),1);
B(1,:) = sum( diag((-1).^(0:N-1))*B(2:N+1,:), 1 );
B(:,1) = 2*B(:,1);       % coeffs -> int coeffs

J = T*B/T;               % can get inv(T) by using DFT matrix instead
