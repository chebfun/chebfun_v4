function str = parent_remove(str)
% Remove unwanted parentheses

n = length(str);
if n < 2, return, end

idx3 = strfind(str,'+');
idx4 = strfind(str,'-');
if isempty(idx3) && isempty(idx4), return, end

idx1 = strfind(str,'(');
if isempty(idx1), return, end
idx2 = strfind(str,')');

x1 = zeros(1,n);
x2 = x1;
x3 = x1;

x1(idx1) = 1;
x2(idx2) = 1;
x3(idx3) = 1;

idx3 = [ idx3 idx4 ; 1+0*idx3 0*idx4];

y1 = cumsum(x1);
y2 = cumsum(x2);

z = y1-y2-x1;

if any(z < 0)
    error('CHEBFUN:parent_remove:unex_exp','Unexpected paranthesis expression.');
end

% c = {};
% for j = 1:length(str)
%     c{1,j} = j;
%     c{2,j} = str(j);
%     c{3,j} = z(j);
% end

pairs = zeros(sum(x1),3);
j = 1;
for k = idx1
    mask = find(z == z(k) & x2);
    mask = mask(mask>k);
    mask = mask(1);
    pairs(j,:) = [k mask z(k)];
    j = j+1;
end
[ignored idxp] = sort(pairs(:,3),'descend');
pairs = pairs(idxp,:);

pp = [idx3.' z(idx3(1,:)).'];
[ignored idxpp] = sort(pp(:,2),'descend');
pp = pp(idxpp,:);
% mm = max(pp(:,3));
% pp(pp(:,2)==mm,:) = [];
npp = size(pp,1);

for k = 1:npp
    
%     c = {};
%     for j = 1:length(str)
%         c{1,j} = j;
%         c{2,j} = str(j);
%     end
%     c

    ppk = pp(k,1);
    findl = find(pairs(:,1) == ppk+1,1);
    nextl = ppk+1;
    nextr = pairs(findl,2)+1;
    if pp(k,2) && ~isempty(nextl) && ~isempty(nextr)
        if nextr > n || any(strcmp(str(nextr),{'+',')'}))
            pairs(findl,:) = [];

            pairs(pairs(:,1)>=nextr,1) = pairs(pairs(:,1)>=nextr,1)-1;
            pairs(pairs(:,1)>=ppk,1) = pairs(pairs(:,1)>=ppk,1)-1;

            pairs(pairs(:,2)>=nextr,2) = pairs(pairs(:,2)>=nextr,2)-1;
            pairs(pairs(:,2)>=ppk,2) = pairs(pairs(:,2)>=ppk,2)-1;

            pp(pp(:,1)>=nextr) = pp(pp(:,1)>=nextr) - 1;
            pp(pp(:,1)>=ppk) = pp(pp(:,1)>=ppk) - 1;


            str(nextr-1) = [];
            str(nextl) = [];
            n = n-2;
        end
    end

    findr = find(pairs(:,2) == ppk-1,1);
    nextr = ppk-1;
    nextl = pairs(findr,1)-1;
    if ~isempty(nextl) && ~isempty(nextr)
        if nextl < 1 || any(strcmp(str(nextl),{'+','('}))
            pairs(findr,:) = [];

            pairs(pairs(:,1)>nextr,1) = pairs(pairs(:,1)>nextr,1)-1;
            pairs(pairs(:,1)>nextl,1) = pairs(pairs(:,1)>nextl,1)-1;

            pairs(pairs(:,2)>nextr,2) = pairs(pairs(:,2)>nextr,2)-1;
            pairs(pairs(:,2)>nextl,2) = pairs(pairs(:,2)>nextl,2)-1;

            pp(pp(:,1)>nextr) = pp(pp(:,1)>nextr) - 1;
            pp(pp(:,1)>nextl) = pp(pp(:,1)>nextl) - 1;

            str(nextr) = [];
            str(nextl+1) = [];
            n = n-2;
        end
    end
end

if ~isempty(pairs)
    [ignored indx] = sort(pairs(:,1),'ascend');
    pairs = pairs(indx,:);
    k = 1;
    while k < size(pairs,1)
        if pairs(k+1,1) == pairs(k,1)+1 && pairs(k+1,2) == pairs(k,2)-1
            str(pairs(k+1,2)) = []; str(pairs(k+1,1)) = [];
            pairs(pairs(:,2)>pairs(k+1,2),2) = pairs(pairs(:,2)>pairs(k+1,2),2)-1;
            pairs(pairs(:,1)>pairs(k+1,2),1) = pairs(pairs(:,1)>pairs(k+1,2),1)-1;
            pairs(pairs(:,2)>pairs(k+1,1),2) = pairs(pairs(:,2)>pairs(k+1,1),2)-1;
            pairs(pairs(:,1)>pairs(k+1,1),1) = pairs(pairs(:,1)>pairs(k+1,1),1)-1;
            pairs(k+1,:) = [];
        else
            k = k+1;
        end
    end
end 

pends = find(pairs(:,1) == 1);
if ~isempty(pends) && pairs(pends,2)==length(str)
    str([1 end]) = [];
end

