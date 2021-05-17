# Topological Summaries for Packed Tissues
This is the computational experiment which appeared in the paper
"Stable topological summaries for analysing the organization of cells in a packed 
tissue". We use TDA to prove the existence of significant 
differences in the topological-geometrical organization of 2D epithelial
tissues. Functions must be executed in the following order:

1) Follow the numerical order of the folders
2) Inside each folder, execute only functions begining with a capital letter
   following the alphabetic order.

The following software is required:
- Matlab/Octabe
- python
- R
- Jupyter with R kernel

The working folder must be the same where the executed function is stored.
If you have any doubt or comment about the code, you can email to 
msoriano4 at us dot es

----------
0_data/
----------

The folder original_data/ contains: images from epithelial tissues saved in
original_data/epithelial_images/ and info about the CVT-path images saved as 
.mat files in CVT/
We will obtain the .mat file from the epithelial images and the png images from
the CVT 

A_calculate_epithelial_images.m takes the epithelial images and transform them 
to black&white png files.

B_calculate_epithelial_data.m obtain the labeled image from the png images and 
use regionprops to obtain the data from images and save them in cell_data/

	auxiliar functions: calculate_neighboors.m

C_calculate_CVT.m extract the original black&white png images from each .mat 
file, save them in cell_images/ and rename the mat data, saving it in 
cell_data/

D_extract_cells.m extract a list with the desired number of cells and its 
centroids following the spiral algorithm. A list with the tags of the selected
cells can be found in sample_of_cells/ and the point cloud formed by their
centroids in point_clouds/ 

	auxiliar function: spiral.m

number_valid_cells.ods is a table with the number of maximum cells in each
epithelial image

-----------
1_barcodes/
-----------

A_compute_clique.py reads files in 0_data/cell_data/ and in
0_data/sample_of_cells/ to calculate the barcodes from the sub/sup clique 
filtration. A txt with the barcode is saved in barcode_txt/ and its 
image in barcode_png/

B_compute_rips.R reads the point clouds in 0_data/point_clouds/ and calculte
the rips complex persistent homology. A txt with the barcode is saved
in barcode_txt/ and its image in barcode_png/

	auxiliar functions: load_pc.R, barcode_generator.R

------------
2_variables/
------------

A_tda_frame calculates the TDA variable from each of the barcodes and save them 
as a frame in the folder frames/

	auxiliar funtions: normaL1.R, normalization.R, send_infinity_to.R, shannon.R

B_network.py calculates some of the network variables and save them as a txt in
network_variables/

C_network.R read the network variables and save them as an R frame in frames/

---------------------
3_Analysis
---------------------

sta_N.ipynb contains the statistical analysis of the tda variables when the
fixed number of cells is N

RF_N.ipynb contains the random forest experiment with tda and network variables
when the fixed number of cells is N

boxplot_generator.R save the boxplot for each of the variables in boxplots/

------------------------
4_visualization
------------------------

A_plot_clique_filtration calculate the simplicial complex for the sub/sup 
clique filtration and saves them in filtration_images/


















