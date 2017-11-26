function [acq_img message] = kStep(kStepNo, image, trajInfo)

    acq_img = image;
    %imshow(image, [0 max(image(:))]);
    
    [height, width, dim] = size(image);
    crop_size = 120;
    ycrop_start = floor((height-crop_size)/2);
    ycrop_end = ycrop_start + crop_size;
    xcrop_start = floor((width-crop_size)/2);
    xcrop_end = xcrop_start + crop_size;
    image = image(ycrop_start:ycrop_end, xcrop_start:xcrop_end, :); 
    N = length(image);

    klines = floor(trajInfo.num_lines/kStepNo);
    kpoints = floor(trajInfo.num_points_per_line/kStepNo);
    disp(klines);
    disp(kpoints);
    disp(kStepNo);
    
    if(strcmp(trajInfo.method, 'Cartesian'))
        acq_img = MRI_Cartesian(image, klines, kpoints);
    end
    
    if(strcmp(trajInfo.method, 'Radial'))
        acq_img = MRI_radial(image, klines, kpoints);
    end
    
    message = 'Successfully accquisiting data';
end


