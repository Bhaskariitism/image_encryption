%% Block label SVD

clear all, close all, clc;

im = imread("lena_color_512.tif");
gray = im2gray(im);
[row, col] = size(gray);

gray1 = double(gray);
blocksize = 32;

%% Block level SVD with blocksize 16X16
for i = 1:blocksize:row
    for j = 1:blocksize:col
        block = gray(i:i+blocksize-1,j:j+blocksize-1);
        [U,S,V] = svd(double(block));
        U1 = U(:,1:2);
        S1 = S(1:2,1:2);
        V1 = V(:,1:2);
        rec_block = U1*S1*V1';
        rec_image(i:i+blocksize-1,j:j+blocksize-1) = rec_block;
    end
end
rec = uint8(rec_image);
PSNR = psnr(gray,rec);
disp(PSNR);
figure;
subplot(1,2,1),imshow(gray), title('Original image');
subplot(1,2,2), imshow(rec), title('Reconstructed image')

