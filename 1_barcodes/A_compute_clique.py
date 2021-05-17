"""
#------------------------------------------------------------------------------
#  Takes files in mat_data with information about the cell tissues and 
# calculate their corresponding sub/sup complexes and barcodes. We save their 
# images in barcodes_png/"num_cells/sub/, and  
# in barcodes_png/"num_cells"/sup/ respectively.
# All barcodes are also saved as .txt in barcodes_txt/"num_cells"/sub/ and
# barcodes_txt/"num_cells"/sup/ 
#------------------------------------------------------------------------------
"""


import os
import scipy.io as sio
import networkx as nx
import gudhi
import numpy as np
import matplotlib.pyplot as plt


#num_cells = 257
#types = ['cNT', 'dNP', 'dWL','dWP', 'CVT']

num_cells = 187
types = ['dWL', 'dWP', 'cEE_02', 'cEE_03', 'cEE_04', 'cEE_05', 'cEE_06', 
         'cEE_07', 'cEE_08', 'cEE_09', 'cEE_1', 'dNP', 'cNT', 'CVT']


#Create these folders the first time you run the experiment for a num_cells
#os.mkdir("barcodes_txt/"+str(num_cells)+"/")
#os.mkdir("barcodes_txt/"+str(num_cells)+"/sub")
#os.mkdir("barcodes_txt/"+str(num_cells)+"/sup")
#os.mkdir("barcodes_png/"+str(num_cells)+"/")
#os.mkdir("barcodes_png/"+str(num_cells)+"/sup")
#os.mkdir("barcodes_png/"+str(num_cells)+"/sub")

#############################
#### Auxiliar functions ####
###########################
    
def create_graph(cells, neighboorhood):
    """ 
    Input: Takes a sorted list with the valid [cells] and a list of list  with 
    each cell's neigboors, [neighboorhood].
    
    Output: a list of lists with all cliques in the graph, including edges.
    """
    G = nx.Graph()
    G.add_nodes_from(cells)
    for i in range(len(cells)):
        neighboors = neighboorhood[i]
        neighboors = list(filter(lambda x: cells[i]< x, neighboors))
        G.add_edges_from(zip([cells[i]]*len(neighboors), neighboors))
        
    cliques = list(filter(lambda x: len(x)>1, nx.enumerate_all_cliques(G)))
    return(cliques)

def create_filtration(vertexes, cliques):
    """ 
    Input: Takes a list of pairs [vertexes] with the tag of the vertex in the 
    left and its weight on the right, and a list of lists with all possible 
    [cliques] , including edges.
    
    Output: a gudhi simplex tree structure representing the clique filtration
    """
    filtration = gudhi.SimplexTree()
    
    for ver in vertexes:
        filtration.insert([ver[0]], filtration=ver[1]);
        
    for face in cliques:
        aux = max([x[1] for x in vertexes if x[0] in face])
        filtration.insert(face, filtration=aux);

    return(filtration)
    
#############################
####### Main script ########
###########################

#The first time we run the experiment, we calculate maxxx to check max(maxxx)
#is smaller than 15 as expected.
#maxxx = []
folder= '../0_data/cell_data/'
#Filter archivos in folder to obtain the ones with the desired types
is_type = lambda y : any([(x in y) for x in types])
archivos = map(is_type, os.listdir(folder))
archivos = zip(os.listdir(folder), archivos)
archivos = [ x[0] for x in archivos if x[1]==True ]

for archivo in archivos:  
    mat1 = sio.loadmat(folder + archivo)
    mat2 = sio.loadmat("../0_data/sample_of_cells/" +
                       str(num_cells) + '/' + (archivo[:-8]+"list.mat"))
    sample_cells =  list(map(int, mat2["list"][0])) 

    indexes = list(map(lambda x: x-1, sample_cells))
    # We make the n-th neighboor in neighboorhood correspond with the n-th
    #sample cell
    neighboorhood = mat1["neighs_valid"][0][indexes]
    
    #Each neighboors of a cell are matrix arrays, we transform them first in 
    #vector arrays and then to a list.
    simplifier = lambda arr_aux : arr_aux[:,0].tolist()
    neighboorhood = list(map(simplifier, neighboorhood))

    #We filter the valid cells by the sample cells
    for i in range(len(neighboorhood)):
        neighboorhood[i] = list(filter(lambda x : x in sample_cells,
                                         neighboorhood[i]))


    cliques = create_graph(sample_cells, neighboorhood)
    
    # Create the filtration using the cliques
    vertexes_sub = list(zip(sample_cells, map(lambda x: len(x), neighboorhood)))
    filtration_sub = create_filtration(vertexes_sub, cliques)
    
    #maxxx.append(max(map(lambda x : x[1],  vertexes_sub)))
    #max(maxxx) = 14, which is smaller than 15 as expected.
    
    maxx = 15
    vertexes_sup = list(zip(sample_cells,
                            map(lambda x: maxx-len(x), neighboorhood)))
    filtration_sup = create_filtration(vertexes_sup, cliques)
    
    

    dgm = filtration_sub.persistence()
    brc = gudhi.plot_persistence_barcode(dgm, alpha = 1, max_intervals = 0)
    #max_barcoes = 1000 avoid a warning and have no effect on the function
    plt.savefig("barcodes_png/"+str(num_cells)+"/sub/"+archivo[0:-8]+'bar.png')
    plt.close()
    dgm = list(map(lambda x : np.array([x[0], x[1][0], x[1][1]]), dgm))
    dgm = np.matrix(dgm)
    np.savetxt("barcodes_txt/"+str(num_cells)+"/sub/"+archivo[0:-8]+'barcode.txt',
               dgm)
    
        
    dgm = filtration_sup.persistence()
    brc = gudhi.plot_persistence_barcode(dgm, alpha = 1, max_intervals = 0)
    plt.savefig("barcodes_png/"+str(num_cells)+"/sup/"+archivo[0:-8]+'bar.png')
    plt.close()
    dgm = list(map(lambda x : np.array([x[0], x[1][0], x[1][1]]), dgm))
    dgm = np.matrix(dgm)
    np.savetxt("barcodes_txt/"+str(num_cells)+"/sup/"+archivo[0:-8]+'barcode.txt',
               dgm)
