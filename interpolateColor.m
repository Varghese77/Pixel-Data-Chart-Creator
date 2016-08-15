function [R, G, B] = interpolateColor(col1, col2, percent)
R = col1(1) + (col2(1) - col1(1)) * percent;
G = col1(2) + (col2(2) - col1(2)) * percent;
B = col1(3) + (col2(3) - col1(3)) * percent;
end