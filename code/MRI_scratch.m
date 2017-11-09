
%% Cartesian Sampling
clear all;

img = phantom(256);
klines =17;
kpoints = 512;

N = length(img);
k = [N/klines, N/kpoints];
M = floor(N*k);
I = zeros(M(1), M(2));
I(1:N, 1:N) = img;
F = fftshift(fft2(I));
F2 = zeros(M(1),M(2));

%G = fspecial('gaussian', 5, 1);
%F = imfilter(F, G);

% sampling intervals 
Sample = interp2(F, (M(2)/2-N/2:k(2):M(2)/2+N/2-1)',(M(1)/2-N/2:k(1):M(1)/2+N/2-1), 'bicubic');

S = size(Sample);

F2(M(1)/2-S(1)/2+1:(M(1)/2+S(1)/2),  M(2)/2-S(2)/2+1:(M(2)/2+S(2)/2)) = Sample;

F2(isnan(F2)) = 0;

IF2 = (ifft2(fftshift(F2)));
IF2 = abs((IF2));

%res_IF2 = imresize(IF2((N/2+1):N*2.5, (N/2+1):N*2.5), 0.5);

res_IF2 = imresize(IF2, size(IF2)./k);
acq_img = res_IF2;

acq_img = acq_img/(max(acq_img(:))) * 255;

%% display
subplot(2,2,1); 
imshow(I);
title('Phantom');
subplot(2,2,2);
imshow(log(abs(F)+1), []);
title('Phantom FFT');
subplot(2,2,3);
imshow(acq_img, []);
title('Inverse FFT');
subplot(2,2,4);
imshow(log(abs(F2)+1), []);
title('Averaged FFT');


