function h  = torsion(f,g,h)

fp = diff(f); gp = diff(g); hp = diff(h); 
fpp = diff(f,2); gpp = diff(g,2); hpp = diff(h,2);
fppp = diff(f,3); gppp = diff(g,3); hppp = diff(h,3);

numx = gp.*hpp - hp.*gpp;
numy = -fp.*hpp + hp.*fpp;
numz = fp.*gpp - gp.*fpp;

num = numx.*fppp + numy.*gppp + numz.*hppp;
den = numx.^2 + numy.^2 + numz.^2;

h = num./den;