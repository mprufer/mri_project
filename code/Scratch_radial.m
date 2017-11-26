function kStep(sXCoor, eXCoor, sYCoor, eYCoor, img)
    xActualStart = (sXCoor-1)*8;
    xActualEnd = (eXCoor-1)*8;
    yActualStart = (sYCoor-1)*8;
    yActualEnd = (eYCoor-1)*8;
    disp(xActualStart);
    disp(xActualEnd);
    disp(yActualStart);
    disp(yActualEnd);
  
    imshow(img, [0 max(img(:))]);
end


