%%%%%% Start Here
%{
v = VideoReader('video.mp4');
fps = v.FrameRate;
numFrames = round(fix(v.Duration) * fps + round((v.Duration - fix(v.Duration)) * fps) + 1);
clear fps;
rgb_values = ones(numFrames, 3);
idx = 1;
h = waitbar(0,strcat('Analysing Frame:', num2str(idx),'/', num2str(numFrames)));
while hasFrame(v)
    waitbar(idx/numFrames,h,strcat('Analysing Frame:', num2str(idx),'/', num2str(numFrames)));
    fr = readFrame(v);
    rgb_values(idx,:) = getAvgRGB(fr);
    idx = idx + 1;
end
delete(h);
save rgbvals.dat rgb_values;
save idx.dat idx;
clear v;
clear fr;

%%%% Compress RGB Data
compSize = 10000;
step = fix(idx / compSize);

h = waitbar(0,strcat('Compressing Data:', num2str(0),'/', num2str(compSize + 1))); 
rgbCompressed = ones(compSize + 1, 3);
for j = 0:compSize
    waitbar(j/compSize,h,strcat('Compressing Data:', num2str(j),'/', num2str(compSize + 1)))
    rgbStepInterval = rgb_values((j * step + 1):((j + 1)* step), :);
    rgbCompressed(j + 1,:) = mean(rgbStepInterval);
end

rgbStep = [0 0 0];
for j = (compSize * step):idx
    rgbStep = rgbStep + rgb_values(j);
end
rgbCompressed(compSize + 1, :) = mean(rgbStep);
waitbar(j/compSize,h,strcat('Compressing Data:', num2str(compSize + 1),'/', num2str(compSize + 1)))
delete(h);
save rgbCompressed.dat rgbCompressed
clear rgb_values;
clear rgbStep;
clear rgbStepInterval
%}
comSize = 10000;
rgbCompressed = importdata('rgbCompressed.dat');
height = 0.2 * compSize;
finalPic = ones(compSize + 1, height, 3);
h = waitbar(0,strcat('Creating Pixel Chart:', num2str(0),'/', num2str(compSize + 1))); 
half = height / 2;
for j = 1:compSize + 1;
    grad = ones(3, half);
    for k = 1:half
        r = rgbCompressed(j, 1);
        g = rgbCompressed(j, 2);
        b = rgbCompressed(j, 3);
        
        percent = 2*((1 / (1 + exp(-k/(height * 0.16))) - 0.5));
        [r, g, b]= interpolateColor(0.25 * [r, g, b], [r, g, b], percent);
        
        grad(1, end - k + 1) = r;
        grad(2, end - k + 1) = g;
        grad(3, end - k + 1) = b;
        
        finalPic(j,k,1) = r;
        finalPic(j,k,2) = g;
        finalPic(j,k,3) = b;
    end
    finalPic(j,half + 1:height,1) = finalPic(j,half + 1:height,1) .* grad(1, :);
    finalPic(j,half + 1:height,2) = finalPic(j,half + 1:height,2) .* grad(2, :);
    finalPic(j,half + 1:height,3) = finalPic(j,half + 1:height,3) .* grad(3, :);
    waitbar(j/compSize,h,strcat('Creating Pixel Chart:', num2str(j),'/', num2str(compSize + 1)))
end
save finalPic.dat finalPic -v7.3;
finalPic = uint8(finalPic);
imwrite(finalPic, 'lol.png');
imread('lol.png');
image(finalPic)