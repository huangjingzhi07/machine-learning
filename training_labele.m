folder_path = uigetdir();

% Get a list of all text files in the folder
file_list = dir(fullfile(folder_path, '*.txt'));

% Create an empty array to store the labels and file names
labels = zeros(length(file_list), 1);
file_names = cell(length(file_list), 1);

% Loop over each file and ask the user to label it
for i = 1:length(file_list)
    % Load the data from the text file
    file_path = fullfile(folder_path, file_list(i).name);
    data = load(file_path);
    
    % Plot the data
    plot(data(:, 1), data(:, 2));
    ylim([-80,0]);
    title(sprintf('Data in file %d/%d: %s\nPress any key to continue, or press Q to quit', i, length(file_list), file_list(i).name));
    xlabel('x');
    ylabel('y');
    
    % Ask the user to select a label
    label = 0;
    while label < 1 || label > 4
        label = input(sprintf('Select a label for file %d/%d:\n1. No Lasing\n2. Mode-Locked\n3. FP mode\n4. Unlocked\n', i, length(file_list)), 's');
        
        % Check if the user wants to quit
        if strcmpi(label, 'q')
            break;
        end
        
        % Check if the user wants to reselect label
        if strcmpi(label, 'z')
            continue;
        end
        
        label = str2double(label);
    end
    
    % Stop the labeling process if the user wants to quit
    if strcmpi(label, 'q')
        break;
    end
    
    % Get the file name without extension
    [~, file_name, file_ext] = fileparts(file_list(i).name);
    
    % Create a new file name with the label
    new_file_name = sprintf('%s-%d%s', file_name, label, file_ext);
    new_file_path = fullfile(folder_path, new_file_name);
    
    % Rename the file with the label appended to the file name
    movefile(file_path, new_file_path);
    
    % Store the label and file name in the arrays
    labels(i) = label;
    file_names{i} = new_file_name;
end

% Save the labels and file names to a file
save(fullfile(folder_path, 'labels_and_file_names.mat'), 'labels', 'file_names');

fprintf('done');
