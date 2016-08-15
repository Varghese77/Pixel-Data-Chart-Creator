% Takes in an MxNx3 image matrix where M is the height of the image, N is 
% the width of the image, and the third dimension stores the corresponding
% pixle RGB values. Function averages the red, green, and blue values
% respectivly and returns the averages as part of a 1x3 matrix. 
function rgbAvg = getAvgRGB(im)
R = im(:,:,1);
RAvg = round(mean(R(:)));
G = im(:,:,2);
GAvg = round(mean(G(:)));
B = im(:,:,3);
BAvg = round(mean(B(:)));
rgbAvg = [RAvg GAvg BAvg];
end