% Inspired from https://www.reddit.com/r/dataisbeautiful/comments/3rb8zi/the_average_color_of_every_frame_of_a_given_movie/
% Roy Varghese Mathew
% August 15th 2016
% MatLab -v7.3
% This code takes the average color of each fram in a given video, then 
% averages them again into 10,001 different segments and creates a
% continuum of the averages to create a unique color graph

% Get the average color of each frame in movie ----------------------------

% Enter video file path inside single parenthesis
file_path = input('Enter the file path of the video here: ', 's');
v = VideoReader(file_path);
msg = strvcat('Getting video from...', file_path)
clear file_path;

% Calculates the frames per movie buy multiplying fps # number of seconds
fps = v.FrameRate;
numFrames = round(fix(v.Duration) * fps + round((v.Duration - fix(v.Duration)) * fps) + 1);
clear fps;

% Creates contaier to store three RGB values per frame in movie
rgb_values = ones(numFrames, 3);

% Loops through movie analyzing each frame for average color
idx = 1;
h = waitbar(0,strcat('Analysing Frame:', num2str(idx),'/', num2str(numFrames)));
while hasFrame(v)
    waitbar(idx/numFrames,h,strcat('Analysing Frame:', num2str(idx),'/', num2str(numFrames)));
    fr = readFrame(v);
    rgb_values(idx,:) = getAvgRGB(fr);
    idx = idx + 1;
end
delete(h);
clear v;
clear fr;

% Compress RGB Data into 10,000 segments ----------------------------------

% Since the number of frames won't always be divisible by 10,000, we
% truncate the diviser for step and average all the remaining frames at the
% end to create <step> (number of frames' RGB values that
% will be averaged together for each segment). 
compSize = 10000;
step = fix(idx / compSize);

% Average and compress RGB values for frames into 10,000 segments. 
h = waitbar(0,strcat('Compressing Data:', num2str(0),'/', num2str(compSize + 1))); 
rgbCompressed = ones(compSize + 1, 3);
for j = 0:compSize
    waitbar(j/compSize,h,strcat('Compressing Data:', num2str(j),'/', num2str(compSize + 1)))
    % Get RGB Values for <step> frames to be averaged later
    rgbStepInterval = rgb_values((j * step + 1):((j + 1)* step), :);
    rgbCompressed(j + 1,:) = mean(rgbStepInterval);
end

% Remaining frames' RGB values are averaged and put into the last segment
rgbStep = [0 0 0];
for j = (compSize * step):idx
    rgbStep = rgbStep + rgb_values(j);
end
rgbCompressed(compSize + 1, :) = mean(rgbStep);
waitbar(j/compSize,h,strcat('Compressing Data:', num2str(compSize + 1),'/', num2str(compSize + 1)))
delete(h);
clear rgb_values;
clear rgbStep;
clear rgbStepInterval

% Create final continuum image --------------------------------------------
height = 0.2 * compSize;
finalPic = ones(compSize + 1, height, 3);
h = waitbar(0,strcat('Creating Pixel Chart:', num2str(0),'/', num2str(compSize + 1)));

% Each segment will be represented by a verticle line which fades from
% black on the top and bottom to the true color in the center (aka a
% gradient)
half = height / 2;
for j = 1:compSize + 1;
    grad = ones(3, half);
    for k = 1:half
        r = rgbCompressed(j, 1);
        g = rgbCompressed(j, 2);
        b = rgbCompressed(j, 3);
        
        % Logistic gradient fades from dark to true color
        percent = 2*((1 / (1 + exp(-k/(height * 0.16))) - 0.5));
        [r, g, b]= interpolateColor(0.25 * [r, g, b], [r, g, b], percent);
        
        grad(1, end - k + 1) = r;
        grad(2, end - k + 1) = g;
        grad(3, end - k + 1) = b;
        
        finalPic(j,k,1) = r;
        finalPic(j,k,2) = g;
        finalPic(j,k,3) = b;
    end
    
    % Reverses the gradient to fade into dark colors
    finalPic(j,half + 1:height,1) = finalPic(j,half + 1:height,1) .* grad(1, :);
    finalPic(j,half + 1:height,2) = finalPic(j,half + 1:height,2) .* grad(2, :);
    finalPic(j,half + 1:height,3) = finalPic(j,half + 1:height,3) .* grad(3, :);
    waitbar(j/compSize,h,strcat('Creating Pixel Chart:', num2str(j),'/', num2str(compSize + 1)))
end

% Converts matrix into image
finalPic = uint8(finalPic);
image_save_location = input('Enter the file path of where to save the file here: ', 's');
msg = strvcat('Saving the file to...', image_save_location)
imwrite(finalPic, 'im.png');
image(finalPic)