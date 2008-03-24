function A = addconstraint(A,idx,varargin)

% ADDCONSTRAINT(A,I)
% ADDCONSTRAINT(A,I,VAL)
% ADDCONSTRAINT(A,I,ROW)
% ADDCONSTRAINT(A,I,ROW,VAL)
% ADDCONSTRAINT(A,'first'[,VAL])
% ADDCONSTRAINT(A,'last'[,VAL])
% ADDCONSTRAINT(A,'ends'[,VAL])

len = length(A.constraint);
A = setconstraint(len+1,A,idx,varargin{:});
