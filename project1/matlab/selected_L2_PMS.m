
function N = selected_L2_PMS(data, m)
% Calculate photometric stereo from given data, using Least Square algo.
%
% Inputs / outputs,
%  data    : A struct with the following fields,
%   s         : nimages x 3 light source directions
%   L         : nimages x 3 light source intensities
%   filenames : cell array of image filenames
%   imgs      : cell array of images (only if load_imgs == true)
%   mask      : Mask image (only if load_mask == true)
%
%  m     : valid pixel index for each image.
% 
% return : normal map of image size


imgs = data.imgs;
[num_img, dummy] = size(imgs);
[img_h, img_w, img_dim] = size(imgs{1});
Li_directections = data.s;

I_all = zeros(img_h, img_w, num_img);

for img_idx = 1:num_img
    img = data.imgs{img_idx};
    img_normalized = rgb2gray(img);
    for h = 1:img_h
        for w = 1:img_w
            if data.mask(h, w)
                pix_value = img_normalized(h,w);
%                 size(pix_value)
                I_all(h, w, img_idx) = pix_value;
            end
        end
    end
end

% normal map
N_img = zeros(img_h, img_w, 3);

discard_corrupted_data_ratio = 0.2;
for h = 1:img_h
    for w = 1:img_w
        if data.mask(h, w)
            pix_intensity = reshape(I_all(h, w, :), [num_img, 1]);
%             disp('before sort:')
%             disp(pix_intensity)
            [sorted_pix_intensity, indexs] = sort(pix_intensity, 1);
%             disp('after sort:')
%             disp(sorted_pix_intensity)
%             disp('sortedindexs: ')
%             disp(indexs)
            
            selected_begin_idx = int32(discard_corrupted_data_ratio*num_img);
            selected_end_idx = int32((1-discard_corrupted_data_ratio)*num_img);
            selected_pix_intensity = sorted_pix_intensity(selected_begin_idx:selected_end_idx, :);
            selected_indexs = indexs(selected_begin_idx:selected_end_idx);
%             disp('selected_pix_intensity size ')
%             disp(size(selected_pix_intensity))
%             disp('selected indexs size: ')
%             disp(size(selected_indexs))
            
            selected_Li_directions = Li_directections(selected_indexs, :);
%             disp('selected_Li_directions size:')
%             disp(size(selected_Li_directions))
            % Solve surface normals
%             pix_normal = (Li_directections.'*Li_directections)\(Li_directections.'*selected_pix_intensity);
            pix_normal = (selected_Li_directions.'*selected_Li_directions)\(selected_Li_directions.'*selected_pix_intensity);
            if norm(pix_normal) ~= 0
                % Normalize n
                pix_normal = pix_normal/norm(pix_normal);
            else
                pix_normal = [0; 0; 0];
            end
            N_img(h, w, :) = pix_normal;
        end
    end
end

N = N_img;
end
