function [resultImg message] = kStep(sXCoor, eXCoor, sYCoor, eYCoor, img)
    if(sXCoor == 1)
        xActualStart = 1;
    else
        xActualStart = (sXCoor-1)*8;
    end
    xActualEnd = (eXCoor)*8;
    if(sYCoor == 1)
        yActualStart = 1;
    else
        yActualStart = (sYCoor-1)*8;
    end
    yActualEnd = (eYCoor)*8;
    
    N1 = size(img);
    xTotal = xActualEnd - xActualStart;
    yTotal = yActualEnd - yActualStart;
    
    
    I(1:N1, 1:N1) = img;
    F = fftshift(fft2(I));
    I = F(xActualStart:xActualEnd, yActualStart:yActualEnd);
    
    I = abs(ifft2((I)));
    I = uint8(real(I));
    
    %resize image
    resultImg = imresize(I, [256 256]);
    message = 'Image succesfully rendered';
end


