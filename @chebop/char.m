function s = char(A)
% CHAR  Convert nonlinop to pretty-printed string.


if isempty(A)
    s = '   (empty chebop)';
else
    s = '   operating on chebfuns defined on:';
    s = char(s,['  ' char(A.dom)],' ');
    
    if ~isempty(A.op)
      % Need to treat the cell case differently from the an. fun. case
      if isa(A.op,'function_handle')
        opchar = char(A.op);
        s = char(s, '   representing the operator:',...
          ['     ' opchar ' = 0 ']);
        %                 Arrows in print
        %                 firstRPar = min(strfind(opchar,')'));
        %                 s = char(s, '   representing the operator:',...
        %                     ['     ' opchar(3:firstRPar-1) ' |-> ' opchar(firstRPar+1:end), ' ']);
      else
        s = char(s, '   representing the operator:');
        for funCounter =1:length(A.op)
          opchar = char(A.op{funCounter});
          s = char(s, ...
            ['     ' opchar ' = 0']);
          
          %                     Arrows in print
          %                     firstRPar = min(strfind(opchar,')'));
          %                     s = char(s, ...
          %                         ['     ' opchar(3:firstRPar-1) ' |-> ' opchar(firstRPar+1:end), ' ']);
        end
      end
    end
    s = char(s,' ');
    
    if ~isempty(A.lbc)
      if iscell(A.lbcshow) && length(A.lbcshow) > 1
        s = char(s, '   left boundary conditions:');
      else
         s = char(s, '   left boundary condition:');
      end
      t = bc2char(A.lbcshow);
      s = char(s,t{:});
    end
    
    if ~isempty(A.rbc)
      if iscell(A.rbcshow) && length(A.rbcshow) > 1
        s = char(s, '   right boundary conditions:');
      else
         s = char(s, '   right boundary condition:');
      end
      t = bc2char(A.rbcshow);
      s = char(s,t{:});
    end
    
end

end  % main function


function s = bc2char(b)

if ~iscell(b), b = {b}; end

s = repmat({'     '},1,length(b));
for k = 1:length(b)
  if isnumeric(b{k})  % number
    s{k} = [s{k}, num2str(b{k})];
  elseif ischar(b{k})  % string
    s{k} = [s{k}, b{k}];
  else  % function
    s{k} = [s{k},char(b{k}),' = 0'];
  end
end

end
