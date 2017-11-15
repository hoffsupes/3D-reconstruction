function draw_repline(limg,rimg,LI,F)

   lines = F * [rimg ones(length(rimg),1) ]';
   imshow(LI); hold on;
   
   for i = 1:length(lines)
   Eq = lines(:,i);
   a = Eq(1);
   b = Eq(2);
   c = Eq(3);
   
   cc = 1:size(LI,2);
   rr = (-a*cc - c)/b;
   plot(cc,rr); hold on;
   end
   
   scatter(limg(:,1),limg(:,2));
   
end