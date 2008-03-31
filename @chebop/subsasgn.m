function A = subsasgn(A,s,B)

valid = false;
switch s(1).type
  case '.'
    name = s(1).subs;
    switch name
 
      case {'lbc','rbc'}           % DIRECT BC ASSIGNMENT
        if length(s)==1  % no index specified, so clear old ones
          A.(name) = struct([]);
          idx = 1;
          valid = true;
        elseif isequal(s(2).type,'()') && length(s(2).subs)==1
          idx = s(2).subs{1};
          valid = true;
        end
        if valid 
          % B gives us (maybe) the replacement row and the RHS value
          if isempty(B)
            A.(name)(idx).op = [];  
            A.(name)(idx).val = [];
          elseif isnumeric(B)
            % Dirichlet case
            A.(name)(idx).op = chebop_eye;
            A.(name)(idx).val = B;
          elseif iscell(B) && ...
              (isa(B{1},'chebop') || isa(B{1},'varmat')) && isnumeric(B{2})
            % General operator
            A.(name)(idx).op = B{1};
            A.(name)(idx).val = B{2};
           else
            valid = false;
          end
        end

      case 'bc'                    % BC MNEMONICS
        if ischar(B)
          I = chebop_eye(A.fundomain);
          D = chebop_diff(A.fundomain);
          valid = true;
          switch(lower(B))
            case 'dirichlet'
              if A.difforder > 0
                A.lbc = struct('op',I,'val',0);
                if A.difforder > 1
                  A.rbc = struct('op',I,'val',0);
                  if A.difforder > 2
                    warning('chebop:subsasgn:order',...
                      'Dirichlet may not be appropriate for differential order greater than 2.')
                  end
                end
              end
            case 'neumann'
              if A.difforder > 0
                A.lbc = struct('op',D,'val',0);
                if A.difforder > 1
                  A.rbc = struct('op',D,'val',0);
                  if A.difforder > 2
                    warning('chebop:subsasgn:order',...
                      'Neumann may not be appropriate for differential order greater than 2.')
                  end
                end
              end
            case 'periodic'
              A.lbc = struct([]);  A.rbc = struct([]);
              B = I.varmat;
              for k = 1:A.difforder
                if rem(k,2)==1
                  A.lbc(end+1).op = B(1,:) - B(end,:);
                  A.lbc(end).val = 0;                  
                else
                  A.rbc(end+1).op = B(1,:) - B(end,:);
                  A.rbc(end).val = 0;                  
                end
                B = D.varmat*B;
              end
            otherwise 
              valid = false;
          end
        end
                  
      case 'scale'                 % SCALE
        A.scale = B;
        valid = true;
%      case 'fundomain'             % FUNDOMAIN
%        A.fundomain = B;
%        valid = true;
    end
end

if ~valid
  error('chebop:subsasgn:invalid','Invalid assignment syntax.')
elseif ~isequal(s(1).subs,'scale')
  A.ID = newIDnum();   % stored matrices have become invalid
end
