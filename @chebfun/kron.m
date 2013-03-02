function h = kron(f,g) 
%KRON Kronecker/outer product of two chebfuns. 
%
% H = KRON(F,G) where F and G are chebfun/quasimatrices constructs a 
% chebfun2.  If size(F)=[Inf,K] and size(G)=[K,Inf] then H is a rank K 
% chebfun2 such that 
% 
%  H(x,y) = F(y,1)*G(x,1) + ... + F(y,K)*G(x,K).
%
% If size(F)=[K,Inf] and size(G)=[Inf,K] then H is a chebfun2 such that 
%
%  H(x,y) = G(y,1)*F(x,1) + ... + G(y,K)*F(x,K).
% 
% This is the continous analogue of the Matlab command KRON. 
%
% See also KRON.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if ( ~isa(f,'chebfun') || ~isa(g,'chebfun') )
    error('CHEBFUN:KRON:INPUTS','Both inputs should be chebfuns');
end


if ( isempty(f) || isempty(g) )
    h = chebfun2;  % return empty chebfun2 
    return;
end 

% get domains of chebfuns
fint = f.ends; 
gint = g.ends;

if ( length(fint) > 2 || length(gint) > 2 ) 
    error('CHEBFUN:KRON:BREAKPTS','The two chebfuns must be smooth and contain no break points.');
end

% check if we have the right sizes:
[mf,nf]=size(f);
[mg,ng]=size(g);

if ( ( mf ~= ng ) || ( nf ~=mg ) )
    error('CHEBFUN:KRON:SIZES','Inconsistent sizes for the continuous analogue of the Kronecker product.');
end

% call chebfun2 constructor 
if isinf(mf)
   rect = [gint fint];
   h = chebfun2(0,rect);
   for kk = 1:nf
       h = h + chebfun2(@(x,y) feval(f(:,kk),y).*feval(g(kk,:),x), rect);
   end
elseif isinf(nf)
    rect = [fint gint];
   h = chebfun2(0,rect);
   for kk = 1:mf
       h = h + chebfun2(@(x,y) feval(g(:,kk),y).*feval(f(kk,:),x), rect);
   end
else
    % We can probably never reach here, but display an error if we do. 
    error('CHEBFUN:KRON:INFSIZES','Kronecker product only works for chebfuns and quasimatrices.');
end

end
