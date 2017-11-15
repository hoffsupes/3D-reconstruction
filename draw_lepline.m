function draw_lepline(limg,rimg,RI,F)

   lines = F'*[limg ones(length(limg),1) ]';
   imshow(RI); hold on;
   
   for i = 1:length(limg)
   Eq = lines(:,i);
   a = Eq(1);
   b = Eq(2);
   c = Eq(3);
   
   cc = 1:size(RI,2);
   rr = (-a*cc - c)/b;
   plot(cc,rr); hold on;
   end
   
%    scatter(rimg(:,1),rimg(:,2));
   
end