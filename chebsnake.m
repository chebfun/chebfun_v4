function chebsnake(nodes,alpha)
%CHEBSNAKE   Chebfun snake game.
%   CHEBSNAKE() Feed the snake with more and
%   more interpolation nodes, but avoid that
%   it hits the boundary or itself!
%   Use the arrow keys to control the snake.
%   Any other key will quit the game.
%
%   CHEBSNAKE(NODES) allows one to change the
%   interpolation nodes from Chebyshev nodes
%   (NODES = 'cheby', default) to equispaced 
%   nodes ('equi'). The blue dots on the snake 
%   indicate the interpolated function values.
%
%   CHEBSNAKE(NODES,ALPHA) allows to change the
%   initial game speed by a factor ALPHA > 0,
%   ALPHA > 1 increases the game speed, 
%   ALPHA < 1 decreases it (default = 1).
%
%   To prevent you from neglecting your actual
%   work, the game speed increases with the total
%   number of achieved points...

    % get some constants right
    if nargin < 2, alpha = 1; end;
    if nargin > 0 && strcmp(nodes,'equi'), nodes = 0; else nodes = 1; end;
    LW = 'LineWidth'; lw = 2;
    res = 0.15; len = 5; dom = domain(-1,1); d = 1;
    food = @() res*(round((1.8*rand-.9)/res)+1i*round((1.8*rand-.9)/res));
    pause on

    % keyboard interaction
    figure('KeyPressFcn',@keypress);
    function keypress(~,evnt)
        dold = d;
        switch evnt.Key
            case 'leftarrow', d = -1;
            case 'rightarrow', d = 1;
            case 'downarrow', d = -1i;
            case 'uparrow', d = 1i;
            otherwise, d = 0; % quit
        end;
        if d == -dold; d = dold; end
    end

    while ~(d==0), % until quit
        d = 1;
        clf; 
        s = linspace(res*(1-len),0,len) + 1i*eps;
        hs1 = plot(s(1:end-1),'b-',LW,lw); hold on
        hs2 = plot(s(1:end-1),'bo',LW,lw);
        f = food();
        hf = plot(real(f),imag(f),'md','MarkerSize',10,'MarkerFaceColor','m');
        ht = plot(8,0);                     % dummy handle
        title('Control the snake with arrow keys. Quit with any other key.');
        axis([-1,1,-1,1]); shg; pause(.3);
        pts = 0;                            % points counter
        t = 1;                              % convex factor for nodes
        tic;
        while ~(d==0),                      % until game over or quit
            t = t + .2*alpha;
            if t > 1,
                t = 0; dr = res*d;
                s = [ s(2:end),s(end)+dr ];
                if length(s) < len+pts, s = [ s(2),s ]; end;
            end;
            y = (1-t)*s(1:end-1)+t*s(2:end);
            if nodes,
                c = chebfun(y);
            else
                c = polyfit(linspace(-1,1,length(y)),y,length(y)-1,dom);
            end;
            for k = 1:numel(hs1)
                if isnan(hs1(k)), continue, end
                delete(hs1(k));
            end
            hs1 = plot(c,'b-',LW,lw);
            delete(hs2);
            hs2 = plot(y,'bo',LW,lw);
            shg; pause(max(0.01,0.03-toc)/alpha); tic;

            % check if the snake hits itself or the boundary
            if max(abs([real(y(end)),imag(y(end))])) > 1 || ...
                   min(abs(y(end)-y(1:end-1))) < res/2,
                ht = plot(.8*scribble('game over'),'r',LW,lw); 
                shg; pause(1); break;
            end;
            if abs(y(end)-f) < res/2, % snake eats food ?
                pts = pts + 1; alpha = alpha * 1.003;
                title(['Points : ' num2str(pts)]);
                f = food();
                set(hf,'XData',real(f),'YData',imag(f));
            end;
        end;
        for k = 1:numel(ht)
            if isnan(ht(k)), continue, end
            delete(ht(k));
        end
    end;
    plot(.8*scribble('goodbye'),'r',LW,lw);
    shg; pause(1); close(gcf);
end % chebsnake()
