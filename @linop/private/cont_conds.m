function [Cmat,c] = cont_conds_sys(A,Nsys,map,breaks)
% Retrieve continuity conditions for a piecewise linop

    Adifforder = A.difforder;
    maxdo = max(Adifforder,[],2); % maxdo(j) is the difforder of eqn j
    bks = breaks;
    N = [Nsys{:}];
    syssize = numel(Nsys);
    
    Cmat = zeros(1,sum(N));        % Continuituty bcs for pw intervals.    
    bcrownum = 1; intnum = 1; csN = cumsum([0 N]);  
    % Apply continuity conditions for piecewise intervals
    for kk = 1:syssize
        dok = max(Adifforder(:,kk));    % Difforder for this equation
        numfunsk = numel(bks{kk})-1; % # of intervals in this variable
        if numfunsk > 1
            Nsysk = Nsys{kk};           % # of points in each interval
            % Make the differentiation matrices for piecewise boundary conditions.
            if dok > 1
                D = zeros(sum(Nsysk),sum(Nsysk),dok-1);
                bkk = bks{kk}([1 end]);
                D(:,:,1) = feval(diff(domain(bkk)),Nsysk,map,bks{kk});
                for ll = 2:dok-1
                  D(:,:,ll) = D(:,:,1)*D(:,:,ll-1);
                end
            end

            csNsysk = cumsum([0 Nsysk]);
            % Extract the right rows
            for jj = 1:numfunsk-1
                % Continuity condition
                Cmat(bcrownum,csN(intnum)+Nsysk(jj)+(0:1)) = [-1 1];
                bcrownum = bcrownum + 1;
                % Derivative conditions
                indxl = csNsysk(jj)+(1:Nsysk(jj));
                indxr = csNsysk(jj+1)+(1:Nsysk(jj+1));
                len = indxr(end)-indxl(1)+1;
                for ll = 1:dok-1   
                    Dl = D(csNsysk(jj+1),indxl,ll);
                    Dr = D(csNsysk(jj+1)+1,indxr,ll);
                    Cmat(bcrownum,csN(intnum)+(1:len)) = [-Dl Dr];
                    bcrownum = bcrownum + 1;
                end
                intnum = intnum + 1;
            end
            intnum = intnum + 1;
        else
            intnum = intnum + 1;
        end
    end
    c = zeros(size(Cmat,1),1); % RHS of continuity conditions
    
    if numel(c) == 1 && ~any(Cmat)
        Cmat = []; c = []; return
    end