clc;clear; a = [ 1.8 2.5 6.4 ] ; % acceleration 
t = 0:.01:15 ; n = 1 ; 
figure; 
while n < 200 
velocity = a(n)*t ; 
position = 0.5*a(n)*t.^2 + velocity.*t ; 
figure(1);plot(t,velocity);
hold all;
figure(2);plot(t,position);
n = n + 1 ; 
hold all;
end
hold off;