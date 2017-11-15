function draw_ele(trav,Y)

scatter(Y(:,1),Y(:,2)); hold on;
for i = 1:length(trav)-1
line([Y(trav(i),1);Y(trav(i+1),1)],[Y(trav(i),2);Y(trav(i+1),2)]);
end

end