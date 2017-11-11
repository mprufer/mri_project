function [phantom] = GeneratePhantoms(type, size, inRectSize) 
    N = 256;
    DEFAULT_SIZE = [N, N];
    DEFAULT_RECT_RATIO = [0.1, 0.6];    
    CIRCLE_COLOR = 100;
    WHITE = 255;
    LIGHT_GRAY = 190;
    DARK_GRAY = 157;
    Gray = 220;
    Light_Gray = 190;
    Grey = 150;
    Dark_Grey = 100;
    HALF_INTENSITY = 127;

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
    phantom = fillCircle(phantom, BIG_CENTER, BIG_RADIUS, CIRCLE_COLOR);
    if(type == 4)
        %fill 5 small circles
        circles = [];
        for i = 5:-1:1
            circles(i).center = [BIG_CENTER(1) BIG_CENTER(2)];
        end    
        circles(1).radius = floor( min(phtsize)/50);
        circles(2).radius = floor(2.5 * circles(1).radius);
        circles(3).radius = floor(2.5 * circles(2).radius);
        circles(4).radius = floor(2.5 * circles(3).radius);
        circles(5).radius = floor(2.5 * circles(4).radius);
                
        %fill 5 small circles
        phantom = fillCircle(phantom, circles(5).center, circles(5).radius, HALF_INTENSITY);
        phantom = fillCircle(phantom, circles(4).center, circles(4).radius, Grey);
        phantom = fillCircle(phantom, circles(3).center, circles(3).radius, Light_Gray);
        phantom = fillCircle(phantom, circles(2).center, circles(2).radius, Gray);
        phantom = fillCircle(phantom, circles(1).center, circles(1).radius, WHITE);
    
    elseif(type == 3)
        %rectangle1
        startx = BIG_CENTER(2) - 50;
        starty = BIG_CENTER(1) + 10;
        endx = startx + 40;
        endy = starty + 50;

        phantom(startx:endx, starty:endy) = LIGHT_GRAY;
        
        %rectangle2
        startx = BIG_CENTER(2) + 10;
        starty = BIG_CENTER(1) + 15;
        endx = startx + 40;
        endy = starty + 60;

        phantom(startx:endx, starty:endy) = DARK_GRAY;
        
        %rectangle3
        startx = BIG_CENTER(2);
        starty = BIG_CENTER(1) - 60;
        endx = startx + 30;
        endy = starty + 40;

        phantom(startx:endx, starty:endy) = LIGHT_GRAY;
        
        %rectangle4
        startx = BIG_CENTER(2) - 70;
        starty = BIG_CENTER(1) - 50;
        endx = startx + 60;
        endy = starty + 20;

        phantom(startx:endx, starty:endy) = DARK_GRAY;
    elseif(type == 2)
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
            phantom = fillCircle(phantom, circles(i).center, circles(i).radius, WHITE);
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
        
        phantom(startx:endx, starty:endy) = WHITE;
    end
    
    phantom = uint8(phantom);    
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