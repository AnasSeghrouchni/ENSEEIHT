@doc doc"""
Tester l'algorithme du pas de Cauchy
# Entrées :
   * afficher : (Bool) affichage ou non des résultats de chaque test
"""
function tester_pas_de_cauchy(afficher::Bool,Pas_De_Cauchy::Function)

	tol_erreur = 1e-7

	@testset "Pas de Cauchy" begin
		"# Pour la quadratique 1"

		@testset "cas g = 0" begin
			g = [0; 0]
			H = [7 0 ; 0 2]
			delta = 1
		  s, e = Pas_De_Cauchy(g,H,delta)
	    @test (e == 0) && (isapprox(s,[0; 0],atol=tol_erreur))
	    end
		#Par la calcul, le min de phi est atteint en 240/260 et ainsi il faut que delta soit superieur 
		#à environ 0.98 pour que la quadratique soit saturée. 
		@testset "Cas saturée a > 0 " begin
	    	g = [6; 2]
		    H = [7 0 ; 0 2]
		    delta = 0.5
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(delta/norm(g))*g
		    @test (e == -1) && (isapprox(s,sol,atol=tol_erreur)) 
	    end
		@testset "Cas non saturée a > 0" begin
	    	g = [6; 2]
		    H = [7 0 ; 0 2]
		    delta = 1.5
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(norm(g)^2/(g'*H*g))*g
		    @test (e == 1) && (isapprox(s,sol,atol=tol_erreur)) 
	    end
		#Par la calcul, le min de phi est atteint en 2.5 et ainsi il faut que delta soit superieur 
		#à environ 5.5 pour que la quadratique soit saturée. 
		@testset "Cas non saturée a > 0 " begin
		    g = [-2; 1]
		    H = [-2 0 ; 0 10]
		    delta = 6
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(norm(g)^2/(g'*H*g))*g
		    @test (e == 1) && (isapprox(s,sol,atol=tol_erreur)) 
	    end
		@testset "Cas saturée a > 0 " begin
		    g = [-2; 1]
		    H = [-2 0 ; 0 10]
		    delta = 5
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(delta/norm(g))*g
		    @test (e == -1) && (isapprox(s,sol,atol=tol_erreur)) 
	    end
		# Par le calcul  a= g'Hg = -7
		@testset "Cas a < 0 saturé" begin
		    g = [ 2 ; 1]
		    H = [-2 0 ; 0 1]
		    delta = 3
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(delta/norm(g))*g
		    @test (e == -1) && (isapprox(s,sol,atol=tol_erreur))
	    end
		@testset "Cas a = 0 saturé" begin
		    g = [2 , 1]
		    H = [1 1 ; -2 -2]
		    delta = 5
		    s, e = Pas_De_Cauchy(g,H,delta)
				sol = -(delta/norm(g))*g
		    @test (e == -1) && (isapprox(s,sol,atol=tol_erreur))
	    end
	end
end
