function g = extrapolate(g,pref,x)
% Extrapolate at endpoints if needed using "Fejer's 2nd rule" type of
% barycentric formula. Also updates the vertical scale of g.

if pref.extrapolate || any(g.exps) || any(isinf(g.map.par([1 2]))) || any(isnan(g.vals)) 
    
    if pref.chebkind == 2
           
        v = g.vals(2:end-1);
        
        %if pref.sampletest || pref.splitting || any(g.exps) || any(isnan(g.vals)) || any(isinf(g.vals))
        % Always extrapolate! But put endpoint values back in if they seem
        % right!
        
        if nargin < 3
            x = chebpts(g.n);
        end
        
        % Force extrapolation at endpoints!
        vends = g.vals([1 end]);
        
        % Look for nans in the interior
        mask = isnan(v) | isinf(v);
        g.scl.v = max(g.scl.v,norm(v(~mask),inf));
        if any(mask)
            % Force extrapolation at end points
            mask = [true;mask;true];
            xgood = x(~mask);
            if isempty(xgood)
                error('CHEBFUN:extrapolate:nans','Too many nans to handle. Increasing minsamples may help')
            end
            xnan = x(mask);
            w = 0*xgood+1;
            for k=1:length(xnan)
                w =  w.*abs(xnan(k)-xgood);
            end
            w(2:2:end) = - w(2:2:end);
            for k =1:length(xnan)
                w2 = w./(xnan(k)-xgood);
                xnan(k) = sum(w2.*g.vals(~mask))/sum(w2);
            end
            g.vals(mask) = xnan;
        else
            % Force extrapolation at endpoints!
            xi = x(2:end-1);
            w = (1+xi); w(2:2:end) = -w(2:2:end);
            g.vals(end) = sum(w.*g.vals(2:end-1))/sum(w);
            w = (1-xi); w(2:2:end) = -w(2:2:end);
            g.vals(1) = sum(w.*g.vals(2:end-1))/sum(w);
        end
        
        %plot(x,g.vals,'.'); pause
        % Revert endpoint values?
        if ~isnan(vends(1)) && abs(g.vals(1)-vends(1)) < max(pref.eps,1e3*g.n*eps)*g.scl.v && ~g.exps(1) && ~isinf(g.map.par(1))
            g.vals(1) = vends(1);
        end
        if ~isnan(vends(2)) && abs(g.vals(end)-vends(2)) < max(pref.eps,1e3*g.n*eps)*g.scl.v && ~g.exps(2) && ~isinf(g.map.par(2))
            g.vals(end) = vends(end);
        end
        
        g.scl.v = max(g.scl.v,norm(g.vals(mask),inf));
        
        
    else % For first kind points, no need to check endpoints
        
        if  any(isnan(g.vals))
            if nargin < 3
                x = chebpts(g.n,pref.chebkind);
            end
            mask = isnan(g.vals) | isinf(g.vals);
            xgood = x(~mask);
            if isempty(xgood)
                error('CHEBFUN:extrapolate:nans','Too many nans to handle. Increasing minsamples may help')
            end
            xnan = x(mask);
            
            w = sin((2*(0:g.n-1)+1)*pi/(2*g.n)).';
            w(mask) = [];
            for k=1:length(xnan)
                w =  w.*abs(xnan(k)-xgood);
            end
            w(2:2:end) = - w(2:2:end);
            for k =1:length(xnan)
                w2 = w./(xnan(k)-xgood);
                xnan(k) = sum(w2.*g.vals(~mask))/sum(w2);
            end
            g.vals(mask) = xnan;
        end
        
        g.scl.v = max(g.scl.v,norm(g.vals,inf));
        
    end
    
else

    if any(isinf(g.vals))
        error('chebfun:inf','Function returned INF when evaluated. You may try using the BLOWUP flag in this case')
    end
    
    g.scl.v = max(g.scl.v,norm(g.vals,inf));
    
end
    
