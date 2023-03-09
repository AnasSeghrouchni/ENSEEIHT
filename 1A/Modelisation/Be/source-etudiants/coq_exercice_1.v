Require Import Naturelle.
Section Session1_2018_Logique_Exercice_1.

Variable A B : Prop.

Theorem Exercice_1_Naturelle : ~(A \/ B) -> (~A /\ ~B).
Proof.
I_imp H1.
I_et.
I_non H2.
E_non (A\/B).
I_ou_g.
Hyp H2.
Hyp H1.
I_non H2.
E_non (A\/B).
I_ou_d.
Hyp H2.
Hyp H1.


(* A COMPLETER *)
Qed.

Theorem Exercice_1_Coq : ~(A \/ B) -> (~A /\ ~B).
Proof.
intro H1.
split.
unfold not.
intro H.
absurd (A\/B).
exact H1.
left.
exact H.
unfold not.
intro H.
absurd (A\/B).
exact H1.
right.
exact H.
Qed.

End Session1_2018_Logique_Exercice_1.

