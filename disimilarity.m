function [ disimilarity ] = disimilarity(img1,img2 )
disimilarity=(img1-img2).^2;
end

