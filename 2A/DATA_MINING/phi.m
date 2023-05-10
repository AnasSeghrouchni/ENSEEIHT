function Y = phi(I,I_barre,Q)
    Y = (I - I_barre)'*Q*(I-I_barre);
end

