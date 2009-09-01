function  m = slit(par)
% Multiple-slit maps. See Tee's thesis or Hale & Tee 2009.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

a = par(1);
b = par(2);
W = par(3:end);

[m.for m.der] = slitmap(W,[a b]);
m.par = [a b W(:).'];
m.name = 'slit';

end

function varargout = slitmap(w,dom,y)
% SLITMAP - conformal map to slit region
%  G = SLITMAP(W,D) returns a chebfun G which maps D to itself, and
%  conformally maps and ellipse with foci d.ends to entire complex 
%  plane minus the vertical congugate slits with tips at W. If D is
%  not given, it is assumed to be domain(-1,1).
%
%  [G GP] = SLITMAP(W,D) returns also the derivative values at those 
%  points.
%
%  [G GP RHO] = SLITMAP(W,D) returns also the derivative values at 
%  the parameter RHO which determines the size of the ellipse.
%
%  [G GP RHO Y] = SLITMAP(W,D) returns also a vector Y of the 
%  paramter values of the map. SLITMAP(W,D,Y) can use such a vector
%  as an initial guess.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if nargin == 1 
    if ~isnumeric(w), error('chebfun:domain:slitmap:arg1',...
        'First argument must be slit positions'); end
    dom = [-1 1];
elseif length(dom) > 2
    y = dom; 
    dom = [-1 1];
end

% tol = chebfunpref('eps');
tol = eps;

a = dom(1); b = dom(2);
l = @(x) .5*(b-a)*(x-1) - a;
linv = @(x) 2*(x-a)/(b-a) - 1;

if length(w) == 1 % single slit
    varargout{1} = @(z) l(slitmap1(linv(w),linv(z)));
    if nargout > 1
        varargout{2} = @(z) slitmap1(linv(w),linv(z),1);
    end
    if nargout > 2, slitmap1(linv(w),linv([a b]),1); y = []; end
else  % multiple slits
    if nargin < 3, % compute map paramters
        y = []; 
        slitmapm(linv(w),linv([a b]));
    end
    % construct chebfun
    varargout{1} = @(z) l(slitmapm(linv(w),linv(z),0));
    if nargout > 1
        varargout{2} = @(z) slitmapm(linv(w),linv(z),0,1);
    end
end

if nargout == 3
    varargout{3} = rho;
end
if nargout == 4
    varargout{4} = y;
end

% ---------------------------------------------------------

    function gout = slitmap1(wk,z,ignored)
        d = real(wk); e = imag(wk);
        c = sign(d)*realsqrt(0.5*((d^2+e^2+1)-realsqrt((d^2+e^2+1)^2-4*d^2)));
        s = realsqrt(1-c^2);
        m14 = (-e+realsqrt(e^2+s^2))/s;   m = m14^4;
        try
            L = -2*log(m14)/pi;
            [K Kp] = ellipkkp(L);
            rho = exp(pi*Kp/(4*K));
            [sn cn dn] = ellipjc(2*K*asin(z)/pi,L);
        catch ME1
            K = ellipke(m);
            Kp = ellipke(1-m);
            rho = exp(pi*Kp/(4*K));
            [sn cn dn] = ellipj(2*K*asin(z)/pi,m);
        end
        h1 = m14*sn;
        if nargin == 2   % gout = g
            gout = c/m14+((1-m14^2)/m14)*(h1-c)./(1-h1.^2);
        else             % gout = gp
            h1p = 2*K/pi*m14*(cn.*dn)./sqrt(1-z.^2);
            h1p(abs(real(z))==1) = (2*K/pi)^2*m14*(1-m);
            gout = (1-m14^2)/m14*h1p.*(1+h1.^2-2*c*h1)./(1-h1.^2).^2;
        end
    end

% ---------------------------------------------------------

    function gout = slitmapm(wk,z,pflag,ignored) % Multiple slits 
        
        % options
        cmax = 25;     % max number of iterations in Newton loop to find preimage of slit tips

        if nargin < 3, pflag = true; end

        d = real(wk); e = imag(wk);
        [d,index] = sort(d(:),'descend'); e = e(index); e = e(:);
        wk = d(:)+1i*e(:);                        % slit tips (in upper-half plane)
        n = length(d);

        if length(y) ~= n
            m14 = 0.5;
            theta = linspace(0,pi,n+1)';
            phi = (theta(2:n)-theta(1:n-1))./(theta(3:n+1)-theta(1:n-1));
            y = asin(2*[m14;phi]-1); 
        end

        if pflag
            fdat = {wk,n,tol,cmax};               % package data
            opts = optimset('tolfun',tol,'tolx',tol,'display','off');
            [y fval flag] = fsolve(@(x)mapfun(x,fdat),y,opts); % nonlinear system solver
            if flag~=1, warning('chebfun:slitmap', ...
                    'Nonlinear equation solver did not terminate normally'); end
%             if fval>sqrt(tol), warning('chebfun:slitmap', ...
%                     ['Catastrophic error! ',num2str(norm(fval,inf))]); send
        end

        psi = (sin(y(2:n))+1)/2;
        m14 = (sin(y(1))+1)/2;          m12 = m14^2;        m = m14^4; 
        try
            L = -2*log(m14)/pi;
            [K Kp] = ellipkkp(L);
            rho = exp(pi*Kp/(4*K));
            [sn cn dn] = ellipjc(2*K*asin(z)/pi,L);
        catch ME2
            K = ellipke(m);
            Kp = ellipke(1-m);
            rho = exp(pi*Kp/(4*K));
            [sn cn dn] = ellipj(2*K*asin(z)/pi,m);
        end
        h1 = m14*sn;        % h1 map

        rhs = [zeros(n-2,1);-pi*psi(n-1)];
        LHS = diag(1-psi(2:n-1),-1)-diag(ones(n-1,1),0)+diag(psi(1:n-2),1);
        theta = LHS\rhs;
        zk = exp(1i*theta);

        ak = diff(d)/pi;
        p = PHI([-m14;m14],ak,zk);
        M = (1-m14)^2/(4*m14); M = [2/(m14^2-1) .5 .5;[-1 -M 1+M;1 -1-M M]];
        lhs = -(1-m12)/(1+m12)*(M*[ak'*(theta-pi)+d(1) ; -1-p(1) ; 1-p(2)]);
        A = lhs(1); a0 = lhs(2); b0 = lhs(3);

        if nargin < 4
            gout = A + (a0./(h1-1) + b0./(h1+1)) + PHI(h1,ak,zk);
        else
            [ignored, phip] = PHI(h1,ak,zk);
            h1p = (abs(z)~=1).*(2*K/pi*m14).*cn.*dn./sqrt(1+(abs(z)==1)*eps-z.^2)+(abs(z)==1).*(2*K/pi)^2*m14*(1-m);
            gout = h1p.*(-a0./(h1-1).^2-b0./(h1+1).^2 + phip);  
        end

        rho = exp(pi*Kp/(4*K));
    end
end


function F = mapfun(y,fdat)
    % FORMS THE SYSTEM OF NONLINEAR EQUATIONS TO SOLVE FOR THE PARAMETERS OF THE H3 MAP
    [wk, n, tol, cmax] = deal(fdat{:});                  % package data

    m14 = (sin(y(1))+1)/2;
    m12 = m14^2;
    psi = (sin(y(2:n))+1)/2;
    rhs = [zeros(n-2,1);-pi*psi(n-1)];
    LHS = diag(1-psi(2:n-1),-1)-diag(ones(n-1,1),0)+diag(psi(1:n-2),1);
    theta = LHS\rhs;                                     % constrained angles
    zk = exp(1i*theta); zkbar = conj(zk);

    d = real(wk);
    ak = diff(d)/pi;
    p = PHI([-m14;m14],ak,zk);

    M = (1-m14)^2/(4*m14); M = [2/(m14^2-1) .5 .5 ; -1 -M 1+M ; 1 -1-M M];
    lhs = -(1-m12)/(1+m12)*(M*[ak'*(theta-pi)+d(1) ; -1-p(1) ; 1-p(2)]);
    A = lhs(1); a0 = lhs(2); b0 = lhs(3);

    s = ([0;theta]+[theta;pi])/2;
    count = 0;
    ZK = repmat(zk,1,n); ZKbar = repmat(zkbar,1,n);

    z = exp(1i*s);     ZZ = repmat(z.',n-1,1);
    gp = -a0./(z-1).^2-b0./(z+1).^2 + 1i*(1./(ZZ-ZK)-1./(ZZ-ZKbar)).'*ak;
    normgp = norm(gp,inf);

    while ((count <= cmax) && (normgp>tol))
        count = count+1;

        gpp = 2i*z.*(a0./(z-1).^3+b0./(z+1).^3) +z.*((1./(ZZ-ZK).^2-1./(ZZ-ZKbar).^2).'*ak);

        sold = s;
        s = s - imag(gp)./imag(gpp);

        tk = [theta;pi];     indx1 = s > tk;
        s(indx1) = (sold(indx1)+tk(indx1))/2;
        tk = [0;theta];        indx2 = s < tk;
        s(indx2) = (sold(indx2)+tk(indx2))/2;

        z = exp(1i*s);     ZZ = repmat(z.',n-1,1);
        gp = -a0./(z-1).^2-b0./(z+1).^2 + 1i*(1./(ZZ-ZK)-1./(ZZ-ZKbar)).'*ak;
        normgp = norm(abs(gp),inf);
    end

    if (count > cmax)
        if normgp > 1000, F = abs(wk)+exp(5*normgp); return, end
    end  

    ff = A + (a0./(z-1) + b0./(z+1)) + PHI(z,ak,zk);
    F = imag(ff-wk);
end

function [ff ffp] = PHI(zz,ak,zk)
    sz = size(zz); zz = zz(:);
    nz = length(zz); nzk = length(zk);
    ZK = repmat(zk,1,nz); 
    ZKbar = repmat(conj(zk),1,nz);
    ZZ = repmat(zz.',nzk,1);
    ZZ1 = ZZ-ZK; idx1 = find(real(ZZ1)<0 & imag(ZZ1)>=0);
    WW1 = log(ZZ1); WW1(idx1) = WW1(idx1)-2i*pi;
    ZZ2 = ZZ-ZKbar; idx2 = find(real(ZZ2)<0 & imag(ZZ2)<0);
    WW2 = log(ZZ2); WW2(idx2) = WW2(idx2)+2i*pi;
    ff = 1i*((WW1-WW2).'*ak);
    ff = reshape(ff,sz);
    if nargout > 1
        ffp = 1i*(1./(ZZ-ZK)-1./(ZZ-ZKbar)).'*ak;
        ffp = reshape(ffp,sz);
    end
end








