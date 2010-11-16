function pref = chebopdefaults
% Default chebfunprefs for chebops

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

pref = chebfunpref;
pref.splitting = false;
pref.sampletest = false;
pref.resampling = true;
pref.exps = [inf inf];
pref.blowup = 0;
pref.vecwarn = 0;
pref.vectorcheck = 0;
pref.chebkind = 2;

