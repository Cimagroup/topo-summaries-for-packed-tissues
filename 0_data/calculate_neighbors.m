function [neighs_real, neighs_valid]=calculate_neighbors(L_img, valid_cells)
%------------------------------------------------------------------------------
% This function create the contact graph dilatating each tissue cell and
% calculating with which cells intersects.
% input: a matrix [L_img] representing an image divided in labelled regions 
% and a list of the valid regions [valid_cells]
% output: a matlab cell array [neighs_real] with all neighbors of the 
% region i in neighs_real{i} and another matlab cell array [neighs_valid] 
% with all neighbors which are valid regions in neighs_valid{i}
%------------------------------------------------------------------------------

ratio=5;
se = strel('disk',ratio);
cells=sort(unique(L_img));
cells=cells(2:end);
neighs_real=cell(1,length(cells));
neighs_valid = cell(1,length(cells));

    for cel = cells'
        BW = bwperim(L_img==cel);
        BW_dilate=imdilate(BW,se);
        neighs=unique(L_img(BW_dilate==1));
        neighs_real{cel}=neighs((neighs ~= 0 & neighs ~= cel));
        neighs_valid{cel}= neighs_real{cel}(ismember(neighs_real{cel},... 
                                                    valid_cells));
    end
end
