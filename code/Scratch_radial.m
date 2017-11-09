  
%% Radial Sampling
clear all;

img = phantom(256);
lines =120;
points = 256;

    N1 = size(img);
    sampling = (N1(1)/points);
    N = N1(1)*9*sampling;
    I = zeros(N, N);
    I(1:N1(1), 1:N1(1)) = img;
    F = fftshift(fft2(I));

%% Obtain polar points to sample
    i=1;
    j=1;
    delT = lines;

    for r=-N/2:sampling*3:N/2
       for theta = 0:pi/delT:(pi-pi/delT)
           Rx(i, j) = r*cos(-theta)+ N/2;
           Ry(i, j) = r*sin(-theta)+ N/2;

           i = i+1;
       end
       j = j+1;
       i = 1;
    end
    
    %% Radial sampling

    % interpolate
    Rv = interp2(F, Rx, Ry, 'bicubic');
    Rv(isnan(Rv)) = 0;
% 
%     % plot
%     subplot(1,2,1);
%     imshow(log(abs(F)+1), [0,5]);
%     hold on
%     plot(Rx(4,:), Ry(4,:), 'r.');
%     hold off
%     subplot(1,2,2);
%     imshow(log(abs(Rv)+1)',[0,10])

%% Reconstruction

    IR = zeros(size(Rv));

    % 1D ifft
    for i = 1:delT
       IR(i, :) =fliplr(fftshift((abs(ifft((Rv(i, :))))))); 
    end

    % reconstruct from projections
    recons = iradon(IR', 180/delT);
    recons = fliplr(flipud(recons(17:N1+16, 17:N1+16)));

    acq_img = recons;



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
imshow(log(abs(IR)+1), []);
title('Averaged FFT');


