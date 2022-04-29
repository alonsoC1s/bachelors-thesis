# Draft: Stochastic Processes

1. Retomar la idea del capítulo de Motivación y formalizarla como el Agent-Environment interface.
2. Plantear y explicar bien la lógica detrás de las sucesiones $S_t, A_t, R_{t+1}, S_{t+1}, A_{t+1}, \ldots$.
	- Que son? Números reales, variables aleatorias?
	- Que quieren decir los índices $t, t+1, \ldots$.
	- **Idea:** Para explicar un proceso estocástico y la idea de una trayectoria podría servir una [fence plot](http://gnuplot.sourceforge.net/demo/fenceplot.html). Aqui está implementado en [Julia](https://discourse.julialang.org/t/plot-the-distribution-curve/66133/10)
		- ![](http://gnuplot.sourceforge.net/demo/fenceplot.2.png)
3. Ya teniendo clara la interfaz y estos procesos estocásticos, formalizar a que me he estado refiriendo con "expected reward".
4. Profundizar en la mecánica de transiciones probabilísticas. i.e. la $p$.
5. Empezar a introducir la idea de políticas.


Ahora si, un draft:

## 1
- Recall the miniopoly-playing robot. We call the robot an _agent_, and the rest of the game and the "signals" it sends and receives, the _environment_.