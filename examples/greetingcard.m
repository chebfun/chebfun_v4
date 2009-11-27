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
w('rectangle in the complex plane just about [-1,1]',0)

w('Then you can distort the function in artistic ways by')
w('applying a function f(s) to it like exp(s) or sin(s).',0)

w('OK, what''s your message string? ');
message = input('message = ');

w('Here is your message as a chebfun.')
w('(see figure window -- the colors here are random):',0)

s = scribble(message);
fs = 's';
circle = 1.11*chebfun(@(x) exp(1i*pi*x));
ellipse = 1.17*(circle + 1./circle)/2 + 1i*mean(imag(eval(fs)));
ps(fs)

prompt = 'Type <Enter> to see the result of f(s) = ';

fs = 'exp(2*s)';                       w([prompt fs]); ps(fs,99)
fs = 'sin(2.5*s)';                     w([prompt fs]); ps(fs,99)
fs = '(s+1i).^2';                      w([prompt fs]); ps(fs,99)
fs = 'exp(2.5i*s)';                    w([prompt fs]); ps(fs,99)
fs = 'exp(-1.4i)*exp((3.5i+.4)*s)/1i'; w([prompt fs]); ps(fs,99)
fs = 'real(s) + exp((1+1i)*(s-.5))';   w([prompt fs]); ps(fs,99)


function w(str,dt)  % writes string s on the screen after delay dt,
                    % which defaults to dt0 seconds.
if nargin==1, dt=dt0+1e-6; end
if dt>0, disp(' '), pause(dt), end
disp(str)
end

function ps(fs,dt)  % plots chebfun defined by string fs in a figure
                    % after delay dt,
                    % which defaults to dt0 seconds.
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
s = ellipse;
hold on
plot(eval(fs),'linewidth',2,'color',c)
s = ssave;
a = axis;
xm = mean(a(1:2)); xd = a(1:2)-xm;
ym = mean(a(3:4)); yd = a(3:4)-ym;
axis([xm+1.1*xd ym+1.1*yd])
title(fs,'fontsize',16)
end

end

