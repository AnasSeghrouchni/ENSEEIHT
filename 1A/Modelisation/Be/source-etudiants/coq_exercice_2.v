Require Import Naturelle.
Section Session1_2018_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Naturelle : ~(A /\ B) -> (~A \/ ~B).
Proof.
I_imp H1.

Hyp H2.


absurde H.

I_et.
Hyp H2.



Qed.

Theorem Exercice_2_Coq : ~(A /\ B) -> (~A \/ ~B).
Proof.
(* A COMPLETER *)
Qed.

End Session1_2018_Logique_Exercice_2.

