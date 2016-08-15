function rgbAvg = getAvgRGB(im)
R = im(:,:,1);
RAvg = round(mean(R(:)));
G = im(:,:,2);
GAvg = round(mean(G(:)));
B = im(:,:,3);
BAvg = round(mean(B(:)));
rgbAvg = [RAvg GAvg BAvg];
end