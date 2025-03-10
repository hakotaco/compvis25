% Load stereo images
img1 = imread('tsukuba1.png');
img2 = imread('tsukuba2.png');

% Define parameters
window_size = 9;        % Size of the patch (odd values recommended)
max_disparity = 30;     % Maximum disparity to check
method = 'SSD';         % Choose 'SSD', 'SAD', or 'NCC'
method2 = 'SAD';
method3 = 'NCC';

% Compute the disparity map
disparity_map = compute_disparity(img1, img2, window_size, max_disparity, method);
disparity_map2 = compute_disparity(img1, img2, window_size, max_disparity, method2);
disparity_map3 = compute_disparity(img1, img2, window_size, max_disparity, method3);

% Display results
figure;
imshow(disparity_map, []);
colormap('jet'); colorbar;
title(['Disparity Map using ', method]);

figure;
imshow(disparity_map2, []);
colormap('jet'); colorbar;
title(['Disparity Map using ', method2]);

figure;
imshow(disparity_map3, []);
colormap('jet'); colorbar;
title(['Disparity Map using ', method3]);