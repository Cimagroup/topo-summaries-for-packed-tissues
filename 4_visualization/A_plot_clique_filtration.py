"""
#------------------------------------------------------------------------------
# Plot the sub/sup filtrations over the original image.
# Images are saved in filtration_images/
# This script may take some minutes to run
#------------------------------------------------------------------------------
"""
import scipy.io as sio 
import networkx as nx
from PIL import Image
from PIL import ImageDraw
import os

#num_cells = 257
#types = ['dWL', 'dWP']

num_cells = 187
types = ['dWL','dWP','dNP','cNT', 'CVT','cEE_02','cEE_03','cEE_04','cEE_05',
         'cEE_06','cEE_07','cEE_08','cEE_09','cEE_1']

#Create these folders the first time you run the experiment for a num_cells
#!! coment this lines if the folders have already been created
#os.mkdir("filtration_images/"+str(num_cells)+"/")
#os.mkdir("filtration_images/"+str(num_cells)+"/sub")
#os.mkdir("filtration_images/"+str(num_cells)+"/sup")


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
    filtration = []
    
    for ver in vertexes:
        filtration.append([[ver[0]], ver[1]])
        
    for face in cliques:
        aux = max([x[1] for x in vertexes if x[0] in face])
        filtration.append([face, aux]);

    return(filtration)
    

#Filter archivos in folder to obtain the ones with the desired types
path = '../0_data/cell_images/'
is_type = lambda y : any([(x in y) for x in types])
archivos = map(is_type, os.listdir(path))
archivos = zip(os.listdir(path), archivos)
archivos = [ x[0] for x in archivos if x[1]==True ]

for archivo in archivos:  
    
    back = Image.open(path  +'/'+ archivo)
    back = back.convert('RGBA')
    poly = Image.new('RGBA', back.size)
    draw = ImageDraw.Draw(poly)
    
    pc = open('../0_data/point_clouds/'+str(num_cells)+'/'+archivo[:-7]+
              'pc.txt')
    aux = pc.readlines()
    pc.close()
    puntos = [line[:-3] for line in aux]
    X = []
    Y = []
    matriz = []
    
    for linea in puntos:
        x = ''
        while linea[0].isnumeric() or linea[0]=='.':
            x= x + linea[0]
            linea = linea[1:]
        
        while linea[0]==' ':
            linea = linea[1:]
            
        y = ''
        #not not linea checks if linea == ''
        while (not not linea) and (linea[0].isnumeric() or linea[0]=='.'):
            y= y + linea[0]
            linea = linea[1:]
        
        X.append(float(x))
        Y.append(float(y))
        matriz.append((float(x), float(y)))
        
    draw.point(matriz,  fill = 'red')
    #plt.imshow(img) 
    
    mat1 = sio.loadmat('../0_data/cell_data/'+archivo[:-7]+'data.mat')
    mat2 = sio.loadmat('../0_data/sample_of_cells/'+str(num_cells)+'/'+
                       archivo[:-7]+'list.mat')
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
    maxx = 15
    vertexes_sub = list(zip(sample_cells, map(lambda x: len(x), neighboorhood)))
    filtration_sub = create_filtration(vertexes_sub, cliques)
    
    
    folder = "filtration_images/"+str(num_cells)+"/sub/" + archivo[:-8]
    #!!!! coment this line if the folders have already been created
    #os.mkdir(folder)
    for step in range(maxx+1):
        for aux in  filtration_sub:
            if aux[1] <= step:
                vs = []
                for i in aux[0]:
                    vs.append(matriz[sample_cells.index(i)])
                if len(vs) > 1:
                    draw.polygon(vs, fill='blue', outline = 'yellow')
                if len(vs) == 1:
                    r = 3
                    center = vs[0]
                    lr = (center[0] + r, center[1] + r)
                    ul = (center[0] - r, center[1] - r)
                    draw.ellipse(ul + lr, fill = 'red')
                
        poly.putalpha(128)
        #back.paste(poly, mask = poly)
        img = Image.alpha_composite(back, poly)
        img.save( folder+ '/' +archivo[:-7] + str(step) + '.png')
    
    back = Image.open(path +'/'+ archivo)
    back = back.convert('RGBA')
    poly = Image.new('RGBA', back.size)
    draw = ImageDraw.Draw(poly)
    draw.point(matriz,  fill = 'red')
    vertexes_sup = list(zip(sample_cells,
                        map(lambda x: maxx-len(x), neighboorhood)))
    filtration_sup = create_filtration(vertexes_sup, cliques)
    #!!!! coment this line if the folders have already been created
    #os.mkdir(folder)
    for step in range(maxx+1):
        for aux in  filtration_sup:
            if aux[1] <= step:
                vs = []
                for i in aux[0]:
                    vs.append(matriz[sample_cells.index(i)])
                if len(vs) > 1:
                    draw.polygon(vs, fill='blue', outline = 'yellow')
                if len(vs) == 1:
                    r = 3
                    center = vs[0]
                    lr = (center[0] + r, center[1] + r)
                    ul = (center[0] - r, center[1] - r)
                    draw.ellipse(ul + lr, fill = 'red')
        poly.putalpha(128)
        #back.paste(poly, mask = poly)
        img = Image.alpha_composite(back, poly)
        img.save( folder+ '/' +archivo[:-7] + str(step) + '.png')
    
    
    
