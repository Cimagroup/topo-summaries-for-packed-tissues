"""
#------------------------------------------------------------------------------
#  Takes the files in mat_data with information about the cell tissues and 
# calculate their average number of neirhboors, its variance and the 
# distribution of the degrees. Save the data frame as a .csv in frames/
#------------------------------------------------------------------------------
"""
import os
import numpy as np
import scipy.io as sio


num_cells = 187
types = ['dWL','dWP','dNP','cNT', 'CVT','cEE_02','cEE_03','cEE_04','cEE_05',
         'cEE_06','cEE_07','cEE_08','cEE_09','cEE_1']
#num_cells = 257
#types = ['cNT', 'dNP', 'dWL', 'dWP', 'CVT']


#Create these folders the first time you run the experiment for a num_cells
#os.mkdir("network_variables/"+str(num_cells)+"/")

folder = '../0_data/cell_data/'
#Filter archivos in folder to obtain the ones with the desired types
is_type = lambda y : any([(x in y) for x in types])
archivos = map(is_type, os.listdir(folder))
archivos = zip(os.listdir(folder), archivos)
archivos = [ x[0] for x in archivos if x[1]==True ]


for archivo in archivos:  
    aux = []
    mat1 = sio.loadmat(folder + archivo)
    mat2 = sio.loadmat('../0_data/sample_of_cells/' +
                       str(num_cells) + '/' + (archivo[:-8]+'list.mat'))
    
    sample_cells =  list(map(int, mat2["list"][0])) 

    indexes = list(map(lambda x: x-1, sample_cells))
    # We make the n-th neighboor in neighboorhood correspond with the n-th
    #sample cell
    neighboorhood = mat1["neighs_real"][0][indexes]
    
    neigs_len = list(map(len, neighboorhood))
    meann = sum(neigs_len)/num_cells
    aux.append(meann)
    aux.append(
            sum([(x - meann)**2/num_cells for x in neigs_len])
            )
    aux.append(len(list(filter(lambda y : y == 2, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 3, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 4, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 5, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 6, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 7, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 8, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 9, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 10, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 11, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 12, neigs_len))))
    aux.append(len(list(filter(lambda y : y == 13, neigs_len))))
    
    np.savetxt("network_variables/"+str(num_cells)+'/'+archivo[0:-8]+
               'network.txt', np.array(aux))