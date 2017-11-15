

for i = 1:size(Lpts,1)
figure(1); imshow(rect_LI); hold on; plot(Lpts(i,2),Lpts(i,1),'r+'); hold all;
figure(2); imshow(rect_RI); hold on; plot(matches(i,2),matches(i,1),'b+'); hold all;
pause;
drawnow
end