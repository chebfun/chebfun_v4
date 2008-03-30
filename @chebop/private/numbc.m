function nbc = numbc(A)

nbc = sum( arrayfun(@(s) ~isempty(s.op),A.lbc) );
nbc = nbc + sum( arrayfun(@(s) ~isempty(s.op),A.rbc) );