function v = chebifft(X)
% Vectorised chebfun ifft.
    lc = size(X,1);
    ii = 2:lc-1;
    X(ii,:) = 0.5*X(ii,:);
    v = [X(end:-1:1,:) ; X(ii,:)];
    if isreal(X)
        v = real(ifft(v));
    elseif isreal(1i*X)
        v = 1i*real(ifft(imag(v)));
    else
        v = ifft(v);
    end
    v = (lc-1)*[ 2*v(1,:) ; v(ii,:)+v(2*lc-ii,:) ; 2*v(lc,:) ];
    v = v(end:-1:1,:);
end