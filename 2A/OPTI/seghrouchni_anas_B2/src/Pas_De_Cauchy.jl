@doc doc"""

#### Objet
Cette fonction calcule une solution approchée du problème
```math
\min_{||s||< \Delta} s^{t}g + \frac{1}{2}s^{t}Hs
```
par le calcul du pas de Cauchy.

#### Syntaxe
```julia
s, e = Pas_De_Cauchy(g,H,delta)
```

#### Entrées
 - g : (Array{Float,1}) un vecteur de ``\mathbb{R}^n``
 - H : (Array{Float,2}) une matrice symétrique de ``\mathbb{R}^{n\times n}``
 - delta  : (Float) le rayon de la région de confiance

#### Sorties
 - s : (Array{Float,1}) une approximation de la solution du sous-problème
 - e : (Integer) indice indiquant l'état de sortie:
        si g != 0
            si on ne sature pas la boule
              e <- 1
            sinon
              e <- -1
        sinon
            e <- 0

#### Exemple d'appel
```julia
g = [0; 0]
H = [7 0 ; 0 2]
delta = 1
s, e = Pas_De_Cauchy(g,H,delta)
```
"""
function Pas_De_Cauchy(g,H,delta)
    e = 0
    n = length(g)
    s = zeros(n)
    a = g'*H*g
    b = - g'*g
    if g != zeros(n)
      if a > 0
        t = - b / a
        if (t <= (delta / norm(g))) && (t >= 0)
            s = -t * g
            e = 1
        else
            s = - (delta / norm(g)) * g
            e = -1
        end   
      else
        s = -(delta / norm(g)) * g
        e = -1
      end
    else
        s = zeros(n)
        e = 0 
    end   
    return s, e
end
