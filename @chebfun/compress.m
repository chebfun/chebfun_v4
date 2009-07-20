function uout = compress(uin)
% Attempt to compress a chebfun using slitmaps.
% This was put here by NicH and is just for RodP to play with.

uout = uin;
for k = 1:uin.nfuns
    uout.funs(k) = compress(uin.funs(k));
end