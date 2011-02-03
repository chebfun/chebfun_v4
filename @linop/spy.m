function spy(A,c)
% SPY Visualize sparsity pattern.
%  SPY(S) plots the sparsity pattern of the matrix S.
%
%  SPY(S,C) uses the color given by C.
%
%  Example:
%   d = domain(-1,.5,1);
%   spy([diff(d) 0 ; 1 diff(d,2)],'m')

ends = A.fundomain.endsandbreaks;
de = ends(end)-ends(1);
LW = 'linewidth'; lw = 3;
C = 'color'; EC = 'EdgeColor';
if nargin < 2, c = 'b'; end

N = 3;
Amat = feval(A,N,'nobc');
ish = ishold;

if ~ish, cla, hold on, end

for j = 1:A.blocksize(1)
    for k = 1:A.blocksize(2)
        if ~A.iszero(j,k)
            NN = N*(numel(ends)-1);
            Ajk = Amat((j-1)*NN+(1:NN),(k-1)*NN+(1:NN));
            if isdiag(Ajk)
                plot(ends([end 1])+(k-1)*de,ends([1 end])-(j-1)*de,LW,lw,C,c);
            else
                for l = 1:numel(ends)-1
                    fill(ends([l+1 l l l+1])+(k-1)*de,-ends([l+1 l+1 l l])-(j-1)*de,c,EC,c);
                end
            end
        end
    end
end

set(gca,'yTicklabel',-str2num(get(gca,'yTicklabel')))

if ~ish, hold off, axis equal, axis tight, end

function tf = isdiag(A)
if ~any(A-diag(diag(A)))
    tf = true;
else
    tf = false;
end


