function mycolor = sample_color_map(map, number_of_colors)
% SAMPLE_COLOR_MAP samples a continuous color map map, at number_of_colors
% number of evenly distributed points, and return the resulting map as
% mycolor

% load continuous color map
cmap = colormap(map);
% size of the continuous map
[size_of_map,~] = size(cmap);

% create sample map
mycolor = zeros(number_of_colors, 3);
index = round(linspace(1, size_of_map, number_of_colors));
for k = 1 : number_of_colors
    mycolor(k, :) = cmap(index(k), :); 
end