%-------------------------------------------------------------------------
% input: An integer representing the ammount of cells [cell_number] we want 
% to extract from files in cell_data with any of the [tags] appearing as a 
% substrin in its name.
% output: create a folder pointclouds/number/ and save there all point
% clouds with format: type_ID_pc.txt. For example CVT001_2_pc.txt.
% Create a folder sample_of_cells/number/ and save there the list of cells
% given by the spiral algorithm as type_ID_list.mat.
% This script may take some minutes time to run.
%
% This script may take some minutes to run.
%-------------------------------------------------------------------------

cell_number = 187;
tags = {'dWL','dWP','cNT','dNP','CVT','cEE_02','cEE_03','cEE_04',...
        'cEE_05','cEE_06','cEE_07','cEE_08','cEE_09','cEE_1'};

%cell_number = 257;
%tags = {'cNT','dNP', 'dWL','dWP','CVT'};

% filter all data appearing in mat_data/ and takes only the ones with
% a string from [type] in their names
imgs=dir('cell_data/*.mat');
n = length(imgs);
aux = zeros(1, n);
for i=1:n
    aux(i) = contains(imgs(i).name, tags);
end
imgs = imgs(logical(aux));
mkdir(strcat('point_clouds/',num2str(cell_number)));
mkdir(strcat('sample_of_cells/',num2str(cell_number)));

for ii=1:size(imgs,1)
    tissue_data=sprintf('cell_data/%s',imgs(ii,1).name);
    load(tissue_data)
    % The data corresponding to each cell is given by
    %   L_img: an image where each region corresponds to a cell and 
    %   their boundaries are marked with a 0.
    %   valid_cells: list of cells which do not intersect with the 
    %   boundary of the image.
    %   cell_info: information of each cell given by regionprop, it 
    %   includes its centroid.
    [list]=spiral(L_img,valid_cells,cell_number);
    % a warning is displayied if there were not enough valid cells
    if list(end)==0
        disp(strcat('WARNING: we could not obtain the desired ',...
        ' number for: ' ,tissue_data))
    end

    filename=strcat('sample_of_cells/',...
    num2str(cell_number),'/',imgs(ii,1).name(1:(end-8)),'list');
    save(filename, 'list');

    point_cloud=zeros(length(list),2);
    for i=1:length(list)
        point_cloud(i,:)=cellInfo(list(i)).Centroid;
    end
    namePlot=strcat('point_clouds/',...
    num2str(cell_number),'/',imgs(ii,1).name(1:(end-8)),'pc.txt');
    fid = fopen(namePlot,'wt');
    for j = 1:size(point_cloud,1)
        fprintf(fid,'%g  ',point_cloud(j,:));
        fprintf(fid,'\n');
    end
    fclose(fid);
end
