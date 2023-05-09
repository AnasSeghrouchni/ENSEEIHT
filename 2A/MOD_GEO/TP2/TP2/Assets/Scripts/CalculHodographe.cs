using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

public class CalculHodographe : MonoBehaviour
{
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe de l'hodographe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués

    public GameObject Donnees;
    public GameObject particle;

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y, int nombreDeSubdivision)
    {
        List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();
        List<float> Xcopy = new List<float>(X);
        List<float> Ycopy = new List<float>(Y);
        List<float> XGauche = new List<float>();
        List<float> XDroite = new List<float>();
        List<float> YGauche = new List<float>();
        List<float> YDroite = new List<float>();
        
        if (nombreDeSubdivision == 0)
        {
            return (X,Y);
        }
        else
        {
            XGauche.Add(X[0]);
            XDroite.Add(X[X.Count -1]);
            YGauche.Add(Y[0]);
            YDroite.Add(Y[Y.Count -1]);
            for(int j=0;j<Xcopy.Count;j++){
                List<float> Xcopy1 = new List<float>();
                List<float> Ycopy1 = new List<float>();
                for(int i = 0; i<Xcopy.Count-1;i++){
                    Xcopy1.Add((Xcopy[i] + Xcopy[i+1])/2);
                    Ycopy1.Add((Ycopy[i] + Ycopy[i+1])/2);
                }
                XGauche.Add(Xcopy1[0]);
                YGauche.Add(Ycopy1[0]);
                XDroite.Add(Xcopy1[Xcopy1.Count-1]);
                YDroite.Add(Ycopy1[Ycopy1.Count-1]);
                Xcopy = Xcopy1;
                Ycopy = Ycopy1;
            }
        XDroite = Enumerable.Reverse(XDroite).ToList();
        (XGauche, YGauche) = DeCasteljauSub(XGauche,YGauche,nombreDeSubdivision-1);
        YDroite = Enumerable.Reverse(YDroite).ToList();
        (XDroite, YDroite) = DeCasteljauSub(XDroite,YDroite,nombreDeSubdivision-1);
        return (XGauche.Concat(XDroite).ToList(),YGauche.Concat(YDroite).ToList());
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : Hodographe                                                //
    // semantique : renvoie la liste des vecteurs vitesses entre les paires //
    //              consécutives de points de controle                      //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float Cx : offset d'affichage en x                        //
    //          - float Cy : offset d'affichage en y                        //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : listes composantes des       //
    //            vecteurs vitesses sous la forme (Xs,Ys)                   //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) Hodographe(List<float> X, List<float> Y, float Cx = 1.5f, float Cy = 0.0f)
    {
        List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();
        int n = X.Count;
        for(int i = 0;i<n-1;i++){
            XSortie.Add((X[i+1]-X[i])+Cx);
            YSortie.Add((Y[i+1]-Y[i])+Cy);
        }        
        return (XSortie, YSortie);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {
        
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            Instantiate(particle, new Vector3(1.5f, -4.0f, 0.0f), Quaternion.identity);
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();
                List<float> dX = new List<float>();
                List<float> dY = new List<float>();
                
                (dX, dY) = Hodographe(ListePointsCliques.X, ListePointsCliques.Y);

                (XSubdivision, YSubdivision) = DeCasteljauSub(dX, dY, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
