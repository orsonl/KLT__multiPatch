%folder containing data (a sequence of jpg images)
dirname = '../data/simpse';

%find the images, initialize some variables
dirlist = dir(sprintf('%s/*.jpg', dirname));
nframes = numel(dirlist);
patch_size=15;
%x = 0:1:nframes;

%W = [1,0,0;0,1,0;0,0,1];
startFrame = 1;

%loop over the images in the video sequence
for i=startFrame:nframes
    %read a new image, convert to double, convert to greyscale
    figure(9);
    img = imread(sprintf('%s/%s', dirname, dirlist(i).name));
    
end    