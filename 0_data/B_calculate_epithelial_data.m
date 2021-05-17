%-------------------------------------------------------------------------
% This script read images in cell_images/ and uses regionprops to obtain
% information from it. Save the data in cell_data/ with the name 
% format:type_ID_data.mat.
%
% Examples: cNT_01_data.mat, dWL_12_data.mat
%
% Variables saved in the .mat files:
%   L_img: the original image with its regions labelled
%   cellInfo: information obtained from L_img using regionprops
%   valid_cells: cells which did not touch the boundary of the image
%   neighs_real: cell array with all neighboors
%   neighs_valid: cell array where neighboors are only valid cells
% 
% This script may take some minutes to run.
%-------------------------------------------------------------------------

clearvars
labels = {'cEE', 'cNT', 'dWL', 'dNP', 'dWP'};

% Loop over the labels and images with that label

imgs=dir('cell_images/*.png');
n = length(imgs);
aux = zeros(1, n);
for i=1:n
    aux(i) = contains(imgs(i).name, labels);
end
imgs = imgs(logical(aux));

for ii=1:size(imgs,1)
    filename=sprintf('cell_images/%s',imgs(ii,1).name);
    L_img = imread(filename);

%------ Calculate the labelled image ------%
        
    L_img = bwlabel(L_img);

%------ Calculate the properties of the regions ------%

    cellInfo = regionprops('struct', L_img, 'all');

%------ Calculate the valid cells ------%
    cells = sort(unique(L_img));
    cells = cells(2:end);
    valid_cells = zeros(1,length(cells));
    i = 1;
    %Valid cells are the ones which did not touch the original boudary
    %of the image, since we added a fake boundary cell, they must be
    %separated from it by more than 2 pixels
    for j = 1:length(cells)
        if ((1024 - max(max(cellInfo(cells(j)).PixelList)) > 2) && ...
              (min(min(cellInfo(cells(j)).PixelList)) - 1 > 2))
          valid_cells(i) = cells(j);
          i = i+1;
        end
    end

    valid_cells = valid_cells(valid_cells>0);

%------  Calculate the neighbourhoods ------%
    [neighs_real, neighs_valid]=calculate_neighbors(L_img, valid_cells);

%------  Save the file ------%
    filename = strcat('cell_data/',imgs(ii,1).name);
    %We assume the folder names have not been changed
    filename = filename(1:end-7);
    filename = strcat(filename,'data');

    save(filename, 'L_img', 'cellInfo', 'valid_cells', ...
        'neighs_real','neighs_valid');
end

