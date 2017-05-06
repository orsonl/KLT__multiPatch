function [ patches,boundary] = patch_assignment( img, feature_point, patch_size )
%assign patch to feature point
%img
%feature_point-feature point location(x,y) in a frame.
%size-patch size. 15 by 15 is ususally a good choice
half_width=fix(patch_size/2);

x_up=feature_point(:,1)-half_width;
x_down=feature_point(:,1)+half_width;
y_up=feature_point(:,2)-half_width;
y_down=feature_point(:,2)+half_width;
[h,~]=size(feature_point);
patches=[];
boundary=[];
for i=1:h
patches=[patches;img(y_up(i):y_down(i),x_up(i):x_down(i))];
templateBox = [x_up(i) x_up(i) x_down(i) x_down(i) x_up(i) y_up(i) y_down(i) y_down(i) y_up(i) y_up(i)];
boundary=[boundary;templateBox];
end
end

