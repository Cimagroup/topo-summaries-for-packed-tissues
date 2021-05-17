
%-------------------------------------------------------------------------
%   Takes the .mat files in original_data/CVT/ and save them in
% cell_data/ with a new name following the format: type_ID_data.mat
% it also save the image in cell_images with format: type_ID_img.png
%
%   Examples: CVT001_15_data.mat, CVT005_02_data.mat, CVT010_02_img.png
%-------------------------------------------------------------------------

clearvars
% We will only consider files including these labels.
% In this case, we only consider the steps 1, 4 and 5 in the CVT-path
labels={'001','004','005'};

for idL = 1 : numel(labels)
    path = 'original_data/CVT/';
    imgs=dir(sprintf(strcat(path,'%s/*.mat'),labels{idL}));
    
    for idF=1:size(imgs,1)

        tissue_data=sprintf(strcat(path,'%s/%s'),...
            labels{idL},imgs(idF,1).name);
        load(tissue_data)
        % Set 1 to pixels which represent cells and a 0 to boundaries
        L_img = l_img;
        img = L_img<1;
        img = ~img;
        % Add a fake cell to the boundary of the image
        img(:,[2,1023]) = 0;
        img([2,1023],:) = 0;
        img(:,[1,1024]) = 1;
        img([1,1024],:) = 1;
        
        neighs_valid = cell(1,length(neighs_real));
        for i = 1:length(neighs_valid)
            neighs_valid{i} = neighs_real{i}(ismember(neighs_real{i},...
                                                        valid_cells));
        end
        
        if length(tissue_data)==72
            tissue_data;
            save(strcat('cell_data/','CVT',labels{idL},'_',...
                        tissue_data(29:30),'_data'),...
                        'cellInfo', 'L_img', 'neighs_real',...
                        'neighs_valid', 'valid_cells')
            imwrite(img, strcat('cell_images/','CVT',labels{idL},'_',...
                        tissue_data(29:30),'_img.png'))
        elseif length(tissue_data)==71
            save(strcat('cell_data/','CVT',labels{idL},'_0',...
                        tissue_data(29),'_data'),...
                        'cellInfo', 'L_img', 'neighs_real',...
                        'neighs_valid', 'valid_cells')
            imwrite(img, strcat('cell_images/','CVT',labels{idL},'_0',...
                    tissue_data(29),'_img.png'))
        end
    end
end
