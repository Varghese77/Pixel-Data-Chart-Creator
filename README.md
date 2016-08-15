This project was inspired from...
"https://www.reddit.com/r/dataisbeautiful/comments/3rb8zi/the_average_color_of_every_frame_of_a_given_movie/"

Pixel Data Chart Creator calculates the average color of each frame in a full length movie and compresses the 
colors into segments of 10,001. The program then takes these segments and creates an output image where each
horizontal line represents the color of a segment. This creates a unique looking image for every image that 
helps show the progression of colors in various films and movies. 

Note: This program is meant to work on movies that are 1hr-3hr long. It has been untested for any other length
of film. In addition, the program is meant to be run in MATLAB and nothing else. Also, this program assumes that 
it will be run on a computer with adequate cpu speed and RAM to process the movie. Lastly, the output image has a 
horizontal fade to darker colors on the sides.

Look at /examples to see what the output images look like. 

HOW TO USE:
  1. Place .m files in the same directory
  2. Open up pixel_chart_creator.m in MATLAB and run script
  3. Go to command window and enter in the absolute video location and image save location when propted to do so. 
  4. Let script process film. 
