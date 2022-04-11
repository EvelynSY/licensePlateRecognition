% Cut out a single character
function [char, result] = getChar(d) 

char = []; flag = 0; y1 = 8; y2 = 0.5;  
    while flag == 0  
        [m,n] = size(d);  
        wide = 0;  
        while sum(d(:,wide+1)) ~= 0 && wide <= n-2   % As long as it is not equal to zero, keep running until you find the boundary
            wide = wide+1;  
        end  
        temp = cutOutSmallestArea(imcrop(d,[1 1 wide m]));  
        [m1,n1] = size(temp);  
        if wide < y1 && n1/m1 > y2  
            d(:,[1:wide]) = 0;  
            if sum(sum(d)) ~= 0  
                d = cutOutSmallestArea(d);   % Cut out the smallest area 
            else char = []; flag = 1;  
            end  
        else  
            char = cutOutSmallestArea(imcrop(d,[1 1 wide m]));  
            d(:,[1:wide]) = 0;  
            if sum(sum(d)) ~= 0;  
                d = cutOutSmallestArea(d); flag = 1;  
            else d = [];  
            end  
        end  
    end  
  
result = d;