(* Les règles de la déduction naturelle doivent être ajoutées à Coq. *) 
Require Import Naturelle. 

(* Ouverture d'une section *) 
Section LogiqueProposition. 

(* Déclaration de variables propositionnelles *) 
Variable A B C E Y R : Prop. 

Theorem Thm_0 : A /\ B -> B /\ A.
I_imp HAetB.
I_et.
E_et_d A.
Hyp HAetB.
E_et_g B.
Hyp HAetB.
Qed.

Theorem Thm_1 : (A -> (B -> C)) -> ((A -> B)->(A->C)).
I_imp H1.
I_imp H2.
I_imp H3.
E_imp B.
E_imp A.
Hyp H1.
Hyp H3.
E_imp A.
Hyp H2.
Hyp H3.




(* A COMPLETER *)
Qed.

Theorem Thm_2 : (~A/\(A\/B))->B.
I_imp H1.
E_ou A B.
E_et_d (~A).
Hyp H1.
I_imp H2.
E_antiT.
I_antiT (A).
Hyp H2.
E_et_g (A\/B).
Hyp H1.
I_imp H2.
Hyp H2.

(* A COMPLETER *)
Qed.

Theorem Thm_3 : (A->B)->(((~C)->(~B))->(A->C)).
I_imp H1.
I_imp H2.
I_imp H3.
absurde H4.
I_antiT B.
E_imp A.
Hyp H1.
Hyp H3.
E_imp (~C).
Hyp H2.
Hyp H4.


(* A COMPLETER *)
Qed.

Theorem Thm_4 : (A->B->C)->(A/\B->C).
I_imp H1.
I_imp H2.
E_imp B.
E_imp A.
Hyp H1.
E_et_g B.
Hyp H2.
E_et_d A.
Hyp H2.

(* A COMPLETER *)
Qed.

Theorem Thm_5 : (~A\/B)->~A\/A/\B.
I_imp H1.
I_ou_g.
E_ou (~A) B.
Hyp H1.
I_imp H2.
Hyp H2.
I_imp H2.
absurde H.


E_ou (~A) B.
Hyp H1.
I_imp H3.
Hyp H3.
I_imp H3.
I_non H4.
(* A COMPLETER *)
Qed.

Theorem Thm_6 : ((E -> (Y \/ R)) /\ (Y -> R)) -> ~R -> ~E.
(* A COMPLETER *)
Qed.

(* Version en Coq *)

Theorem Coq_Thm_0 : A /\ B -> B /\ A.
intro H.
destruct H as (HA,HB).  (* élimination conjonction *)
split.                  (* introduction conjonction *)
exact HB.               (* hypothèse *)
exact HA.               (* hypothèse *)
Qed.


Theorem Coq_E_imp : ((A -> B) /\ A) -> B.
(* A COMPLETER *)
Qed.

Theorem Coq_E_et_g : (A /\ B) -> A.
(* A COMPLETER *)
Qed.

Theorem Coq_E_ou : ((A \/ B) /\ (A -> C) /\ (B -> C)) -> C.
(* A COMPLETER *)
Qed.

Theorem Coq_Thm_7 : ((E -> (Y \/ R)) /\ (Y -> R)) -> (~R -> ~E).
(* A COMPLETER *)
Qed.

End LogiqueProposition.

