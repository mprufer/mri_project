function [klines kpoints acq_img] = kStep(kStepNo, image, trajInfo)

    acq_img = image;
    %kStepNo reduces the number of lines and the number of points per line
    klines = round(trajInfo.num_lines *(kStepNo/10));
    kpoints = round(trajInfo.num_points_per_line *(kStepNo/10));
    
    %kstep function for Cartesian
    if(strcmp(trajInfo.method, 'Cartesian'))
        wb = waitbar(0,'Please wait...');
    
        N = length(image);
        k = [round(N/klines), round(N/kpoints)];
        %k = [kStepNo, kStepNo]; %direct kStepNo < 3, best image clarity
        M = floor(N*k);
        I = zeros(M(1), M(2));
        I(1:N, 1:N) = image;

        F = fftshift(fft2(I)); %computing k-space
        F2 = zeros(M(1),M(2));

        waitbar(1/4)
    
        % sampling intervals 
        Sample = interp2(F, (M(2)/2-floor(N/2):k(2):M(2)/2+floor(N/2)-1)',(M(1)/2-floor(N/2):k(1):M(1)/2+floor(N/2)-1), 'bicubic');

        S = size(Sample);

        waitbar(2/4)
    
        F2(M(1)/2-floor(S(1)/2)+1:(M(1)/2+floor(S(1)/2)),  M(2)/2-floor(S(2)/2)+1:(M(2)/2+floor(S(2)/2))) = Sample;
    
        F2(isnan(F2)) = 0;
        IF2 = (ifft2(fftshift(F2)));
        IF2 = abs((IF2));
    
        %res_IF2 = imresize(IF2((N/2+1):N*2.5, (N/2+1):N*2.5), 0.5);
    
        waitbar(3/4)
    
        res_IF2 = imresize(IF2, size(IF2)./k);
        acq_img = res_IF2;
        acq_img = acq_img/(max(acq_img(:))) * 255;
        
        %crop image result
        [height, width, dim] = size(acq_img);
        crop_size = 199;
        ycrop_start = floor((height-crop_size)/2);
        ycrop_end = ycrop_start + crop_size;
        xcrop_start = floor((width-crop_size)/2);
        xcrop_end = xcrop_start + crop_size;
        acq_img = acq_img(ycrop_start:ycrop_end, xcrop_start:xcrop_end, :); 

        waitbar(4/4)    
        close(wb)
    end
    
    if(strcmp(trajInfo.method, 'Radial'))
        rad_img = MRI_radial(image, klines, kpoints);
        
        %crop image result
        [height, width, dim] = size(rad_img);
        crop_size = 199;
        ycrop_start = floor((height-crop_size)/2);
        ycrop_end = ycrop_start + crop_size;
        xcrop_start = floor((width-crop_size)/2);
        xcrop_end = xcrop_start + crop_size;
      	acq_img = rad_img(ycrop_start:ycrop_end, xcrop_start:xcrop_end, :);
    end
    
    
    handles.trajInfo.num_lines = klines;
    handles.trajInfo.num_points_per_line = kpoints; 

end


