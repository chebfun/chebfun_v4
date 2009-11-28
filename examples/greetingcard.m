% greetingcard.m - makes a Chebfun Greeting card
% Just type greetingcard to run, or greetingcard(0)
% to run fast.  Chebfun Version 3 must be in your path.
% Nick Trefethen, Oxford University, November 2009

function greetingcard(dt0)
if nargin==0, dt0 = 4; end;       % pause between statements

w('We''re going to make a 10-digit greeting card.',.5)

w('(Actually the accuracy is more like 15 digits.)')

w('You''ll type a message as a string in quotes, like')
w('message = ''Happy Birthday Mom!''.',0)

w('Chebfun will call ''scribble'' to make it into')
w('a piecewise linear complex function s of the real',0)
w('variable x in [-1,1].  The values s(x) lie in a',0)
w('rectangle in the complex plane just above [-1,1].',0)

w('Then you can distort the function in artistic ways by')
w('applying a function f(s) to it like s.^2 or exp(s).',0)

w('OK, what''s your message string? ');
message = input('message = ');

disp(' ')
w('Here is your message as a chebfun.',0)
w('(see figure window -- the colors here are random):',0)

s = scribble(message);
fs = 's';
ht = mean(imag(eval(fs)));
semi = chebfun(@(x) exp(1i*x),[-pi/2 pi/2]);
seg = chebfun('x');
border0 = [seg-.4i*ht;1+ht*1i+1.4*ht*semi;2.4*ht*1i-seg;-1+ht*1i-1.4*ht*semi];
border = chebfun;
border{-1,1} = border0;

ps(fs)

prompt = 'Type <Enter> to see the result of f(s) = ';

fs = 'exp(1.5*s)';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'sin(2.5*s)';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = '(s+.5i).^2';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = '(s+.5+.5i).^3';                  disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'exp(2.5i*s)';                    disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'exp(-1.4i)*exp((3.5i+.6)*s)/1i'; disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'real(s) + exp((1+1i)*(s-.5))';   disp(' '), w([prompt fs],0); ps(fs,99)

w('Well now you''ve got the hang of it.')
w('It''s time to pick your own function f,',0)
w('which you should input as a string in quotes.',0)

w('You can keep trying things till you''re satisfied.')
w('Then type in the string ''done''.',0)

while ~strcmp(fs,'done')
  fs = input('function = ');
  if ~strcmp(fs,'done'), disp(' '), ps(fs,0), end
end

w('We''ll now turn off the axes and the title.')
axis off, title(' ')

w('Use Matlab'' control buttons to change the color,')
w('and when you''re happy, print your greeting card.',0)

w('Incidentally, you can run this program more quickly')
w('by typing, say, greetingcard(1) or greetingcard(0).',0)


function w(str,dt)  % writes string s on the screen after delay dt,
                    % which defaults to dt0 seconds.
if nargin==1, dt=dt0+1e-6; end
if dt>0, disp(' '), pause(dt), end
disp(str)
end

function ps(fs,dt)  % plots chebfun defined by string fs in a figure
                    % after delay dt, which defaults to dt0 seconds.
                    % The color is random.
                    % If dt=99, wait for user to hit <Enter>.
red = [1 0 0]; green = [0 1 0]; blue = [0 0 1]; cyan = [0 1 1];
magenta = [1 0 1]; black = [0 0 0]; orange = [1 .5 0]; red2 = [1 0 .5];
purple = [.5 0 1];
cc = [red; green; blue; cyan; magenta; black; orange; red2; purple];
if nargin==1, dt=dt0+1e-6; end
if dt>0
  if dt==99, pause, else pause(dt), end
end
c = cc(randi(size(cc,1)),:);
ffs = eval(fs);
hold off
plot(ffs,'linewidth',2,'color',c), axis equal, grid on
c = cc(randi(size(cc,1)),:);
ssave = s;
s = border;
hold on
plot(eval(fs),'linewidth',2,'color',c)
s = ssave;
a = axis;
xm = mean(a(1:2)); xd = a(1:2)-xm;
ym = mean(a(3:4)); yd = a(3:4)-ym;
axis([xm+1.1*xd ym+1.1*yd])
title(fs,'fontsize',16), shg
end

end

