function k = curvature(alpha)

if length(alpha) == 2
    f = alpha{1}; g = alpha{2};
    k = (diff(f).*diff(g,2) - diff(f,2).*diff(g))./...
        ((diff(f).^2 + diff(g).^2).^(1.5));
elseif length(alpha) == 3
    D = {diff(alpha{1}); diff(alpha{2}); diff(alpha{3})};
    DD = {diff(D{1}); diff(D{2}); diff(D{3})};
    DxDD = chebcross(D,DD);

    k  = sqrt((DxDD{1}.^2 + DxDD{2}.^2 + DxDD{3}.^2)./...
        (D{1}.^2+D{2}.^2+D{3}.^2).^3);
else
    error('Curvature is only defined for 2D or 3D curves');
end