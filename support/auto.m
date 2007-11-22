function [funs,ends] = auto(op,ends)


if ~getpref('chebfun_defaults','splitting')
    funs{1} = fixedgrow(op,ends);
    return;
end

% Debugging controls: ---------------------------------------------------
deb1 = 0; % <-  show the iteration level
deb2 = 0; % <-  plot advance of the construction (blue = happy; red = sad)
% ---------------------------------------------------------------------
% Minimum allowed interval length
minlength = 1e-14;
vs = 0; hs = max(abs(ends));
% ---------------------------------------------------------------------
[funs{1},hpy] = grow(op,ends,vs,hs);
v = get(funs{1},'val');
vs = max(vs,max(abs(v)));
sad = not(hpy);
count = 0;
% -------------------------------------------------------------------------
if deb2
    for i = 1:length(sad)
        if sad(i)
            plot(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'r');
        else
            plot(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'b');
        end
        hold on;
    end
    set(gca,'xgrid','on','xtick',ends,'fontsize',8)
    drawnow;
end
% -------------------------------------------------------------------------
while any(sad)
    count = count + 1;
    % ---------------------------------------------------------------------    
    if deb1
        disp(['level -> ',num2str(count)]);
        tic
    end
    % ---------------------------------------------------------------------
    i = find(sad);
    for i = i(end:-1:1)
        mdpt = mean(ends(i:i+1)); 
        mdptcopy = mdpt;
        if diff(ends(i:i+1)) < minlength
            ends(i) = mdpt; ends(i+1) = [];
            mdpt = [];
            child1 = {}; hpy1 = [];
            child2 = {}; hpy2 = [];
        else
            [child1,hpy1] = grow(op,[ends(i) mdpt],vs,hs);            
            [child2,hpy2] = grow(op,[mdpt, ends(i+1)],vs,hs);
            child1 = {child1};
            child2 = {child2};

            if hpy1 && (i > 1) && not(sad(i-1))
                [f,merged] = grow(op,[ends(i-1),mdpt],vs,hs);
                if merged
                    funs{i-1} = f; child1 = {};
                    ends(i) = mdpt; mdpt = [];
                    hpy1 = [];
                end
            end
            if hpy2 && (i < length(sad)) && not(sad(i+1))
                [f,merged] = grow(op,[mdptcopy,ends(i+2)],vs,hs);
                if merged
                    funs{i+1} = f; child2 = {};
                     if isempty(mdpt)
                        ends(i+1) = [];
                    else
                        ends(i+1) = mdpt; mdpt = [];
                    end
                    hpy2 = [];
                end
            end
        end
        funs = [funs(1:i-1);child1;child2;funs(i+1:end)];
        ends = [ends(1:i) mdpt ends(i+1:end)];
        sad  = [sad(1:i-1) not(hpy1) not(hpy2) sad(i+1:end)];
        for ii = 1:length(funs)
            v = get(funs{ii},'val');
            vs = max(vs,max(abs(v)));
        end
        % -----------------------------------------------------------------        
        if deb2
            hold off;
            for i = 1:length(sad)
                if sad(i)
                    plot(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'r');
                else
                    plot(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'b');
                end
                hold on;
            end
            set(gca,'xgrid','on','xtick',ends,'fontsize',8)
            drawnow;
            hold off;
        end
        % -----------------------------------------------------------------
    end
    % ---------------------------------------------------------------------
    % if deb1, toc, end
    % ---------------------------------------------------------------------
end
if deb1
   % display(length(table));
end
