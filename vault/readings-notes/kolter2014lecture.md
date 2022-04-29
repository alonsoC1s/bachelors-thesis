# Lecture del curso: Graduate Artificial Intelligence
![[kolter2014lecture.pdf]]

## Ziko Kolter
Basic idea: we can capture the constraint
$$
V (s) \geq R(s) + \gamma \max_{a \in \mathcal{A}} \sum_{s' \in \mathcal{S}} \mathbb{P}(s, \mid s, a) V (s')
$$

via the set of $| \mathcal{A}|$ linear constraints.

$$
V (s) ≥ R(s) + γ \sum_{s ′∈S} \mathbb{P}(s ′ \mid s, a)V (s ′ ), \, ∀a ∈ A
$$

Now consider the linear progra:
$$
\min V \sum_{s} V (s)
$$
subject to 

$$
V (s) ≥ R(s) + γ \sum_{s ′∈S} \mathbb{P}(s ′ \mid s, a)V (s ′ ), \, ∀a ∈ A, s ∈ S
$$

### Más información & lectures en
http://www.cs.cmu.edu/~zkolter/course/15-780-s14/lectures.html