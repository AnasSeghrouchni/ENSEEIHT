function Resolution_snd_deg(delta,pj,sj,g,H,bool)
    a = norm(pj)*norm(pj)
    b = 2 * sj'*pj
    c = norm(sj)*norm(sj) - delta*delta
    sigma1 = (-b + sqrt(b*b - 4*a*c))/(2*a)
    sigma2 = (-b - sqrt(b*b - 4*a*c))/(2*a)
    v1 = sj + sigma1*pj
    v2 = sj + sigma2*pj
    q1 = g'*v1 + 0.5*v1'*H*v1
    q2 = g'*v2 + 0.5*v2'*H*v2
    if bool
        if q1 < q2
            return sigma1
        else
            return sigma2
        end
    else
        return max(sigma1,sigma2)
    end
end

