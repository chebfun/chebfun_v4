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
    
    if ~isempty(A.lbc)
        if isa(A.lbc,'function_handle')
            s = char(s, ' ', '   left boundary condition:',...
                ['     ' char(A.lbc) ' = 0']);
        else
                s = char(s, '   left boundary conditions:');
                for funCounter =1:length(A.lbc)
                    s = char(s, ...
                        ['     ' char(A.lbc{funCounter}) ' = 0']);
                end
        end
    end
    
    if ~isempty(A.rbc)
        if isa(A.rbc,'function_handle')
            s = char(s, ' ', '   right boundary condition:',...
                ['     ' char(A.rbc) ' = 0']);
        else
                s = char(s, '   right boundary conditions:');
                for funCounter =1:length(A.rbc)
                    s = char(s, ...
                        ['     ' char(A.rbc{funCounter}) ' = 0']);
                end
        end
    end
end
