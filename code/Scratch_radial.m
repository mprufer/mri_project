function kStep(sXCoor, eXCoor, sYCoor, eYCoor, img)
    xActualStart = (sXCoor-1)*8;
    xActualEnd = (eXCoor)*8;
    yActualStart = (sYCoor-1)*8;
    yActualEnd = (eYCoor)*8;
    disp(xActualStart);
    disp(xActualEnd);
    disp(yActualStart);
    disp(yActualEnd);
    
    N1 = size(img);
    xTotal = xActualEnd - xActualStart;
    yTotal = yActualEnd - yActualStart;
    
    
    I(1:N1, 1:N1) = img;
    F = fftshift(fft2(I));
    I = F(xActualStart:xActualEnd, yActualStart:yActualEnd);
    
    I = abs(ifft2((I)));
    I = uint8(real(I));
    %I = I/(max(I(:))) * 255;
  
    imshow(I);
end


