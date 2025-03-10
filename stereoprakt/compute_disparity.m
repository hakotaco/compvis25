function disparity_map = compute_disparity(img1, img2, window_size, max_disparity, method)
    % Convert images to grayscale if they are RGB
    if size(img1, 3) == 3
        img1 = rgb2gray(img1);
    end
    if size(img2, 3) == 3
        img2 = rgb2gray(img2);
    end
    
    % Convert images to double for computation
    img1 = double(img1);
    img2 = double(img2);

    % Get image dimensions
    [height, width] = size(img1);
    
    % Initialize disparity map
    disparity_map = zeros(height, width);
    
    % Define window half-size
    half_w = floor(window_size / 2);
    
    % Iterate over each pixel, excluding edges
    for y = (1 + half_w):(height - half_w)
        for x = (1 + half_w):(width - half_w)
            % Extract the patch from img1
            patch1 = img1(y - half_w:y + half_w, x - half_w:x + half_w);
            
            best_match = 0;
            best_score = Inf; % For SSD & SAD, should be minimized
            if strcmp(method, 'NCC')
                best_score = -Inf; % For NCC, should be maximized
            end
            
            % Search over possible disparities
            for d = 0:min(max_disparity, x - half_w - 1)
                % Compute valid x-range to prevent indexing errors
                x_start = max(1, x - d - half_w);
                x_end = min(width, x - d + half_w);
                
                % Ensure the patch size remains constant
                patch2 = img2(y - half_w:y + half_w, x_start:x_end);
                
                % Check if patch2 has the same size as patch1
                if size(patch2) ~= size(patch1)
                    continue; % Skip if the patch sizes don't match
                end
                
                % Compute similarity score
                if strcmp(method, 'SSD')
                    score = sum((patch1 - patch2).^2, 'all'); % Sum of Squared Differences
                elseif strcmp(method, 'SAD')
                    score = sum(abs(patch1 - patch2), 'all'); % Sum of Absolute Differences
                elseif strcmp(method, 'NCC')
                    % Normalized Cross-Correlation
                    num = sum((patch1 - mean(patch1, 'all')) .* (patch2 - mean(patch2, 'all')), 'all');
                    denom = sqrt(sum((patch1 - mean(patch1, 'all')).^2, 'all') * sum((patch2 - mean(patch2, 'all')).^2, 'all'));
                    score = num / denom;
                else
                    error('Invalid method! Use "SSD", "SAD", or "NCC".');
                end
                
                % Update best match
                if strcmp(method, 'NCC')
                    if score > best_score
                        best_score = score;
                        best_match = d;
                    end
                else
                    if score < best_score
                        best_score = score;
                        best_match = d;
                    end
                end
            end
            
            % Store best disparity for this pixel
            disparity_map(y, x) = best_match;
        end
    end
end