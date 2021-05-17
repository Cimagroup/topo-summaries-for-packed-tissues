%-------------------------------------------------------------------------
% This script read .bmp images from original_data/epithleial_images,  
% invert their color and save them again in cell_images/ with the name 
% format:type_ID_img.png
%
% Examples: cNT_01_img.png, dWL_12_img.png
%
%-------------------------------------------------------------------------
clearvars
labels = {'cEE', 'cNT', 'dWL', 'dNP', 'dWP'};
%labels = {'cNT'};

% Loop over the labels and images with that label
for idL = 1 : numel(labels)
    path = 'original_data/epithelial_images/';
    imgs=dir(sprintf(strcat(path,'%s/*.bmp'),labels{idL}));
    
    for idF=1:size(imgs,1)
        tissue_data=sprintf(strcat(path,'%s/%s'),...
                labels{idL},imgs(idF,1).name);

        L_img = imread(tissue_data);
%------ Change images to binary matrix and save them ------%
        if ndims(L_img) == 3
            L_img = rgb2gray(L_img);
        end
        % Set 1 to pixels which represent cells and a 0 to boundaries
        L_img = L_img<1;
        % Add a fake cell to the boundary of the image
        L_img(:,[2,1023]) = 0;
        L_img([2,1023],:) = 0;
        L_img(:,[1,1024]) = 1;
        L_img([1,1024],:) = 1;
        
        filename = sprintf(strcat('cell_images/%s'),imgs(idF,1).name);

        if length(filename) == 20
            filename = filename(1:end-4);
            filename = strcat(filename(1:end-1), '_0', filename(end),...
                        '_img.png');
        elseif length(filename) == 21
            filename = filename(1:end-4);
            filename = strcat(filename(1:end-2), '_',...
                                filename(end-1:end), '_img.png');
        end
        
        imwrite(L_img, filename)
    end
end
