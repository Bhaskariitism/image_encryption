%% 2D-SCCM
clear all, close all, clc;
%% Image read
im = imread("lena_color_512.tif");
gray = im2gray(im);
[rows, cols] = size(gray);
n = rows;
%% Control parameter
alpha = 4;
beta = 4;
x_values = zeros(1,n);
y_values = zeros(1,n);

x_values(1) = 0.1;
y_values(1) = 0.1;

for i = 1:n-1
    x_values(i+1) = sin(4*alpha*pi*y_values(i)*(1 - x_values(i)));
    y_values(i+1) = cos(8*beta*pi*sin(pi+y_values(i)+x_values(i+1)));

end
[sorted_sequence_row, sort_order_row] = sort(x_values);
[sorted_sequence_col, sort_order_col] = sort(y_values);
figure;
scatter(x_values,y_values,"filled","d","MarkerFaceColor","red");
xlabel('X-Label');
ylabel('Y-Label');

%% Image shuffling
for i = 1:rows
    for j = 1:cols
        shuffled(i,j) = gray(sort_order_row(i),sort_order_col(j));
    end
end

%% DNA encoding and decoding
%% Rule for DNA encoding and decoding
a = 1;
b = 1.98;
c = 1.0;
g1 = 2;
g2 = 2;
k1 = 6;
k2 = 6;

n = numel(shuffled(:))*4;

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
DNA_encoded_image = n_dnaEncode(shuffled, Key_DNA_enc_rule);
DNA_decoded_image = n_dnaDecode(DNA_encoded_image,Key_DNA_dec_rule);

DNA_encoded_image1 = n_dnaEncode(DNA_decoded_image, Key_DNA_dec_rule);
DNA_decoded_image1 = n_dnaDecode(DNA_encoded_image1,Key_DNA_enc_rule);

%% Unscrambling image
for i = 1:rows
    for j = 1:cols
        unscrambled(sort_order_row(i),sort_order_col(j)) = DNA_decoded_image1(i,j);
    end
end
figure;
subplot(2,2,1),imshow(gray),title('Original Image');
subplot(2,2,2), imshow(shuffled),title('Shuffled Image');
subplot(2,2,3), imshow(DNA_decoded_image), title('Cipher Image');
subplot(2,2,4),imshow(unscrambled),title('Decrypted Image');

%% Histogram plot
figure;
subplot(2,2,1),imhist(gray),title('Original Image'); xlabel('Pixel'), ylabel('Frequency');
subplot(2,2,2), imhist(shuffled),title('Shuffled Image'); xlabel('Pixel'), ylabel('Frequency');
subplot(2,2,3), imhist(DNA_decoded_image), title('Cipher Image'); xlabel('Pixel'), ylabel('Frequency');
subplot(2,2,4),imhist(unscrambled),title('Decrypted Image'); xlabel('Pixel'), ylabel('Frequency');

