function [funs,ends,scl,sing] = auto(op,ends,scl)

global htol 

sing = [true true];

if nargin <3
    scl.h = max(abs(ends)); scl.v = 0;
end

htol = 1e-14*scl.h;

% -------------------------------------------------------------------------

if ~chebfunpref('splitting')
     [funs,hpy] = getfun(op,ends,2^16,scl);
     if ~hpy
        warning('CHEBFUN:auto',['Function not resolved, using 2^16 pts.' ...
                 ' Have you tried ''splitting on''?']);
     end
     return;
end

% ------------------------------------------------------------------------

maxn = chebfunpref('maxn');

[funs,hpy,scl] = getfun(op,ends,maxn,scl);
sad = ~hpy;

while any(sad)
    
    i = find(sad);
    for i = i(end:-1:1)
    
        isedge = false;
        a=ends(i); b=ends(i+1);
        edge=detectedge(op,a,b,scl.h,scl.v);
  
        if isempty(edge)
            edge=0.5*(a+b);
        elseif (edge-a)<=htol
            edge=a+(b-a)/100; 
        elseif (b-edge)<=htol
            edge=b-(b-a)/100;
        else
            isedge = true;
        end                

        % ------------------------------------
        [child1, hpy1, scl] = getfun(op, [a, edge], maxn, scl);
        [child2, hpy2, scl] = getfun(op, [edge, b], maxn, scl);
        funs = [funs(1:i-1) child1 child2 funs(i+1:end)];
        ends = [ends(1:i) edge ends(i+1:end)];
        sad  = [sad(1:i-1) not(hpy1) not(hpy2) sad(i+1:end)];
        sing = [sing(1:i) isedge sing(i+1:end)];
        
    end
    
    %% -------- Stop? check the length --------
    lenf=0;
    for i=1:numel(funs)
        lenf=lenf+length(funs(i));
    end
    if lenf >6e+4
        warning('CHEBFUN:auto',['Chebfun representation may not be accurate:' ...
                'using ' int2str(lenf) ' points'])
        return
    end
    %% ----------------------------------------
end

funs=set(funs,'scl.v',scl.v);