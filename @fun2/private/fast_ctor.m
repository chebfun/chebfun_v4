function g = fast_ctor(op)    
% Assuming on [-1 1 -1 1] for now. 


%% Adaptive case.
    % Do ACA while making sure the slices are resolved.
    pref2 = chebfun2pref; tol=pref2.eps;
    rk = pref2.minsample;
    spotcheck = 1;
    while spotcheck
        imunhappy = 1;  % If unhappy, selected pivots were not good enough.
        while imunhappy
            rk = 2^(floor(log2(rk))+1)+1;  % discretise on powers of 2, clustering is important.
             [xx,yy]=cheb2pts(rk,rk);
            vals = op(rk,rk,0);              % Matrix of values at cheb2pts.
            [PivotValue,PivotPos,Rows,Cols,ifail] = CompleteACA(vals,pref2.eps);
            scl = abs(PivotValue(1)); strike = 0;
            while ifail && rk<=pref2.maxrank && strike < 3
                rk=2^(floor(log2(rk))+1)+1;                % Double the sampling
                 [xx,yy]=cheb2pts(rk,rk);
                vals = op(rk,rk,0);
%                 vals = op(xx,yy);                           % Resample on denser grid.
                [PivotValue,PivotPos,Rows,Cols,ifail] = CompleteACA(vals,tol);
                if abs(PivotValue(1))<100*tol, strike = strike + 1; end %If the function is 0+noise then stop after three strikes. 
            end
            if rk >= pref2.maxrank
                error('FUN2:CTOR','Unable to resolve with low rank.');
            end
            
            % See if the slices are resolved.
            Rw = chebfft(Rows.'); Cw = chebfft(Cols);
            itr = 1:min(9,length(Rw)); itc = 1:min(9,length(Cw));
            ResolvedRows = all( (max(abs(Rw(itr,:)))<scl*pref2.eps));
            ResolvedCols = all( (max(abs(Cw(itc,:)))<scl*pref2.eps));
            ResolvedSlices = ResolvedRows & ResolvedCols;
            if strike >= 3, ResolvedSlices =1; end   %If the function is 0+noise then pass along as resolved. 
            
            if length(PivotValue)==1 && PivotValue==0
                PivPos=[0 0]; ResolvedSlices=1;
            else
                PivPos = [xx(1,PivotPos(:,2)); yy(PivotPos(:,1),1).'].'; PP=PivotPos;
            end
            n=rk; m=rk;
            % If unresolved then perform ACA on selected slices.
            while ~ResolvedSlices && rk < 6000
                if ~ResolvedCols
                    n=2^(floor(log2(n))+1)+1;
%                      [xx yy] = meshgrid(PivPos(:,1),chebpts(n));
                    Cols = op(PivPos(:,1),n,2);
                    oddn = 1:2:n; PP(:,1) = oddn(PP(:,1)); % find location of pivots on new grid.
                end
                if ~ResolvedRows
                    m =2^(floor(log2(m))+1)+1;
%                      [xx yy] = meshgrid(chebpts(m),PivPos(:,2));
                    Rows = op(m,PivPos(:,2),1);
                    oddm = 1:2:m; PP(:,2) = oddm(PP(:,2)); % find location of pivots on new grid.
                end
                
                nn = numel(PivotValue);
                % ACA on selected Pivots.
                for kk=1:nn-1
                    selx = PP(kk+1:nn,1); sely = PP(kk+1:nn,2);
                    Cols(:,kk+1:end) = Cols(:,kk+1:end) - Cols(:,kk)*(Rows(kk,sely)./PivotValue(kk));
                    Rows(kk+1:end,:) = Rows(kk+1:end,:) - Cols(selx,kk)*(Rows(kk,:)./PivotValue(kk));
                end
                
                % Are the columns and rows resolved now?
                if ~ResolvedCols
                    Cw = chebfft(Cols);
                    clcfs = max(abs(Cw(1:9,:)));
                    ResolvedCols = all( (clcfs<10*scl*pref2.eps./abs(PivotValue)));
                    if any(clcfs > 1e5*scl), break; end;
                end
                if ~ResolvedRows
                    Rw = chebfft(Rows.');
                    rwcfs = max(abs(Rw(1:9,:)));
                    ResolvedRows = all( (rwcfs<10*scl*pref2.eps./abs(PivotValue)));
                    if any(rwcfs > 1e5*scl), break; end;
                end
                ResolvedSlices = ResolvedRows & ResolvedCols;
            end
            if ResolvedSlices, imunhappy = 0; end % Pivots locations became poor: go back and get better ones.
            
        end
        if ( rk >= 65000 )
            error('FUN2:CTOR','Max number of points reached: unresolved along a slice');
        end
        
        % Now slices and columns are resolved make chebfuns.
        if pref2.mode
            Rows = transpose(chebfun(Rows.')); Cols = chebfun(Cols);
        end
        % Simplify the chebfuns.
        %     Rows = simplify(Rows); Cols=simplify(Cols);
        
        
        % Construct a FUN2
        g.U = PivotValue;
        g.PivPos = PivPos; % Store pivot positions for plotting.
        % rank is number of pivots unless its the zero function.
        if length(PivotValue) == 1 && PivotValue(1) == 0
            g.rank = 0;
        else
            g.rank = length(PivotValue);
        end
        
        g.scl = abs(PivotValue(1));
        g.C = Cols;
        g.R = Rows;  % store as rows and not columns.
        g.map = linear2D([-1,1,-1,1]);
        % evaluate at a arbitary point in the domain, to exclude Chebyshev
        % function etc.
        %     r = 0.029220277562146; s = 0.237283579771521;
        %     r = (ends(2)-ends(1))*r + ends(1); s = (ends(4)-ends(3))*s + ends(3);
        %     if (abs(op(r,s) - feval(g,r,s))< 10*g.scl*pref2.eps), spotcheck=0; end
        g = fun2(g); 
        spotcheck=0;
    end
end