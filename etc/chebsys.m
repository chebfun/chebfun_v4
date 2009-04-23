function fout = chebsys(op, ends)
% G = CHEBSYS(F,ENDS)
% A symple chebfun constructor for systems. 
%
% Example 
%       myfun = @(x) { sin( length(x{2})*x{1} ), cos(10*x{2}) };
%       ends = {[-1 0],[1 3]};
%       f = chebsys(myfun, ends);           
%       plot(f{1}), hold on, plot(f{2})
%

% This works in splitting off mode only.
if chebfunpref('splitting')
    warning('CHEBFUN:chebsys','switching off splitting mode')
    splitting off
end

% Global horizontal scale & initializations.
nfuns = numel(ends);
hpy = zeros(1,nfuns); 
NN = 8*ones(1,nfuns); 

% initialization
sclv = zeros(nfuns,1);
funs = fun;
x = cell(1,nfuns);

% endpoints and horizontal scale
for i = 1:nfuns
    a(i) = ends{i}(1);
    b(i) = ends{i}(2);
    hs(i) = norm([a(i),b(i)],inf);
    sclh(i) = hs(i)*2/(b(i)-a(i));    % fun horizontal scale
end

% search for happiness
maxn = chebfunpref('maxdegree');
while any(~hpy) && all(NN< maxn)
    
    % generate cheb points in each interval and place in a cell array.
    for i = 1:nfuns
        x{i} = .5*((b(i)-a(i))*sin(pi*(-NN(i):2:NN(i))/(2*NN(i)))'+b(i)+a(i));
    end
    
    % get function values.
    v = op(x);
    
    % get vertical scale
    for i = 1:numel(v)
        sclv(i) = max(sclv(i), norm(v{i},inf));
    end

    % get funs and test for happiness
    for i = 1:nfuns
        scl.v = sclv(i); scl.h = sclh(i); % set fun scales (horizontal and vertical)
        fn = set(fun(v{i}),'scl',scl);        
        funs(i) = simplify(fn);        

        hpy(i) = length(funs(i))<NN(i);
        if ~hpy(i)
            NN(i) = 2*NN(i);
        else
            NN(i) = 2^ceil(log2(length(funs(i))-1));
        end
    end   

end 

if any(~hpy)
    warning('CHEBFUN:chebsys',['Function not resolved, using ',num2str(maxn),' pts.' ...
                               ' Have you tried ''splitting on''?']);
end

% set chebfuns
fout = cell(1,nfuns);
for i = 1:nfuns
    fout{i} = set(chebfun,'funs',funs(i),'ends',[a(i) b(i)],'imps', ...
        [funs(i).vals(1) funs(i).vals(end)],'trans',0);
end