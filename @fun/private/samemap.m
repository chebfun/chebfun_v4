function t = samemap(g1,g2)

t = strcmp(g1.map.name,g2.map.name) && isequal(g1.map.par,g2.map.par);

