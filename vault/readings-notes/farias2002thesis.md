---
aliases: FariasThesis
---
# The Linear Programming Approach to Approximate Dynamic Programming: Theory and Application
## Dissertation: Daniela Pucci de Farias

![[farias2002thesis.pdf]]

### 1.4 Approximate Linear Programming

>Similar to regresion to fit a curve based on noisy observations by minimizing, for example, the sum of the squared errors over the samples. Unfortunately, the same idea cannot be applied in the approximate dynamic programming setting because we cannot sample the optimal value function.

>Approximate linear programming is inspired by the more traditional linear pro-
gramming approach to exact dynamic programming (9, 17, 18, 19, 26, 34)

... Quizás lo que necesito es el "more traditional linear programming approach to exact dynamic programming", y no la versión de Farias.

**Las referencias son estas**
- [ 9] V. Borkar. A convex analytic approach to Markov decision processes. Probability
Theory and Related Fields, 78:583–602, 1988.
- [17] G. de Ghellinck. Les problèmes de décisions séquentielles. Cahiers du Centre
d’Etudes de Recherche Opérationnelle, 2:161–179, 1960.
- [18] E.V. Denardo. On linear programming in a Markov decision problem. Manage-
ment Science, 16(5):282–288, 1970.
- [19] F. D’Epenoux. A probabilistic production and inventory problem. Management
Science, 10(1):98–108, 1963.
- [26] A. Hordijk and L.C.M. Kallenberg. Linear programming and Markov decision
chains. Management Science, 25:352–362, 1979.
- [34] A.S. Manne. Linear programming and sequential decisions. Management Science,
6(3):259–267, 1960.

Los 2 papers que se ven prometedores juzgando por el abstract son:
- [ 9] V. Borkar. A convex analytic approach to Markov decision processes
> Markov decision processes optimize phenomena evolving with time and thus are intrinsically dynamic optimization problems. Nevertheless, they can be cast as abstract 'static' optimization problems over a closed convex set of measures. They then become convex, infinite dimensional linear programming problems for with solutions are already known. [...] The attraction of this approach lies in:
> [...]
> -  It brings to the fore the possibility of using convex/linear programming techniques for computing near-optimal strategies.


- [26] Hordijk. Linear programming and Markov decision chains
> In this paper we show that for a finite Markov decision process an average optimal policy can be found by solving only one linear programming problem. Also the relation between the set of feasible solutions of the linear program and the set of stationary policies is analyzed.

Los anado a la lista de lectura con los códigos [[borkar2002convex]] & [[hordijk1979LP4MDP]] respectivamente.

Parece ser que solo necesito leer el capítulo 2 & quizás el 3 de la tesis. El Ch. 2 presenta el tratamiento estándar con DP al problema de RL, y cómo nos mata la maldición de la dimensionalidad, y se presentan ideas principales de approximate dynamic programming, y el algoritmo principal.

En el Ch. 3 se discute cómo banancear precisión de aproximación.

## Ch. 2
### 2.2 Approximate Dynamic Programming

Hace exactamente lo mismo que en el artículo, y brinca la parte interesante. Pero menciona quien fue la primera persona en proponer la idea.

>Combining the linear programming approach to exact dynamic programming with
linear approximation architectures leads to the approximate linear programming al-
gorithm (ALP), originally proposed by Schweitzer and Seidmann [43].

- [ 43] P. Schweitzer and A. Seidmann. Generalized polynomial approximations in Markovian decision processes. Journal of Mathematical Analysis and Applications, 110:568–582, 1985.

El abstract dice:

> Fitting the value function in a Markovian decision process by a linear superposition of $M$ basis functions reduces the problem dimensionality from the number of states down to $M$, with good accuracy retained if the value function is a smooth function of its argument, the state vector. This paper provides, for both the discounted and undiscounted cases, three algorithms for computing the coefficients in the linear superposition: linear programming, policy iteration, and least squares.

Suena a que aqui puedo encontrar la primera formulación con todo el detalle. Lo agrego a las lecturas con el código [[schweitzer1985generalized]].