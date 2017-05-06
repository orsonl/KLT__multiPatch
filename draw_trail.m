function draw_trail(img, point2draw)
%This function will draw the trail of a tracked patch.
figure(7);
imshow(img);
hold on;
plot(point2draw(1,:),point2draw(2,:),'g', 'linewidth', 2);
plot(point2draw(1,end),point2draw(2,end),'r*');
drawnow;
end

