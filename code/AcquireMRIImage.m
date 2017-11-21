function [resultImg message] = AcquireMRIImage(inputImg, trajInfo)
    resultImg = inputImg;
    if(strcmp(trajInfo.method, 'Cartesian'))
        resultImg = MRI_Cartesian(inputImg, ...
            trajInfo.num_lines, trajInfo.num_points_per_line);
    end
    
    if(strcmp(trajInfo.method, 'Radial'))
        resultImg = MRI_radial(inputImg, ...
            trajInfo.num_lines, trajInfo.num_points_per_line);
    end
   
    
    %resultImg = inputImg;
    message = 'Successfully accquisiting data';
end