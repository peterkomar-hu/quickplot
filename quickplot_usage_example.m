% This script shows the basic usage of QUICKPLOT and QUICKPLOT_OPTION

clear all;
close all;

% data file to load (full path with / instead of \)
data_filename = './test1.txt';

% image filename to save to (pdf, svg or png)
image_filename = 'auto';

% select plot option from a predefined set
plot_opt = quickplot_option('my favorite option');

% manually change some options
plot_opt.format = 'png';
plot_opt.linecolor = sample_color_map('jet', 6);
plot_opt.top_margin = 0.5;

% do the plotting
quickplot(data_filename, image_filename, plot_opt);

