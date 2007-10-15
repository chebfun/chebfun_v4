function out = isnaf(f)

if f.n > 128
    out = 1;
else
    out = 0;
end