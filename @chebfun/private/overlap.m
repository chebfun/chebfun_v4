function [fout,gout] = overlap(f,g)
% OVERLAP chebfuns
%
% [fout,gout] = OVERLAP(f,g) returns two chebfuns such that
% fout.ends==gout.ends 
% 
% This function replaces support/overlap.m

% Copyright 2002-2008 by The Chebfun Team. 
% See www.comlab.ox.ac.uk/chebfun.html

if f.trans ~= g.trans
    error('The .trans field of the two chebfuns must agree')
end

fends=f.ends; gends=g.ends;
frows=size(f.imps,1); grows=size(g.imps,1); maxrows=max(frows,grows);
fimps=f.imps; gimps=g.imps;

if length(fends)==length(gends) && all(fends==gends)

    fout=f; gout=g;    
    fout.imps=[fimps; zeros(maxrows-frows,length(fends))];
    gout.imps=[gimps; zeros(maxrows-grows,length(fends))];    

else
    
    hs = max(abs([fends(1) fends(end)]));
    if norm([fends(1)-gends(1), fends(end)-gends(end)],inf) > 1e-15*hs
       error('domain(f) ~= domain(g)')
    end
    ends=union(fends,gends);
    
    % If ends(i) is too close to ends(i+1), merge them: ------------------
    if min(diff(ends))<1e-15*hs
        for k=1:length(fends)
            [delta,ind]=min(abs(gends-fends(k)));
            if delta < 1e-15*hs
                fends(k)=gends(ind);
            end
        end
        f.ends = fends;
        [fout,gout] = overlap(f,g);
        return;
    end
    % --------------------------------------------------------------------
    
    fk=1; gk=1;
    foutfuns=[];
    goutfuns=[];

    for k=1:length(ends)-1
        a=ends(k); b=ends(k+1);
        gfun=g.funs(gk); ffun=f.funs(fk);
        if fends(fk)==a && fends(fk+1)==b
           fk=fk+1;
        else
            if fends(fk+1)<b, fk=fk+1; ffun=f.funs(fk); end
            inter=(2*[a b]-fends(fk)-fends(fk+1))/(fends(fk+1)-fends(fk));
            ffun=restrict(ffun,[max(inter(1),-1) min(inter(2),1)]);
        end
        if  gends(gk)==a && gends(gk+1)==b
            gk=gk+1; 
        else
            if gends(gk+1)<b, gk=gk+1; gfun=g.funs(gk); end
            inter=(2*[a b]-gends(gk)-gends(gk+1))/(gends(gk+1)-gends(gk));
            gfun=restrict(gfun,[max(inter(1),-1) min(inter(2),1)]);
        end
        foutfuns=[foutfuns ffun];  goutfuns=[goutfuns gfun];
    end
    
    foutimps = zeros(maxrows,length(ends));      
    [trash,findex,foutind]=intersect(fends,ends);
    foutimps(2:frows,foutind)=fimps(2:frows,findex);
    foutimps(1,:)=feval(f,ends);
    
    goutimps = zeros(maxrows,length(ends)); 
    [trash,gindex,goutind]=intersect(gends,ends);
    goutimps(2:grows,goutind)=gimps(2:grows,gindex);
    goutimps(1,:)=feval(g,ends);
    
    fout = set(f,'funs',foutfuns,'ends',ends,'imps',foutimps);
    gout = set(g,'funs',goutfuns,'ends',ends,'imps',goutimps);    

end
