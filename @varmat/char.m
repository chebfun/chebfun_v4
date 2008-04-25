function s = char(V)

if isempty(V.defn)
  s = '   []';
else
  s1 = '   with n=6 realization:';
  s2 = num2str(feval(V,6),'  %8.4f');
  space = ' ';
  s2 = [ repmat(space,size(s2,1),5) s2 ];
  s = char(s1,'',s2);
end
  