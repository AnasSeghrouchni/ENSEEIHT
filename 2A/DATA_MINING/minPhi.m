function [chi,I] = minPhi(I_barre,Q)
    R = chol(Q);
    r11 = R(1,1);
    r12 = R(1,2);
    r13 = R(1,3);
    r22 = R(2,2);
    r23 = R(2,3);
    r33 = R(3,3);
    ib1 = I_barre(1);
    ib2 = I_barre(2);
    ib3 = I_barre(3);

    chi = phi(round(I_barre), I_barre, Q);
    g_3 = ceil(-sqrt(chi)/r33 + ib3);
    d_3 = floor(sqrt(chi)/r33 + ib3);
    for i3=g_3:d_3
        if (chi > (r33*(i3 - ib3)^2))
            g_2 = ceil(-sqrt(chi - (r33*(i3 - ib3)^2))/r22 + ib2 - r23*(i3-ib3)/r22);
            d_2 = floor(sqrt(chi - (r33*(i3 - ib3)^2))/r22 + ib2 - r23*(i3-ib3)/r22);
            for i2=g_2:d_2
                if (chi > (r33*(i3 - ib3)^2) + (r22*(i2-ib2) + r23*(i3-ib3))^2)
                    g_1 = ceil(-(sqrt(chi - (r33*(i3 - ib3)^2) - (r22*(i2-ib2) + r23*(i3-ib3))^2) -r12*(i2 - ib2) - r13*(i3 - ib3))/r11 +ib1 );
                    d_1 = floor((sqrt(chi - (r33*(i3 - ib3)^2) - (r22*(i2-ib2) + r23*(i3-ib3))^2) -r12*(i2 - ib2) - r13*(i3 - ib3))/r11 +ib1 );
                    for i1=g_1:d_1
                        if chi >= phi([i1 i2 i3]',I_barre,Q)
                            I = [i1 i2 i3]';
                            chi = phi([i1 i2 i3]',I_barre,Q);
                        end
                    end
                end
            end
        end   
    end
end


