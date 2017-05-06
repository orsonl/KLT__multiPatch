function [img_pyramid] = pyramidBuilder(img,nL)
%Build image pyramid
%img-imput image
%nL-number of pyramid layer 
figure;
subplot(1,nL+1,1);
imshow(img);
title('layer0')
for i=1:nL
subsampled=impyramid(img,'reduce');
img=subsampled;
subplot(1,nL+1,i+1);
imshow(img);
title(sprintf('layer%d',i));
size(img)
end




