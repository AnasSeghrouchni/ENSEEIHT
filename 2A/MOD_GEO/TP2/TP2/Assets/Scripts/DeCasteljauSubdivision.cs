using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Linq;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère la subdivision via DCJ /////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauSubdivision : MonoBehaviour
{
    // Pas d'échantillonage pour affichage
    public float pas = 1 / 100;
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

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
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                for (int i = 0; i < ListePointsCliques.X.Count; ++i)
                {
                    PolygoneControleX.Add(ListePointsCliques.X[i]);
                    PolygoneControleY.Add(ListePointsCliques.Y[i]);
                }
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();

                (XSubdivision, YSubdivision) = DeCasteljauSub(ListePointsCliques.X, ListePointsCliques.Y, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i], -4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
