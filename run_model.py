from seirsplus.networks import *
import networkx

numNodes = 10000
baseGraph = networkx.barabasi_albert_graph(n=numNodes, m=9)
G_normal = custom_exponential_graph(baseGraph, scale=100)
# Social distancing interactions:
G_distancing = custom_exponential_graph(baseGraph, scale=10)
# Quarantine interactions:
G_quarantine = custom_exponential_graph(baseGraph, scale=5)

SIGMA = 1 / 5.2
GAMMA = 1 / 10
MU_I = 0.002
R0 = 2.5
BETA = 1 / (1 / GAMMA) * R0
BETA_Q = 0.5 * BETA
P = 0.2
Q = 0.05

model = SEIRSNetworkModel(G=G_normal,
                          beta=BETA,
                          sigma=SIGMA,
                          gamma=GAMMA,
                          mu_I=MU_I,
                          mu_0=0,
                          nu=0,
                          xi=0,
                          p=P,
                          G_Q=G_quarantine,
                          beta_Q=BETA_Q,
                          sigma_Q=SIGMA,
                          gamma_Q=GAMMA,
                          mu_Q=MU_I,
                          theta_E=0,
                          theta_I=0,
                          phi_E=0,
                          phi_I=0,
                          psi_E=1.0,
                          psi_I=1.0,
                          q=Q,
                          initI=numNodes / 100,
                          initE=0,
                          initQ_E=0,
                          initQ_I=0,
                          initR=0,
                          initF=0)

checkpoints = {'t': [20, 100],
               'G': [G_distancing, G_normal],
               'p': [0.5 * P, P],
               'theta_E': [0.02, 0.02],
               'theta_I': [0.02, 0.02],
               'phi_E': [0.2, 0.2],
               'phi_I': [0.2, 0.2]}

model.run(T=365, checkpoints=checkpoints)
fig, ax = model.figure_infections(show=False)
fig.savefig("disease_states_by_day.png")
