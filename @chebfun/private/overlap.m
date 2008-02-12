function [fout,gout] = overlap(f,g)
% OVERLAP chebfuns
%
% [fout,gout] = OVERLAP(f,g) returns two chebfuns such that
% fout.ends==gout.ends 
% 
% This function replaces support/overlap.m

% Rodrigo Platte, 2008

fends=f.ends; gends=g.ends;
frows=size(f.imps,1); grows=size(g.imps,1); maxrows=max(frows,grows);
fimps=f.imps; gimps=g.imps;

if length(fends)==length(gends) && all(fends==gends)

    fout=f; gout=g;    
    fout.imps=[fimps; zeros(maxrows-frows,length(fends))];
    gout.imps=[gimps; zeros(maxrows-grows,length(fends))];    

else
    
%%%%%%%%    
% to overlap two functions defined in different domains, uncomment this:
%%%%%%%%
%     if fends(end)<=gends(1) || gends(end)<=fends(1)
%         error('intersection of domains is empty')
%     end    
%     a=max(fends(1),gends(1)); b=min(fends(end), gends(end));    
%     ends=union(fends,gends); ends=ends(a<=ends & b>=ends);
    
    if any(domain(f)~=domain(g))
       error('domain(f) ~= domain(g)')
    end
    ends=union(fends,gends);
    
    fk=1; gk=1;
    foutfuns=cell(length(ends)-1,1);
    goutfuns=foutfuns;

    for k=1:length(ends)-1
        a=ends(k); b=ends(k+1);
        gfun=g.funs{gk}; ffun=f.funs{fk};
        if fends(fk)==a && fends(fk+1)==b
           fk=fk+1;
        else
            if fends(fk+1)<b, fk=fk+1; ffun=f.funs{fk}; end
            ffun=restrict(ffun,(2*[a b]-fends(fk)-fends(fk+1))/(fends(fk+1)-fends(fk)));
        end
        if  gends(gk)==a && gends(gk+1)==b
            gk=gk+1; 
        else
            if gends(gk+1)<b, gk=gk+1; gfun=g.funs{gk}; end
            gfun=restrict(gfun,(2*[a b]-gends(gk)-gends(gk+1))/(gends(gk+1)-gends(gk)));
        end
        foutfuns{k}=ffun;  goutfuns{k}=gfun;
    end
    
    foutimps = zeros(maxrows,length(ends));      
    [trash,find,foutind]=intersect(fends,ends);
    foutimps(1:frows,foutind)=fimps(:,find);
    
    goutimps = zeros(maxrows,length(ends)); 
    [trash,gind,goutind]=intersect(gends,ends);
    goutimps(1:grows,goutind)=gimps(:,gind);
    
    fout=chebfun(foutfuns,ends); fout.imps=foutimps;
    gout=chebfun(goutfuns,ends); gout.imps=goutimps;

end
