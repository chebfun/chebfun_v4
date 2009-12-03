function J = jacobian(F,u)
% JACOBIAN returns the Jacobian (or Frechet derivatives) of chebfuns.
%
% J = jacobian(F,u) returns the Jacobian of the chebfun F with respect to
% the chebfun u. Both F and u can be a quasimatrix.

% The Chebfun Team, 2009

% Obtain a list of all ID-s of the chebfun u (concat. the list if u is a
% quasimatrix
IDlist = cat(1,u.ID);

% Initialize the Jacobian, we will fill it up recursively
J = [];
for k = 1:numel(F)
    % Check whether a ID of F matches an ID of u. If not, we need to go one
    % step further back up in the evaluation trace. If we however have a
    % match, we have gotten to the "ground level", so we reset the Jacobian
    % to be the appropriate "semi-identity" chebop (i.e. a chebop that is
    % the identity chebop in one block and the zero chebop in other
    % blocks). The resetting of the Jacobians is done below in the function
    % jacReset.
    idx = find((F(k).ID(1) == IDlist(:,1)) == (F(k).ID(2) == IDlist(:,2)));
    if isempty(idx)              
        % Using subsref and feval for anons
        row = F(k).jacobian(u);
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
