function [ pout,disimilarity] = affineTracker(img,pin,cropped,tmplt_pts,context )
%The function will update the parameters for affine warp.
%Win is the affine warp matrix for the previous frmae.
%img is the current image(Frame)
%tmp is the template(full size)
[~,w]=size(cropped);
pout=pin;
n=20;
iter=0;
delta_p=1;

%disimilar=0;

%for i=1:n 
while norm(delta_p)>0.001 && iter<n
%% calculate the error image
wimg = warp_a(img, pout, tmplt_pts);
% figure(3)
% hold off;
% imshow(warpim);
% hold on;
a_I=sum(sum(wimg))/numel(wimg);
%add illumination robustness
wimg=wimg/(a_I/context.average_illumination);
%disimilar=disimilarity(wing,cropped);
error_img=wimg-cropped;
%% step7 in LK_20
sd_delta_p = sd_update(context.Jacobian, error_img, 3, w);
%% step8 in LK_20
delta_p=context.Inverse_Hessian*sd_delta_p;
%norm(delta_p)
%% step9 in LK_20
pout = update_step(pout, delta_p);
%%
iter=iter+1;
end
%disimilarity=sum(sum((wimg-cropped).^2));
disimilarity=1;
end


function warp_p = update_step(warp_p, delta_p)
% Compute and apply the update
co_p=cos(delta_p(1));
si_p=sin(delta_p(1));
delta_M = [co_p,-si_p,delta_p(2);si_p,co_p,delta_p(3); 0 0 1];	
% Invert compositional warp
delta_M = inv(delta_M);
% Current warp
warp_M = [warp_p; 0 0 1];	
% Compose
comp_M = warp_M * delta_M;	
warp_p = comp_M(1:2,:);
end






