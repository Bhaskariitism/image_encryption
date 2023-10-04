close all, clear all, clc;
im = imread('lena_color_512.tif');
gray = im2gray(im);
image_vector = gray(:);
% Define parameters
alpha = 1.75325; % Parameter controlling the sine map (adjust as needed)
r = 3.9; % Parameter controlling the logistic map (adjust as needed)
% Number of iterations
num_iterations = numel(gray);
% Initialize an array to store the logistic map data
logistic_map_data = zeros(1, num_iterations);
% Initialize an array to store the sine map data
sine_map_data = zeros(1, num_iterations);
% Initial condition (between 0 and 1, experiment with different values)
x0 = 0.1;
n_values = [];
x_values = [];
% Iterate the logistic map equation
x = x0;
for i = 1:num_iterations
    n_values(end+1) = i;
    x = r * x * (1 - x);
    logistic_map_data(i) = x;
    x = sin(pi * alpha * x);
    sine_map_data(i) = x;
    
end
x_values=sine_map_data;
% Create a scatter plot
figure;
scatter(n_values, x_values, 5, 'b', 'filled')
xlabel('Iteration (n)')
ylabel('x')
title('Scatter Plot of Logistic Map')
%% Scrambling of image

[sorted_sequence, sort_order] = sort(x_values);
shuffled_image_vector = image_vector(sort_order);
shuffled_image = reshape(shuffled_image_vector, size(gray));


%% DNA encoding
%% Robust 2D Logistic map for DNA encdoing and decoding rules
a = 1;
b = 1.98;
c = 1.0;
g1 = 2;
g2 = 2;
k1 = 6;
k2 = 6;

n = numel(gray(:))*4;

x_values = zeros(n,1);
y_values = zeros(n,1);
x_values(1) = 0.1;
y_values(1) = 0.1;

for i = 1:n
    x_values(i+1) = g1*sin(k1*pi*a*y_values(i)^2);
    y_values(i+1) = g2*(sin(k2*pi*(b*y_values(i) - c*x_values(i)*y_values(i))));
end

for i = 1:n
    Key_DNA_enc(i) = mod((floor(x_values(i)*255)),8)+1;
    Key_DNA_dec(i) = mod((floor(y_values(i)*255)),8)+1;
end
Key_DNA_enc_rule = reshape(Key_DNA_enc,512,2048);
Key_DNA_dec_rule = reshape(Key_DNA_dec,512,2048);
DNA_encoded_image = n_dnaEncode(shuffled_image, Key_DNA_enc_rule);
DNA_decoded_image = n_dnaDecode(DNA_encoded_image,Key_DNA_dec_rule);

DNA_encoded_image1 = n_dnaEncode(DNA_decoded_image, Key_DNA_dec_rule);
DNA_decoded_image1 = n_dnaDecode(DNA_encoded_image1,Key_DNA_enc_rule);


%% Unscrambling of Image
unscrambled_image1 = DNA_decoded_image1(:)';
unscrambled_image2(sort_order(:)) = unscrambled_image1(:);
unscrambled_image = reshape(unscrambled_image2,size(gray));

%% Plot images
figure;
subplot(2,2,1), imshow(gray), title('Original Image');
subplot(2,2,2), imshow(shuffled_image), title('Shuffled Image');
subplot(2,2,3), imshow(unscrambled_image), title('Decrypted Image');
subplot(2,2,4), imshow(DNA_decoded_image1), title('Encrypted Image');

%% Histogram plot
figure,title('Histogram');
subplot(1,3,1), imhist(gray); title('Histogram of original image');
subplot(1,3,2), imhist(shuffled_image), title('Histogram shuffled image');
subplot(1,3,3), imhist(DNA_decoded_image), title('Histogram of decoded image');