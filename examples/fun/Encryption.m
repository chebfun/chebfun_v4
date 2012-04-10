%% Encryption of a message with SCRIBBLE
% Nick Trefethen, March 2010 

%%
% (Chebfun example fun/Encryption.m)

%%
% SCRIBBLE produces piecewise linear complex chebfun whose
% plots look like words, like this:
message = scribble('This is the message');
LW = 'linewidth';
plot(message,LW,2.0), axis equal

%%
% Here's another string:
key = scribble('Aardvarks eat ants');
plot(key,'r',LW,2.0), axis equal

%%
% Now if we plot the sum of the two, we get nonsense:
encrypted = message + key;
plot(encrypted,'m',LW,2.0), axis equal

%%
% So we've invented a new encryption scheme!  For of course
% the original message can be recovered by subtracting off
% that key:
message2 = encrypted - key;
plot(message2,LW,2.0), axis equal

%%
% So long as we're investigating the world's most expensive
% and least secure method of encryption, we might as well
% tangle up the text in the complex plane a bit too.  I'll
% bet you can't read this:
scrambled = exp(2i*(encrypted+1));
plot(scrambled,'g',LW,2.0), axis equal

%%
% But we can get the message back with a little unscramble:
message3 = unwrap(log(scrambled))/2i - 1 - key;
plot(message3,LW,2.0), axis equal
