% plot C/A signal

% clock
A = 1;
f_clock = 10.23e6;

% C/A signal
f_ca = f_clock / 10; 
T_ca = 1 / f_ca;
x_ca = 1:1023;
y_ca = code_ca([2, 6]);

% make square
x1=[x_ca;x_ca(2:end),x_ca(end)+1];
x2=x1(:) * T_ca;
y1=[y_ca;y_ca];
y2=y1(:);


% cut 
% cut = 100; % 0.0001s
% x2 = x2(1:2*cut);
% y2 = y2(1:2*cut);
plot(x2,y2);

% annotation
xlim([x2(1),x2(end)]);
ylim([-1,2]);


% carrier: L1
% f_L1 = f_clock*154;
% T_L1 = 1/f_L1;
% t = 0:T_L1/20:0.000001;
% y_L1 = A*sin(2*pi*f_L1*t);



