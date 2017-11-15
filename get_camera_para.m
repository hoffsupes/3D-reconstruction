function [R,T,W] = get_camera_para(P) 

p1 = P(1,1:end-1);    p14 = P(1,4);
p2 = P(2,1:end-1);	p24 = P(2,4);
p3 = P(3,1:end-1);    p34 = P(3,4);

r3 = p3;
tz = p34;
c0 = p1*p3';
r0 = p2*p3';

sxf = norm(cross(p1,p3));
syf = norm(cross(p2,p3));

tx = (p14 - c0*tz) / sxf;
ty = (p24 - r0*tz) / syf;

r1 = (p1 - c0*r3) / sxf;
r2 = (p2 - r0*r3) / syf;

R = [r1;r2;r3];
T = [tx;ty;tz];

W = [sxf 0 c0; 0 syf r0; 0 0 1];

end