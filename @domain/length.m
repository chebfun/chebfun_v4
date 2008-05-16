function l = length(d)
% LENGTH  Length of a domain's interval.
% LENGTH(D) returns the difference between endpoints, D(end)-D(1).

if isempty(d)
  l = 0;
else
  l = d.ends(end)-d.ends(1);
end

end