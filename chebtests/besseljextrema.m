function pass = besseljextrema

% TAD

J2 = chebfun( @(x) besselj(2,x), [0 100] );
extrema = roots(diff(J2));

mma = [ 0
   3.054236928227140
   6.706133194158459
   9.969467823087596
  13.170370856016124
  16.347522318321783
  19.512912782488204
  22.671581772477424
  25.826037141785264
  28.977672772993678
  32.127327020443474
  35.275535050674691
  38.422654817555909
  41.568934936074314
  44.714553532819735
  47.859641607992096
  51.004297672458868
  54.148597242671237
  57.292599186428227
  60.436350075253564
  63.579887238154626
  66.723240947717301
  69.866436013337719
  73.009492961171489
  76.152428920759021
  79.295258300056489
  82.437993305560212
  85.580644347487763
  88.723220358610419
  91.865729047477643
  95.008177101267663
  98.150570349583958];

% Note: If tolerance is large, extrema at zero may be lost.
if length(extrema) < length(mma)
    mma = mma(2:end);
end
    
pass = norm(extrema-mma, Inf) < 1e-12*chebfunpref('eps')/eps;