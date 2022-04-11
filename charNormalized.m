% Normalized character image
function d = charNormalized(d)  
[m,n] = size(d);  
%top 1/3, bottom 1/3  
for i = 1:round(m/3)  
    if sum(sum(d([i:i+0],:))) == 0  
        ii = i; d([1:ii],:) = 0;  
    end  
end  
for i = m:-1:2*round(m/3)  
    if sum(sum(d([i-0:i],:))) == 0  
        ii = i; d([ii:m],:) = 0;  
    end  
end  
if n ~= 1  
    d = cutOutSmallestArea(d);  
end  
% ¡®d=..¡¯ can be obtained by training
% d=imresize(d,[40 20]);   
d = imresize(d,[32 16], 'nearest'); % The normalized size in the commercial system program is 32*16  