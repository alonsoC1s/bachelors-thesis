# Draft sucio 
## Para explicar la parte principal de la tesis: La formulación del problema de RL como un problema de LP.

$$
\newcommand{\R}{\mathbb{R}}
\newcommand{\States}{\mathcal{S}}
\newcommand{\Actions}{\mathcal{A}}
\newcommand{\Rewards}{\mathcal{R}}
\DeclarePairedDelimiter{\brackets}{[}{]}
\newcommand{\E}{\mathbb{E}\brackets}
\newcommand{\Pe}{\mathbb{P}\brackets}
\newcommand{\vertsep}{\,\middle\vert\,} 
$$

#### Objetivos
1. Matematizar intuitivamente los conceptos de los MDPs presentados durante la motivación para motivar la introducción de Dynamic Programming.
2. Introducir solo los conceptos que son _esenciales_.
3. Apoyarme de diagramas (backup diagrams)
4. Retomar ejemplos anteriores y/o utilizar algunos ejemplos de D. P. Farias de queueing theory por ejemplo.
5. Hacer suficiéntemente claro porqué se cumplen ciertas propiedades que utilizo para desarrollar cosas como la ecuación de Bellman (e.g. porqué utilizar una función $p(s', r \mid s, a)$, su dominio, y demás.
6. Identificar bien qué conceptos voy a tener que desarrollar con más profundidad en la parte 1 de fundamentos.

### Highest level rundown
- Markov Decision Process is the formalization of the idea of the agent-environment interface.
- At each time step $t$ the agent receives some representation of the environment _state_, $S_t \in \States$, and based on that state selects and action $A_t \in \Actions(s)$, a set that depends on the state $s$. One time step later it receives a reward $R_{t+1} \in \mathcal{R} \subseteq \R$ as a result.
- Summarized as a sequence:
$$
S_0, A_0, R_1, S_1, A_1, R_2, S_2, \dots
$$
- Since transitions are not deterministic, each transition from state $s$ to another state $s'$ given that a certain action $a$ was taken happens probabilistically [[draft-pt1-probability]]. 
$$
\Pe{S_t = s', R_r = r \mid S_{t-1} = s, A_{t-1} = a} =: p(s', r \mid s, a)
$$
- Without taking into consideration the reward $r$, marginalizing the previous expression
$$
p(s' \mid s, a) = \sum_{r \in \Rewards} p(s', r \mid s, a)
$$
- We can also compute the expected rewards for state-action pairs as a two argument function $r: \States \times \Actions \to \R$:
$$
r(s,a) := \E{R_t | S_{t-1} =s, A_{t-1} =a}
$$
- The goal is to maximize cumulative reward. Rewards after time $t$ are $R_{t+1}, R{t+2}, \ldots$.  We want to maximize _expected_ reward, defined as $G_t = R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + \dots$.
- $G_t := R_{t+1} + \gamma G_{t+1}$.
- To solve the problem we need to estimate how good it is for the agent to be at a certain state and take a certain action in terms of expected future rewards (those are value functions).
- Actions are chosen according to stochastic policies $\pi(a \mid s)$.
- $$
v_\pi(s) = E_{\pi}[Gt \mid St = s] = E_{\pi}
[\gamma^k R_{t+k+1} \versep S_t = s] , for all s \in S,
$$
- $v_\pi$ is the _state-value function for policy $\pi$_. It's the expected return when starting in $s$ and following $\pi$ from then on.
- We can think of the value of choosing action $a$ in state $s$ under policy $\pi$, $q_{\pi} (s,a)$. The expected return starting from $s$, taking the action $a$ and following $\pi$ from then on.
- $q_\pi$ is the _action-value function for policy $\pi$_.