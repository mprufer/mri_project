function [phantom] = GeneratePhantoms(type, size, inRectSize) 
    N = 256;
    DEFAULT_SIZE = [N, N];
    DEFAULT_RECT_RATIO = [0.1, 0.6];    
    HALF_INTENSITY = 128;
    ONE_INTENSITY = 255;

    if(nargin == 1 || type == 2)
        phtsize = DEFAULT_SIZE;
    else
        phtsize = size;
    end

    %big circle
    BIG_RADIUS = floor(min(0.4*phtsize));
    BIG_CENTER = [floor(phtsize(2))/2 + 1, floor(phtsize(1))/2+1];
    UNIT_CENTER_DISTANCE = floor(BIG_RADIUS/5);

    %the background of phantom
    phantom = zeros(phtsize);

    %fill the big circle first                
    phantom = fillCircle(phantom, BIG_CENTER, BIG_RADIUS, HALF_INTENSITY);
    
    if(type == 2)
        %fill 5 small circles
        circles = [];
        circles(1).center = [BIG_CENTER(1) (BIG_CENTER(2)- floor(4.5 * UNIT_CENTER_DISTANCE))];
        circles(2).center = [BIG_CENTER(1) (BIG_CENTER(2)- 3 * UNIT_CENTER_DISTANCE)];
        circles(3).center = [BIG_CENTER(1) (BIG_CENTER(2)- 1 * UNIT_CENTER_DISTANCE)];
        circles(4).center = [BIG_CENTER(1) (BIG_CENTER(2)) + UNIT_CENTER_DISTANCE];
        circles(5).center = [BIG_CENTER(1) (BIG_CENTER(2) + floor(3.5 * UNIT_CENTER_DISTANCE))];

        circles(1).radius = floor( min(phtsize)/50);
        circles(2).radius = floor(1.5 * circles(1).radius);
        circles(3).radius = floor(1.5 * circles(2).radius);
        circles(4).radius = floor(1.5 * circles(3).radius);
        circles(5).radius = floor(1.5 * circles(4).radius);
                
        %fill 5 small circles
        for i = 1 : length(circles)
            phantom = fillCircle(phantom, circles(i).center, circles(i).radius, ONE_INTENSITY);
        end        
                
    elseif (type == 1)
        %fill the rectangular
        if(nargin >= 3)
            rectSize = inRectSize;
        else
            rectSize = floor([DEFAULT_RECT_RATIO(1)* phtsize(1), DEFAULT_RECT_RATIO(2)* phtsize(2)]);
        end
        
        startx = floor(BIG_CENTER(2) - rectSize(2)/2);
        starty = floor(BIG_CENTER(1) - rectSize(1)/2);
        endx = startx + rectSize(2)-1;
        endy = starty + rectSize(1) - 1;
        
        phantom(startx:endx, starty:endy) = ONE_INTENSITY;
    end
    
    phantom = uint8(phantom);    
    imwrite(phantom, sprintf('phantom_type%d.png', type));
end

function [outimg] = fillCircle(img, center, radius, FILL_VALUE)
%center and radius of the circle
    imgsize = size(img);
    if( (center(1)+radius- imgsize(1)) > 0 ||...
            ( (center(2)+radius - imgsize(2)) > 0 )...
            || ((center(1)- radius) < 0)||...
            ((center(1) - radius) <0))
        outimg = -1;
    else        
        radiussq = radius*radius;
        tworadius = 2*radius;
        
        for i  = (center(1) - radius) : (center(1) + radius)
            ytmp = floor(sqrt(radiussq - (center(1) - i)^2));
            ybar = [(center(2) - ytmp) : (center(2) + ytmp)];
            img(i, ybar) = FILL_VALUE;
%             img(tworadius+1-i, ybar) = FILL_VALUE;
        end

    end    
    outimg = img;
end