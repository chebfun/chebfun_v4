function A = setbc(A,bc)

% Set one or more of the boundary conditions. 

% Two options for bc: struct or mnemonic.

% bc struct has fields .left and .right. Each of these is a struct array
% with fields .op and .val; these define the operator on the solution and
% the value of the result at the appropriate boundary. Optional string
% values for .op are 'dirichlet' (maps to I) and 'neumann' (maps to D).

% bc mnemonic is a string or cell array {string,val}. If val is not given,
% it defaults to zero. If the string is 'dirichlet' or 'neumann', then the
% condition is applied at the left (1st order operator) or both sides (2nd
% order). If the string is 'periodic', you get m nonseparated conditions for
% difforder=m. 
 
I = eye(A.fundomain);
D = diff(A.fundomain);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First, turn a mnemonic call into a bc struct.
if ~isstruct(bc)
  % Apply a mnemonic rule to both ends to create the bc structure.
  % Input is 'type' or {'type',val}.
  if ischar(bc)
    type = bc;  val = 0;
  elseif iscell(bc) && length(bc)==2
    type = bc{1};  val = bc{2};
  else
    error('chebop:setbc:invalidtype','Unrecognized boundary condition mnemonic.')
  end
  bc = struct('left',struct([]),'right',struct([]));
  switch(lower(type))
    case 'dirichlet'
      if A.difforder > 0
        bc.left = struct('op',I,'val',val);
        if A.difforder > 1
          bc.right = struct('op',I,'val',val);
          if A.difforder > 2
            warning('chebop:setbc:order',...
              'Dirichlet may not be appropriate for differential order greater than 2.')
          end
        end
      end
    case 'neumann'
      if A.difforder > 0
        bc.left = struct('op',D,'val',val);
        if A.difforder > 1
          bc.right = struct('op',D,'val',val);
          if A.difforder > 2
            warning('chebop:setbc:order',...
              'Neumann may not be appropriate for differential order greater than 2.')
          end
        end
      end
    case 'periodic'
      B = I.varmat;
      for k = 1:A.difforder
        if rem(k,2)==1
          bc.left(end+1).op = B(1,:) - B(end,:);
          bc.left(end).val = 0;
        else
          bc.right(end+1).op = B(1,:) - B(end,:);
          bc.right(end).val = 0;
        end
        B = D.varmat*B;
      end
    otherwise
      error('chebop:setbc:invalidtype','Unrecognized boundary condition mnemonic.')
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now, assign the BC structure, mapping dirichlet and neumann
% strings into operators.
A.lbc = bc.left;  A.rbc = bc.right;
for k = length(A.lbc):-1:1  % backwards to allow deletions
  if isempty(A.lbc(k).op)
    A.lbc(k) = [];
  elseif isequal(A.lbc(k).op,'dirichlet')
    A.lbc(k).op = I;
  elseif isequal(A.lbc(k).op,'neumann')
    A.lbc(k).op = D;  
  end
end
for k = length(A.rbc):-1:1
  if isempty(A.rbc(k).op)
    A.rbc(k) = [];
  elseif isequal(A.rbc(k).op,'dirichlet')
    A.rbc(k).op = I;
  elseif isequal(A.rbc(k).op,'neumann')
    A.rbc(k).op = D;
  end
end

A.numbc = length(A.lbc) + length(A.rbc);
  
end
