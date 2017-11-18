function kStep(kStepNo, image, trajInfo)
    disp(trajInfo.num_lines/2);
    disp(trajInfo.num_points_per_line/2);
    disp(kStepNo);
    
    imshow(image, [0 max(image(:))]);
end


