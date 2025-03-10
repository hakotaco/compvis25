% Load stereo images
img1 = imread('tsukuba1.png');
img2 = imread('tsukuba2.png');
ground_truth = imread('tsukuba_gt.png'); % Load ground truth disparity map

% Select 5 feature points in the first image
figure, imshow(img1);
title('Select 5 feature points in the first image');
[x1, y1] = ginput(5);  % Manually click 5 points
hold on; plot(x1, y1, 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Mark points

% Select corresponding 5 points in the second image
figure, imshow(img2);
title('Select the corresponding 5 points in the second image');
[x2, y2] = ginput(5);  % Click corresponding points in second image
hold on; plot(x2, y2, 'go', 'MarkerSize', 10, 'LineWidth', 2); % Mark points

% Compute disparities
disparities = x1 - x2; % x-coordinates difference

% Initialize arrays
gt_disparities = zeros(1, 5);
errors = zeros(1, 5);  % Store errors in an array

% Loop over each selected point
for i = 1:5
    % Round the coordinates to get valid pixel indices
    x_idx = round(x1(i));
    y_idx = round(y1(i));
    
    % Ensure the indices are within the image bounds
    x_idx = min(max(x_idx, 1), size(ground_truth, 2)); % Clamp x within bounds
    y_idx = min(max(y_idx, 1), size(ground_truth, 1)); % Clamp y within bounds
    
    % Get the ground truth disparity at this point
    gt_disparities(i) = ground_truth(y_idx, x_idx) / 8; % Normalize ground truth as given in data description
end

% Convert ground truth disparities to double
gt_disparities = double(gt_disparities);

% Compute absolute errors
for i = 1:5
    errors(i) = abs(disparities(i) - gt_disparities(i));
end

% Display results in a properly formatted table
disp('Selected Points and Computed Disparities:');
disp(table(x1, y1, x2, y2, disparities, gt_disparities', errors', ...
    'VariableNames', {'x1', 'y1', 'x2', 'y2', 'Disparity', 'GT_Disparity', 'Error'}));

% Compute mean error
mean_error = mean(errors);
disp(['Mean Disparity Error: ', num2str(mean_error)]);