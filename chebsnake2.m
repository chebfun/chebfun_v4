function chebsnake2(f,nodes,alfa)
%CHEBSNAKE2   Chebfun2 snake game on a surface.
%   This is the Chebfun2 analogue of Chebfun's chebsnake.
% 
%   CHEBSNAKE2 Feed the snake with more and more 1D interpolation nodes, but
%   avoid that it hits the boundary or itself! Use the arrow keys to
%   control the snake. Any other key will quit the game.
%
%   CHEBSNAKE2(F) allows one to specify the chebfun2 object F on which 
%   snake will live (default is chebfun2(@(x,y) 2-x.^2 - y.^2)).
%
%   CHEBSNAKE2(F,NODES) allows one to change the interpolation nodes and type. The
%   default type 'cheby' is polynomial interpolation in Chebyshev points.
%   Other types are polynomial interpolation in equispaced points ('equi')
%   and Floater-Hormann rational interpolation in equispaced points ('fh').
%   The blue dots on the snake indicate the interpolated function values.
%
%   CHEBSNAKE2(F,NODES,ALFA) allows to change the initial game speed by a
%   factor alfa > 0, alfa > 1 increases the game speed, alfa < 1
%   decreases it (default = 1).
%
%   To prevent you from neglecting your actual work, the game speed
%   increases with the total number of achieved points.
%
% See also CHEBSNAKE.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

    % get some constants right
    if ( nargin < 3 )
        alfa = 1; 
    end
    if ( nargin < 2 )
        nodes = 1;
    end
    if ( (nargin > 0 && ~isa(f,'chebfun2')) || nargin == 0 )
        f = chebfun2(@(x,y) 2-x.^2 - y.^2);
    end
    if ( nargin > 1 && strcmp(nodes,'equi')) 
        nodes = 0; 
    elseif ( nargin > 1 && strcmp(nodes,'fh'))
        nodes = 2;  
    else
        nodes = 1; 
    end     

    LW = 'LineWidth'; lw = 2;
    MS = 'MarkerSize'; ms = 10;
    res = 0.15; len = 5; dom = domain(-1,1); d = 1;
    food = @() res*(round((1.8*rand-.9)/res)+1i*round((1.8*rand-.9)/res));
    pause on
    
    minf = min2(f);
    if ( minf < 0 )
        f = f + abs(min2(f));
    end
    maxf = max2(f);
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

    alfa0 = alfa;                     % set base level for alfa
    fails = 0;                         
        hold on, view(0,4) % fail counter (no food eaten)
    failmax = 5;                        % number of consecutive fails before quit
    while ~(d==0), % until quit
        d = 1;
        clf; 
        plot(f)
        colormap hsv, alpha(.2)
        hold on
        s = linspace(res*(1-len),0,len) + 1i*eps;
        hs1 = plot3(real(s(1:end-1)),imag(s(1:end-1)),f(real(s(1:end-1)),imag(s(1:end-1))),'b-',LW,lw); hold on
        hs2 = plot3(real(s(1:end-1)),imag(s(1:end-1)),f(real(s(1:end-1)),imag(s(1:end-1))),'bo',LW,lw);
        hs1s = plot(s(1:end-1),'k-',LW,lw/2);
        hs2s = plot(s(1:end-1),'ko',LW,lw/2);
        fd = food();
        hf = plot3(real(fd),imag(fd),f(real(fd),imag(fd)),'md',MS,ms,'MarkerFaceColor','m');
        hfs = plot(real(fd),imag(fd),'kd',MS,ms/2,'MarkerFaceColor','k');
        ht = plot(8,0);                     % dummy handle
        title('Control the snake with arrow keys. Quit with any other key.');
        axis([-1,1,-1,1,0,maxf]); shg;
        pts = 0;                            % points counter
        alfa = alfa0;                     % reset alfa (speed)
        t = 1;                              % convex factor for nodes
        tic;
        while ~(d==0),                      % until game over or quit
            t = t + .51*alfa;
            if t > 1,
                t = 0; dr = res*d;
                s = [ s(2:end),s(end)+dr ];
                if length(s) < len+pts, s = [ s(2),s ]; end
            end
            y = (1-t)*s(1:end-1)+t*s(2:end);
            if nodes==1,
                c = chebfun(y);
                c = c(chebpts(5*length(y)));
            elseif nodes==2,
                fhd = min(ceil(0.4*sqrt(length(y))),4);
                c = bary(linspace(-1,1,5*length(y)),y,linspace(-1,1,...
                    length(y)),weights(length(y)-1,fhd));
            elseif nodes==0
                c = polyfit(linspace(-1,1,length(y)),y,length(y)-1,dom);
            end
            for k = 1:numel(hs1)
                if isnan(hs1(k)), continue, end
                delete(hs1(k));
            end
            hs1 = plot3(real(c),imag(c),f(real(c),imag(c)),'b-',LW,lw);
            delete(hs2,hs1s,hs2s);
            hs2 = plot3(real(y),imag(y),f(real(y),imag(y)),'bo',LW,lw);
            hs1s = plot(c,'k-',LW,lw/2);
            hs2s = plot(y,'k.',LW,lw/2);
            shg; 
            %pause(max(0.01,0.03-toc)/alfa); 
            tic;

            % check if the snake hits itself or the boundary
            if max(abs([real(y(end)),imag(y(end))])) > 1 || ...
                   min(abs(y(end)-y(1:end-1))) < res/2,
                ht = plot(.8*scribble('game over'),'r',LW,lw); 
                shg; pause(1); 
                if pts == 0, fails = fails + 1; end
                if fails > failmax, d = 0; end
                break
            end
            if abs(y(end)-fd) < res/2, % snake eats food ?
                pts = pts + 1; alfa = alfa * 1.003; fails = 0;
                title(['Points : ' num2str(pts)]);
                fd = food();
                set(hf,'XData',real(fd),'YData',imag(fd),'ZData',f(real(fd),imag(fd)));
                set(hfs,'XData',real(fd),'YData',imag(fd));
            end
        end
        for k = 1:numel(ht)
            if isnan(ht(k)), continue, end
            delete(ht(k));
        end
    end;
    plot(.8*scribble('goodbye'),'r',LW,lw);
    shg; pause(1); close(gcf);

    function w = weights(n,fhd) % weights for Floater-Hormann interpolation
        w = zeros(1,n+1);
        for l = 0:n
            ji = max(l-fhd,0);
            jf = min(l,n-fhd);
            sumcoeff = zeros(jf-ji+1,1);
            for i=ji:jf
                sumcoeff(i-ji+1) = nchoosek(fhd,l-i);
            end
            w(l+1) = (-1)^(l-fhd)*sum(sumcoeff);
        end
    end

end % chebsnake()