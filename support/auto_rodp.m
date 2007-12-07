function [funs,ends] = auto(op,ends)

if getpref('chebfun_defaults','splitting')==0
    funs{1} = fixedgrow(op,ends);
    return;
end

% ---------------------------------------------------------------------
values.vs = 0; values.hs = max(abs(ends)); values.table = [];
mininterval=1e-14*values.hs;
% ---------------------------------------------------------------------
[funs{1},hpy,values] = grow(op,ends,values);
v = get(funs{1},'val');
values.vs = max(values.vs,max(abs(v)));
sad = not(hpy);
% -------------------------------------------------------------------------
while any(sad)
    i = find(sad);
    for i = i(end:-1:1)
        a=ends(i); b=ends(i+1);
        edge=detectedge(op,a,b,values.hs);
        % ------------------------------------
        if (edge-a)<=mininterval
            edge=a+(b-a)/5; 
        elseif (b-edge)<=mininterval 
            edge=b-(b-a)/5;
        end
    % ------------------------------------

        [child1,hpy1,values] = grow_rodp(op,[a+eps*values.hs edge-eps*values.hs],values); 
        [child2,hpy2,values] = grow_rodp(op,[edge+eps*values.hs, b-eps*values.hs],values);
        funs = [funs(1:i-1);{child1};{child2};funs(i+1:end)];
        ends = [ends(1:i) edge ends(i+1:end)];
        sad  = [sad(1:i-1) not(hpy1) not(hpy2) sad(i+1:end)];
    end
end
