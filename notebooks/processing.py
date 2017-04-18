import graph_tool as gt
from graph_tool.inference import minimize_blockmodel_dl, minimize_nested_blockmodel_dl
from graph_tool.draw import prop_to_size
import numpy as np
from scipy.sparse import dok_matrix
import pickle

co_mat = pickle.load(open("co_mat.pkl", "rb"))
n = 200
dense = co_mat[:n, :n].todense()
diag = np.diag(dense)
total = np.repeat(np.matrix(diag), diag.shape[0], axis=0) + np.repeat(np.matrix(diag).T, diag.shape[0], axis=1)
dense = (dense - diag * np.eye(dense.shape[0], dtype="uint32")) / total

labels = pickle.load(open("label_names.pkl", "rb"))

# discretise
dense = (dense >= 0.05) * 1

g = gt.Graph()
g.add_edge_list(np.transpose(dense.nonzero()))
# state = minimize_blockmodel_dl(g, deg_corr=False)
# state.draw(output="sbm-fit.svg")
label = g.new_vertex_property("string")
label.set_2d_array(np.array(labels[:n]))
state = minimize_nested_blockmodel_dl(g, deg_corr=True)
state.draw(output="hsbm-fit.svg", 
           vertex_text=label, 
           output_size=(1500, 1500), 
           deg_size=False,
           vertex_text_position="centered",
           fit_view=0.8)