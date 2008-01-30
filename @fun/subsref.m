function varargout = subsref(f,S)
% SUBSREF	Subscripted reference
% F(X) evaluates the fun F at the values given in X.  The case where X
% is a fun results in function composition.
%
% F(I,J), F a matrix whose columns are funs, evaluates the J-th
% fun at the value I.  F(I,:) evaluates all funs in F at I and
% F(:,J) returns the J-th fun of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
switch S(1).type
    case '.'
        if isempty(f)
            varargout = {};
        else
            switch S(1).subs
                case 'val'
                    varargout = {f.val};
                case 'n'
                    varargout = {f.n};
                otherwise
                    error(['??? Reference to non-existent field ' index(1).subs '.']);
            end
        end
    case '()'
      if isa(S.subs{1},'fun')
        F=auto(@comp,f,S.subs{1});
      elseif f.td
        S.subs{1}=S.subs{1}(:);
        S.subs{2}=S.subs{2}(:);
        F=bary2([S.subs{1} S.subs{2}],f.val); %????????
      elseif ~f.trans
        if length(S.subs)==1
          F=bary(S.subs{1},f.val);
          F=reshape(F,size(S.subs{1}));
        elseif strcmp(S.subs{1},':')
          F=f;
          F.val=f.val(:,S.subs{2});
        elseif strcmp(S.subs{2},':')
          n=size(f.val,2);
          for i=1:n
            F(:,i)=bary(S.subs{1},f.val(:,i));
          end
        else
          s=S.subs{2};
          for j=1:length(s)
            F(:,j)=bary(S.subs{1},f.val(:,s(j)));
          end
        end
      else
        if length(S.subs)==1
          F=bary(S.subs{1},f.val);
        elseif strcmp(S.subs{2},':')
          F=f;
          F.val=f.val(S.subs{1},:);
        elseif strcmp(S.subs{1},':')
          m=size(f.val,1);
          for i=1:m
            F(:,i)=bary(S.subs{2},f.val(i,:));
          end
        else
          s=S.subs{1};
          for i=1:length(s)
            F(i,:)=bary(S.subs{2},f.val(s(i),:))';
          end
        end
      end
      varargout = {F};
end
