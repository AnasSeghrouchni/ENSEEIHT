%%%% test énoncé %%%%%
Q = [2 2 2; 2 4 5; 2 5 7];
I_barre = [0.1 0.2 0.3]';
phi([1 -1 1]', I_barre, Q)
[chi,I] = minPhi(I_barre,Q);

%%%% test matrice diagonale %%%%%
Q = [5 0 0; 0 9 0 ; 0 0 7];
I_barre = [0.9 5.1 12.3]';
[chi, I]= minPhi(I_barre,Q);
I

%%%% test matrice %%%%
Q = [5 0.2 1; 0 9 1 ; 0 2 7];
I_barre = [0.9 5.1 12.3]';
[chi, I]= minPhi(I_barre,Q);
I