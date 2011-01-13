function Fout = mtimes(F1,F2)
%*	  Chebfun multiplication.
% c*F or F*c multiplies a chebfun F by a scalar c.
%
% F*G, if F is an m-by-Inf row chebfun and G is an Inf-by-n column chebfun, 
% returns the m-by-n matrix of pairwise inner products. F and G must have
% the same domain.
%
% A=F*G, if F is Inf-by-m and G is m-by-Inf, results in a rank-m linop A
% such that A*U=F*(G*U) for any chebfun U. 
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

%  Last commit: $Author$: $Rev$:
%  $Date$:


% Quasi-matrices product
if (isa(F1,'chebfun') && isa(F2,'chebfun'))
    if size(F1,2) ~= size(F2,1)
        error('CHEBFUN:mtimes:quasi','Quasimatrix dimensions must agree.')
    end
    if isinf(size(F1,1))     % outer product
      splitstate = chebfunpref('splitting');
      splitting off
      sampstate = chebfunpref('resampling');
      resampling on
      Fout = 0;
      d = domain(F1);
      if ~(d==domain(F2))
        error('CHEBFUN:mtimes:outerdomain',...
          'Domains must be identical for outer products.')
      end
      for i = 1:size(F1,2)
        f = F1(:,i);
        g = F2(i,:);
        op = @(u) f * (g*u);  % operational form
                    
        % Matrix form available only for unsplit functions.
        if f.nfuns==1 && g.nfuns==1 
          x = @(n) d(1) + (1+sin(pi*(2*(1:n)'-n-1)/(2*n-2)))/2*length(d);
          C = cumsum(d);
          w = C(end,:);  % Clenshaw-Curtis weights, any n
          mat = @(n) matfun(n,w,x,f,g);
        else
          mat = [];
        end
        Fout = Fout + linop(mat,op,d);
      end
      chebfunpref('splitting',splitstate)
      chebfunpref('resampling',sampstate)
    else      % inner product
      Fout = zeros(size(F1,1),size(F2,2));
      for k = 1:size(F1,1)
        for j = 1:size(F2,2)
          if F1(k).trans && ~F2(j).trans
            Fout(k,j) = sum((F1(k).').*F2(j));
          else
	    error('CHEBFUN:mtimes:dim','Chebfun dimensions must agree.')
          end
        end
      end
    end

% Chebfun times double
elseif isa(F1,'chebfun')
    % scalar times chebfun
    if numel(F2) == 1
        Fout = F1;
        for k = 1:numel(F1)
            Fout(k) = mtimescol(F2,F1(k));
        end
     % quasimatrix times matrix of doubles
    else
        if size(F1,2)~=size(F2,1), error('CHEBFUN:mtimes:dim','Dimensions must agree'), end
        for j = 1:size(F2,2)
            Fout(j) =  mtimescol(F2(1,j),F1(1));
            for i = 2:size(F2,1)
                Fout(j) = Fout(j) + mtimescol(F2(i,j),F1(i));
            end
        end
    end
else
    Fout = mtimes(F2.',F1.').';
end

end

% ------------------------------------
function f = mtimescol(a,f)

for i = 1:f.nfuns
    f.funs(i) = a*f.funs(i);
end
f.imps = a*f.imps;
f.scl = abs(a)*f.scl;

f.jacobian = anon('[tempDer nonConst] = diff(f,u); der = a*tempDer; nonConst = (a~=0)*nonConst;',{'a' 'f'},{a f},1);
f.ID = newIDnum;
end


function m = matfun(n,w,x,f,g)
    if iscell(n), n = n{1}; end
    m = feval(f,x(n)) * (w(n) .* feval(g,x(n)).');
end