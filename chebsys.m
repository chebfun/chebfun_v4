function fout = chebsys(op, ends)
% G = CHEBSYS(F,ENDS)
% A chebfun constructor for systems. 
%
% Example 
%       myfun = @(x) { sin( length(x{2})*x{1} ), cos(10*x{2}) };
%       f = chebsys(myfun, [-1 0 1]);           
%       plot(f)
%

% This works in splitting off mode only.
if chebfunpref('splitting')
    warning('CHEBFUN:chebsys','switching off splitting mode')
    splitting off
end

% Global horizontal scale & initializations.
hs = max(abs(ends([1,end])));
nfuns = length(ends)-1;
hpy = zeros(1,nfuns); 
NN = 8*ones(1,nfuns); 

% allocate memory
scl.v = 0;
funs = repmat(fun, 1, nfuns);
x = cell(1,nfuns);

% search for happiness
maxn = chebfunpref('maxn');
while any(~hpy) && all(NN< maxn)
    
    % generate cheb points in each interval and place in a cell array.
    for i = 1:nfuns
        a = ends(i); b=ends(i+1);
        x{i} = .5*( (b-a)*sin(pi*(-NN(i):2:NN(i))/(2*NN(i)))'+b+a );
    end
    
    % get function values.
    v = op(x);
    
    % get vertical scale
    for k = 1:numel(v), scl.v = max(scl.v, norm(v{i},inf)); end
    
    % get funs and test for happiness
    for i = 1:nfuns
        scl.h = hs*2/diff(ends(i:i+1));    % fun horizontal scale
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

% Get values at breakpoints. 
imps = zeros(size(ends));
imps(1) = funs(1).vals(1);
for k = 2:nfuns
    imps(k) = funs(k).vals(1);
end
imps(end) = funs(end).vals(end);

% Get chebfun.
fout = set(chebfun,'funs',funs,'ends',ends,'imps',imps,'trans',0);