function [label, data] = read_data_file(filename)
% READ_DATA_FILE opens a tab-delimited file with 
% a single header with n etries in the first row
% and any number of rows and n columns containing doubles
% 
% it returns the header in cell array label
% and the numberical values in data 
% (it loads non-numerical entires as NaN)


% open file 
file = fopen(filename, 'r');

% check if it exists
if file < 0 
    error('No such file')
end

% read the first line and put it in label
line = fgetl(file);
label = strsplit(line, '\t');
number_of_columns = length(label);

% start with an all zero line of the container for numberical data
data = zeros(1, number_of_columns);
while ~feof(file)
% for all remaining rows of file
    
    % read line
    line = fgetl(file);
        
    % convert it into a numerical array
    line_numeric = str2num(line);
    if isempty(line_numeric)
    % if non-numeric value is in line
       line_cell = strsplit(line);
       for k = 1 : number_of_columns
            % find the non-numeric values
            entry_numeric = str2double(line_cell{k});
            if isempty( entry_numeric )
               % and substitute them with NaN
               line_numeric = [line_numeric, NaN ];
            else
                line_numeric = [line_numeric, entry_numeric];
            end
       end
    end
    
    % append it to data
    data = [data; line_numeric];
    
end

% close file
fclose(file);

% get rid of the first all-zero line
data = data(2:size(data), :);

