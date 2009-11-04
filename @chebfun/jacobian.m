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
% NOTE: In order to be able to calculate the Jacobians, the variables in
% the chebfuns must be updated using the jacvar function, e.g. [x1 x2]=
% jacvar(x1, x2).
% global jacCalls
% nargin
% jacCalls = jacCalls +1
% u
IDlist = cat(1,u.ID);
J = [];
for k = 1:numel(F)
    idx = find((F(k).ID(1) == IDlist(:,1)) == (F(k).ID(2) == IDlist(:,2)));
    if isempty(idx)
        
        % New method
%         Fkjac = F(k).jacobian;
%         w = Fkjac.workspace;
%         Fkjac_fun = eval(Fkjac.function);
%         row = Fkjac_fun(u);
        
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
end
