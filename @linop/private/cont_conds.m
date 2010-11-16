function [Cmat,c] = cont_conds(A,Nsys,map,breaks)
% Retrieve continuity conditions for a piecewise linop

N = Nsys{:};
breaks = breaks{:};
syssize = numel(N);
dom = domain(breaks([1 end]));

if syssize < 2, return; end

A.difforder
numbcs = (syssize-1)*A.difforder
Cmat = zeros(numbcs,sum(N));        % Continuituty bcs for pw intervals.
bcrownum = 1; intnum = 1; csN = cumsum([0 N]);

% Apply continuity conditions for piecewise intervals
for kk = 1:syssize-1
    numfunsk = syssize; % # of intervals in this variable
    Nsysk = N;          % # of points in each interval
    
    % Make the differentiation matrices for piecewise boundary conditions.
    if A.difforder > 1
        D = zeros(sum(Nsysk),sum(Nsysk),A.difforder-1);
        D(:,:,1) = feval(diff(dom),N,map,breaks);
        for ll = 2:A.difforder-1
            D(:,:,ll) = D(:,:,1)*D(:,:,ll-1);
        end
    end
    
    csNsysk = cumsum([0 N]);
    % Extract the right rows
    for jj = 1:numfunsk-1
        
        % Continuity condition
        Cmat(bcrownum,csN(intnum)+Nsysk(jj)+(0:1)) = [-1 1];
        bcrownum = bcrownum + 1;
        
        % Derivative conditions
        indxl = csNsysk(jj)+(1:Nsysk(jj));
        indxr = csNsysk(jj+1)+(1:Nsysk(jj+1));
        len = indxr(end)-indxl(1)+1;
        for ll = 1:A.difforder-1
            Dl = D(csNsysk(jj+1),indxl,ll);
            Dr = D(csNsysk(jj+1)+1,indxr,ll);
            Cmat(bcrownum,csN(intnum)+(1:len)) = [-Dl Dr];
            bcrownum = bcrownum + 1;
        end
        intnum = intnum + 1;
    end
    intnum = intnum + 1;
end
c = zeros(numbcs,1);

% function [Cmat,c] = cont_conds(A,Nsys,map,breaks)
% % Retrieve continuity conditions for a piecewise linop
% 
% N = Nsys{:};
% breaks = breaks{:};
% syssize = numel(N);
% dom = domain(breaks([1 end]));
% 
% if syssize < 2, return; end
% 
% numbcs = (syssize-1)*A.difforder;
% Cmat = zeros(numbcs,sum(N));        % Continuituty bcs for pw intervals.
% bcrownum = 1; intnum = 1; csN = cumsum([0 N]);
% 
% % Apply continuity conditions for piecewise intervals
% for kk = 1:syssize-1
%     numfunsk = syssize; % # of intervals in this variable
%     Nsysk = N;          % # of points in each interval
%     
%     % Make the differentiation matrices for piecewise boundary conditions.
%     if A.difforder > 1
%         D = zeros(sum(Nsysk),sum(Nsysk),A.difforder-1);
%         D(:,:,1) = feval(diff(dom),N,map,breaks);
%         for ll = 2:A.difforder-1
%             D(:,:,ll) = D(:,:,1)*D(:,:,ll-1);
%         end
%     end
%     
%     csNsysk = cumsum([0 N]);
%     % Extract the right rows
%     for jj = 1:numfunsk-1
%         
%         % Continuity condition
%         Cmat(bcrownum,csN(intnum)+Nsysk(jj)+(0:1)) = [-1 1];
%         bcrownum = bcrownum + 1;
%         
%         % Derivative conditions
%         indxl = csNsysk(jj)+(1:Nsysk(jj));
%         indxr = csNsysk(jj+1)+(1:Nsysk(jj+1));
%         len = indxr(end)-indxl(1)+1;
%         for ll = 1:A.difforder-1
%             Dl = D(csNsysk(jj+1),indxl,ll);
%             Dr = D(csNsysk(jj+1)+1,indxr,ll);
%             Cmat(bcrownum,csN(intnum)+(1:len)) = [-Dl Dr];
%             bcrownum = bcrownum + 1;
%         end
%         intnum = intnum + 1;
%     end
%     intnum = intnum + 1;
% end
% c = zeros(numbcs,1);