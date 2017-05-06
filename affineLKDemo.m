%folder containing data (a sequence of jpg images)
dirname = '../data/landing';

%find the images, initialize some variables
dirlist = dir(sprintf('%s/*.jpg', dirname));
nframes = numel(dirlist);
% startFrame = 1;
% nframes=20;
patch_size=65;
corner_num=5;

img = imread(sprintf('%s/%s', dirname, dirlist(1).name));
point2draw=[];
%loop over the images in the video sequence
for i=startFrame:nframes
    %read a new image, convert to double, convert to greyscale
    img = imread(sprintf('%s/%s', dirname, dirlist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    img = double(img) / 255;
%% if this is the first image, this is the frame to mark a template on
    if (i == startFrame)
        %display the image and ask the user to click where the template is
        hold off;
        figure(1)
        imshow(img);
        hold on;
        drawnow;
        title('Click on the upper left corner of the template region to track');
        [xt1, yt1] = ginput(1);
        title('Click on the lower right corner of the template region to track');
        [xt2, yt2] = ginput(1);
        yt1 = round(yt1); yt2 = round(yt2);
        xt1 = round(xt1); xt2 = round(xt2);
        %%corner_detection
        corners=corner_detection(img(yt1:yt2,xt1:xt2),'Harris',corner_num);
        %hold on;
        corners(:,1)=corners(:,1)+xt1;
        corners(:,2)=corners(:,2)+yt1;
        plot(corners(:,1), corners(:,2), 'r*');
        [patches,boundary]=patch_assignment(img,corners,patch_size );
        [h,~]=size(boundary);
        for i2=1:h
            plot(boundary(i2,1:5), boundary(i2,6:10), 'g', 'linewidth', 0.5);
        end   
        %% Initialize warping parameter  
        warp_p = [ones(h,1),zeros(h,1),boundary(:,1)-1,zeros(h,1),ones(h,1),boundary(:,6)-1];         
        %% Template verticies, rectangular [minX minY; minX maxY; maxX maxY; maxX minY]
        tmplt_pts = [1 1; 1 patch_size; patch_size patch_size; patch_size 1]';
        templateBox = [tmplt_pts tmplt_pts(:,1)];
        %% initialize the LK tracker for this template
        affineLKContext=[];
        for i3=1:h
            img_cropped=patches(1+(i3-1)*patch_size:i3*patch_size,:);
            affineLKContext = [affineLKContext;AffineLKTrackerInit_rigid(img_cropped)];  
        end
    end
    %LK tracking to update transform for current frame
    for i4=1:h      
    img_cropped=patches(1+(i4-1)*patch_size:i4*patch_size,:);
    warp_p_inloop=[warp_p(i4,1:3);warp_p(i4,4:6)];
    [warp_p_out,disimilar] = affineTracker(img,warp_p_inloop,img_cropped,tmplt_pts,affineLKContext(i4));
    warp_p(i4,:)=[warp_p_out(1,:) warp_p_out(2,:)];
    end
%     figure(100);
%     hold on
%     plot(i,disimilar,'.-');  
    %% draw the location of the template onto the current frame, display
    hold off;
    figure(6);
    imshow(img);
    for i5=1:h
    M = [warp_p(i5,1:3);warp_p(i5,4:6); 0 0 1];
    currentBox = M * [templateBox; ones(1,5)];
    currentBox = currentBox(1:2,:);

    hold on;
    plot(currentBox(1,:), currentBox(2,:), 'g', 'linewidth', 2);

    drawnow;
    end
    %draw tracks    
%     next=[(currentBox(1,1)+currentBox(1,3))/2,(currentBox(2,1)+currentBox(2,2))/2];
%     point2draw=[point2draw next'];
%     draw_trail(img,point2draw);    
end