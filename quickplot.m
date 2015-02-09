function quickplot(filename, image_filename, opt)
% QUICKPLOT reads the header and numerical data from a tab delimited file
% and creates a plot with respecting the options defined by opt 
% (see the description of QUICKPLOT_OPTION)
% and saves the plot as an image file (either png, svg or pdf)

%% Read data and preprocess

% read tab-deliminated numeric data with header from filename
[label, data] = read_data_file(filename);

% determine the number of columns of the numeric data
[~, number_of_columns] = size(data);

% determine the number of data columns 
% and the column indices of data and error
if opt.errorbars
    % in the presence of error bars
    number_of_curves = (number_of_columns - 1) / 2;
    index_data = (1 : number_of_curves) * 2;
    index_error = index_data + 1;
else
    % in the absence of error bars
    number_of_curves = number_of_columns - 1;
    index_data = (1 : number_of_curves) + 1;
    index_error = [];
end

% check if there's enough colors for all curves
if number_of_curves > size(opt.linecolor)
   
    warning('not enough colors for all data lines'); 
   
    % repeat the colormap cyclically
    while size(opt.linecolor) < number_of_curves
        opt.linecolor = [opt.linecolor; opt.linecolor];
    end
   
end



%% Compile plot


% plot curves with error bars
hold on;
for k = 1 : number_of_curves
    
    % select data for current curve
    xdata = data(:, 1);
    ydata = data(:, index_data(k) );
    
    % check for NaN values in xdata or ydata
    data_nan_index = isnan(xdata) | isnan(ydata);
    % delete data entries with NaN in xdata or ydata
    xdata = xdata(~data_nan_index);
    ydata = ydata(~data_nan_index);


    if ~opt.errorbars
        % plot without error bars
        plot( xdata, ydata, ...
            'Marker', opt.marker,...
            'MarkerSize', opt.marker_size, ...
            'Color', opt.linecolor(k, :), ...
            'Linewidth', opt.linewidth)        
    else
        % select error for current curve
        yerr = data(:, index_error(k) );

        % check for NaN values in yerr
        yerr_nan_index = isnan(yerr);
        % substitute 0 to NaN in the yerror data
        yerr( yerr_nan_index ) = 0;    
        % delete error entries with NaN in xdata or ydata
        yerr = yerr(~data_nan_index);

        % plot with error bars
        errorbar( xdata, ydata, yerr, ...
            'Marker', opt.marker,...
            'MarkerSize', opt.marker_size, ...
            'Color', opt.linecolor(k, :), ...
            'Linewidth', opt.linewidth)
    end

       
end


% plot limits

% determine limits for x axis if 'auto' is used
if strcmp(opt.xmin, 'auto');
    opt.xmin = min(data(:,1));
end
if strcmp(opt.xmax, 'auto');
    opt.xmax = max(data(:,1));
end

% determine limits for y axis if 'auto' is used
if strcmp(opt.ymin, 'auto');
    lowest = data(1,2);
    for k = 1 : number_of_curves
        current_lowest = min(data(:,index_data(k)) );
        lowest = min(lowest, current_lowest);
    end
   opt.ymin = lowest;
end
if strcmp(opt.ymax, 'auto');
    highest = data(1,2);
    for k = 1 : number_of_curves
        current_highest = max(data(:,index_data(k)) );
        highest = max(highest, current_highest);
    end
   opt.ymax = highest;
end

% apply margins

% extend the x limits according to left and right margin settings
xsize = opt.xmax - opt.xmin;
opt.xmin = opt.xmin - opt.left_margin * xsize;
opt.xmax = opt.xmax + opt.right_margin * xsize;

% extend y limits according to top and bottom margin settings
ysize = opt.ymax - opt.ymin;
opt.ymin = opt.ymin - opt.bottom_margin * ysize;
opt.ymax = opt.ymax + opt.top_margin * ysize;


% set plot limits
axis( [opt.xmin, opt.xmax, opt.ymin, opt.ymax] );

% set font of the axes
set(gca,'FontSize', opt.fontsize);
set(gca,'FontName', opt.fontname);



% axes labels

% x axis label
if strcmp(opt.label_of_xaxis, 'auto')
    % add label to the x-axis from the label of the first column
    h = xlabel(label(1));
else
    % add label as defined
    h = xlabel(label_of_xais);
end
set(h, 'FontName', opt.fontname);
set(h, 'FontSize', opt.fontsize);

% y axis label
ylabel(opt.label_of_yaxis,...
        'FontName', opt.fontname,...
        'FontSize', opt.fontsize);


    
    
% aspect ratio
pbaspect( [opt.aspect_ratio, 1] );



% box
if opt.box_boundary
    box on;
else
    box off;
end



% add legend

legend_str = [];
for k = 1 : number_of_curves
    % compile legend string from label entries
    legend_str = [ legend_str, label( index_data(k) ) ];
end
legend(legend_str, ...
        'Location', opt.legend_position,...
        'FontName', opt.fontname,...
        'FontSize', opt.fontsize);

    
    
hold off;



%% Print plot to image file

% determine image file's name if 'auto' is used
if strcmp(image_filename, 'auto')
    [pathname, name, ~] = fileparts(filename);
    image_filename = [pathname, '/' name, '.', opt.format];
end


% print

if strcmp(opt.format, 'pdf')
    % set paper size ([width, height])
    papersize = 5 * opt.aspect_ratio / opt.aspect_ratio(1);
    set(gcf, 'PaperSize', papersize); 
    % set paper position ([left, bottom, width, height])
    set(gcf, 'PaperPosition', [-papersize * 0.05, papersize*1.15]); 
    print(image_filename, '-dpdf');
    
elseif strcmp(opt.format, 'png')
    print(image_filename, '-dpng');
    
elseif strcmp(opt.format, 'svg')
    print(image_filename, '-dsvg');
    
else
    error(['"', opt.format, '" is not a valid format specifier']);
end
 


