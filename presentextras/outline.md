---
title: Outline presentación
---


La idea es construir narrativa, no necesariamente ahondar en los detalles,
ecuaciones y números.

# Parte 1 - Les presento, al aprendizaje de máquina
- Por qué nos interesa hoy?
- Hoy vamos a lidiar con 2 ramas: supervisado y por refuerzo

## Introducción flash a los árboles de regresión y clasificación
- Microejemplo con las figuras presentadas en el texto
- Invertir más tiempo en hablar del proceso de ajuste, de qué manera es una
  tarea que busca "las mejores soluciones" secuencialmente y cómo es que
  decisiones ahorita determinan la mejor solución disponible

## Presentar el problema de Aprendizaje por Refuerzo:
- Una de las principales diferencias es que aqui no tenemos el lujo de ejemplos.
- Aprovechar el problema del Miniopoly


## Haciendo conexiones
- Qué entendemos por _aprender_?
- Por qué se llama por _refuerzo_?
- Nuestros personajes principales:
    - Estados
    - Políticas
    - State-value functions
    - Optimalidad


# Parte 2 - La optimización como un problema geométrico de búsqueda
- Cómo sabemos qué buscamos? Quién nos asegura que tal punto existe? Ecuaciones
  de optimalidad de Bellman
- El optimizar es explorar un espacio. En nuestro caso el espacio donde viven
  las state-value functions.
- Hay maneras de explorar a ciegas. Por ejemplo, estimar el valor esperado como
  un promedio. Mostrar violinplot. Pero esta no es una manera inteligente de
  hacerlo, la cantidad de opciones a explorar crece exponencialmente con el
  número de estados.