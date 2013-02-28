function vals = fast_feval(f,x,y,varargin)
% Evaluate a fun2 at Chebyshev points.
% varargin{1} = 1 means fast in x,
% varargin{1} = 2 means fast in y,
% varargin{1} = [] means fast in both.

fC = f.C; fR=f.R; fU=f.U; rk=length(fU);
if isempty(varargin), varargin{1}=0; end
% check for zero function.
if norm(fC) < eps || norm(fR)<eps || norm(fU)<eps
    if varargin{1} == 0
        vals = zeros(x,y);
    elseif varargin{1} == 1
        vals = zeros(length(y),x);
    elseif varargin{1} == 2
        vals = zeros(y,length(x));
    end
    return;
end


pref2=chebfun2pref;

if varargin{1}==0
    % fast in both. x and y are both integers.
    
    % Fast evaluation of columns.
    fC = vectorisedProlong(fC,y,rk);
    % Fast evaluation of Rows.
    fR = vectorisedProlong(fR.',x,rk).';
    
    vals = fC* (diag(1./fU) * fR);
    
elseif varargin{1}==1
    % fast in x. Fast evaluation of Rows.
    r = vectorisedProlong(fR.',x,rk).';
    if pref2.mode
        c = fC(y,:);
    else
         c = zeros(length(y),size(fC,2));
        d = getdomain(f);
        for jj=1:size(fC,2)
            tmp = fun(fC(:,jj),[d(3) d(4)]);
            c(:,jj) = feval(tmp,y);
        end
    end
    vals = c* (diag(1./fU) * r);
elseif varargin{1}==2
    % fast in y.
    c = vectorisedProlong(fC,y,rk);
    if pref2.mode
        r = fR(:,x);
    else
        r = zeros(size(fR,1),length(x));
        d = getdomain(f);
        for jj=1:size(fR,1)
            tmp = fun(fR(jj,:),[d(1) d(2)]);
            r(jj,:) = feval(tmp,x);
        end
    end
    if ~(size(r,1) == rk), r = r.';end
    vals = c* (diag(1./fU) * r);
else
    error('FUN2:Fast_feval:mode','fast_feval is in unrecognised mode');
end

end

function vals = vectorisedProlong(C,len,rk)
lc = length(C);
pref2 = chebfun2pref;
if pref2.mode
    C=reshape(C.vals(:),lc,rk);
end

if lc>=len
    % extract out the right values.
    idx = linspace(1,lc,len);
    vals = C(idx,:);
    %         vals=vals(1:len,:);
else
    vals = flipud(chebfft(C));
    vals(lc+1:len,:) = 0;
    vals = chebifft(flipud(vals));
end  %prolong

end