function J = jacobian(F,u)
% JACOBIAN returns the Jacobian of chebfuns.
%
% J = jacobian(Q) where Q is a quasimatrix consisting of m chebfuns of
% n variables returns the Jacobian of Q consisting of m x n block
% definitions.
%
% J = jacobian(y1,y2,...,ym) where the y-s are chebfuns of n variables
% returns the joint Jacobian of the functions consisting of m x n block
% definitions.
%
IDlist = cat(1,u.ID);
J = [];
for k = 1:numel(F)
    idx = find((F(k).ID(1) == IDlist(:,1)) == (F(k).ID(2) == IDlist(:,2)));
    if isempty(idx)              
        % Using subsref and feval
        row = F(k).jacobian(u);
        % Old method 
%         row = F(k).jacobian(u);
    else  
        row = jacReset(domain(F(k)),numel(u),idx);
    end
    if isempty(row)
        row = zeros(domain(F(k)));
    end
    J = [ J; row ];
end

function J =  jacReset(d,m,k)
I = eye(d);
Z = zeros(d);
J = [];
for j = 1:k-1
    J = [ J, Z ];
end
J = [ J, I ];
for j = k+1:m
    J = [ J, Z ];
end
