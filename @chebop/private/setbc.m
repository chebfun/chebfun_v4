function A = setbc(A,bc)

I = eye(A.fundomain);
D = diff(A.fundomain);

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

% Assign the BC structure, parsing dirichlet and neumann
% strings into operators.
A.lbc = bc.left;  A.rbc = bc.right;
for k = 1:length(A.lbc)
  if isequal(A.lbc(k).op,'dirichlet')
    A.lbc(k).op = I;
  elseif isequal(A.lbc(k).op,'neumann')
    A.lbc(k).op = D;
  end
end
for k = 1:length(A.rbc)
  if isequal(A.rbc(k).op,'dirichlet')
    A.rbc(k).op = I;
  elseif isequal(A.rbc(k).op,'neumann')
    A.rbc(k).op = D;
  end
end

  
  end
