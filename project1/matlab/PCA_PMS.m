function N = PCA_PMS(data, m)
% Calculate photometric stereo from given data, using low-rank matrix factorization.
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

I_all = zeros(img_h,img_w, num_img);
for img_idx = 1:num_img
    img = data.imgs{img_idx};
    img_normalized = rgb2gray(img);
    for h = 1:img_h
        for w = 1:img_w
            if data.mask(h, w)
                pix_value = img_normalized(h,w);
                I_all(h, w, img_idx) = pix_value;
            end
        end
    end
end
I_all = reshape(I_all, [img_h*img_w, num_img]);

maksed_I_all = I_all(m,:)';
disp('maksed_I_all size :');
disp(size(maksed_I_all));
[A, E] = robust_pca_defactorization(maksed_I_all);
disp('low rank A size: ');
disp(size(A));

Normal = Li_directections\A;
disp('Normal size:');
disp(size(Normal));
Normal = normalize(Normal, 1)';   
N_img = zeros(img_h*img_w, 3);
for i = 1:3
    N_img(m, i) = Normal(:, i);
end

N_img = reshape(N_img, [img_h, img_w, 3]);
N = N_img;
end