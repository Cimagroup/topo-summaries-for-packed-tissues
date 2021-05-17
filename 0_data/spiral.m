function list = spiral(regions, valid_regions, number)
%-------------------------------------------------------------------------
% input: an image segmentated in regions [regions], a list of regions not 
% intersecting the boundary of the img [valid_regions] the number of cells 
% we want to obtain [number].
%
% output: a [list] with the [number] of regions obtained following the 
% spiral  algorithm. If there were not enough regions, all valid regions 
% are included in the list.
%-------------------------------------------------------------------------

[extreme1, extreme2] = size(regions);
pos1=floor(length(regions)/2);
pos2=pos1;

j = 1;
list = zeros(1, number);

% (pos1,pos2) will be the starting point of our algorithm.
if regions(pos1,pos2)~=0
    list(j)=regions(pos1,pos2);
    j = j + 1;
end

% We look for cells rounding our starting point and stop when arriving
% desired number of cells or to the boundaries of the image.
i = 1;
while j <= number && pos1 < extreme1 && pos2 < extreme2 ...
        && pos1>0 && pos2>0
    Xaux = 1;
    Yaux = 1;
    while Yaux <= i && j <= number && pos2 < extreme2 ...
        && pos1>0 && pos2>0
        pos2 = pos2 + (-1)^(i+1);
        Yaux = Yaux+1;
        if regions(pos1,pos2)~=0 && ~ismember(regions(pos1,pos2),list) &&...
                ismember(regions(pos1,pos2),valid_regions)
            list(j)=regions(pos1,pos2);
            j = j + 1;
        end
    end
    while Xaux <= i && j <= number && pos1 < extreme1 ...
            && pos2 < extreme2
    pos1 = pos1 + (-1)^(i+1);
    Xaux = Xaux+1;
        if regions(pos1,pos2)~=0 && ~ismember(regions(pos1,pos2),list) &&...
                ismember(regions(pos1,pos2),valid_regions) 
            list(j)=regions(pos1,pos2);
            j = j + 1;
        end
    end
    i = i+1;
end


end