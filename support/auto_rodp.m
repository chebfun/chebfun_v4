function [funs,ends] = auto(op,ends)

if getpref('chebfun_defaults','splitting')==0
    funs{1} = fixedgrow(op,ends);
    return;
end

% ---------------------------------------------------------------------
values.vs = 0; values.hs = max(abs(ends)); values.table = [];
mininterval=1e-13*values.hs;
ep_ends=eps*values.hs;
% ---------------------------------------------------------------------
[funs{1},hpy,values] = grow_rodp(op,ends,values);
v = get(funs{1},'val');
values.vs = max(values.vs,max(abs(v)));
sad = not(hpy);
% -------------------------------------------------------------------------
while any(sad)
    i = find(sad);
    for i = i(end:-1:1)
        
        %% --- Find where error is maximum ----
        fi=funs{i}; 
        a=ends(i); b=ends(i+1);
        N=-length(fi);
        xch=cheb(N);
        xm=0.5*(xch(2:end)+xch(1:end-1));
        xmb=0.5*((b-a)*xm+b+a);
        [maxerr,ind]=max(abs(fi(xm)-op(xmb)));
        if ind<N-2, aedge=xmb(ind+2); else aedge=a; end
        if ind>3,   bedge=xmb(ind-2); else bedge=b; end
        edge=detectedge(op,aedge,bedge,values.hs);
        %edge=[];
        if isempty(edge)
            edge=xmb(ind);
            %edge=(a+b)/2;
        elseif (edge-a)<=mininterval
            edge=a+(b-a)/100; 
        elseif (b-edge)<=mininterval 
            edge=b-(b-a)/100;
        end
        % ------------------------------------
        [child1,hpy1,values] = grow_rodp(op,[a+ep_ends,edge-ep_ends],values); 
        [child2,hpy2,values] = grow_rodp(op,[edge+ep_ends,b-ep_ends],values);
%         funs = [funs(1:i-1);{child1};{child2};funs(i+1:end)];
%         ends = [ends(1:i) edge ends(i+1:end)];
%         sad  = [sad(1:i-1) not(hpy1) not(hpy2) sad(i+1:end)];      
        child1={child1};
        child2={child2};
        %% --- Merging Step -------------------------
           edgecp=edge;
           if hpy1 && (i > 1) && not(sad(i-1))
                [f,merged,values] = grow_rodp(op,[ends(i-1)+ep_ends,edge-ep_ends],values);
                if merged
                    funs{i-1} = f; child1 = {};
                    ends(i) = edge; edge=[];
                    hpy1 = [];
                end
            end
            if hpy2 && (i < length(sad)) && not(sad(i+1))
                [f,merged,values] = grow(op,[edgecp+ep_ends,ends(i+2)-ep_ends],values);
                if merged
                    funs{i+1} = f; child2 = {};
                     if isempty(edge)
                        ends(i+1) = [];
                    else
                        ends(i+1) = edge; edge=[];
                    end
                    hpy2 = [];
                end
            end
            funs = [funs(1:i-1);child1;child2;funs(i+1:end)];
            ends = [ends(1:i) edge ends(i+1:end)];
            sad  = [sad(1:i-1) not(hpy1) not(hpy2) sad(i+1:end)];
           % for ii = 1:length(funs)
           %     v = get(funs{ii},'val');
           %     values.vs = max(values.vs,max(abs(v)));
           % end
        %%----------------------------    
        
    end
end