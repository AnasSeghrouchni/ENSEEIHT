using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine.UI;

public class InterpolateurDeSurface : MonoBehaviour
{
    public GameObject particle;
    public float[,] X;
    public float[,] Hauteurs;
    public float[,] Z;
    public bool autoGenerateGrid;
    public float pas;
    private List<List<Vector3>> ListePoints = new List<List<Vector3>>();

    long KparmiN(int k, int n)
    {

        decimal result = 1;
        for (int i = 1; i <= k; i++)
        {
            result *= n - (k - i);
            result /= i;
        }
        return (long)result;
    }

    float buildBernstein(int n, int k, float t)
    {
        return (float)(KparmiN(k, n) * Math.Pow(t, k) * Math.Pow(1 - t, n - k));
    }

    Vector3 surface(float u, float v)
    {
        Vector3 result = new Vector3(0, 0, 0);
        int n = X.GetLength(0) - 1;
        int m = X.GetLength(1) - 1;
        for (int i = 0; i <= n; ++i)
        {
            for (int j = 0; j <= m; ++j)
            {
                float b =  buildBernstein(n, i, u) * buildBernstein(m, j, v);
                result += new Vector3(X[i, j], Hauteurs[i, j], Z[i, j]) * b;
            }
        }
        return result;
    }

    void buildSurface(){
        for (float u = 0; u <= 1; u += pas)
        {
            List<Vector3> L = new List<Vector3>();
            for (float v = 0; v <= 1; v += pas)
            {
                L.Add(surface(u, v));
            }
            ListePoints.Add(L);
        }

        for (float v = 0; v <= 1; v += pas)
        {
            List<Vector3> L = new List<Vector3>();
            for (float u = 0; u <= 1; u += pas)
            {
                L.Add(surface(u, v));
            }
            ListePoints.Add(L);
        }   
    }


    void Start()
    {
        if (autoGenerateGrid)
        {
            int n = 5;
            X = new float[5, 5];
            Hauteurs = new float[5, 5];
            Z = new float[5, 5];
            for (int i = 0; i < n; ++i)
            {
                X[i, 0] = 0.00f;
                X[i, 1] = 0.25f;
                X[i, 2] = 0.50f;
                X[i, 3] = 0.75f;
                X[i, 4] = 1.00f;

                Z[0, i] = 0.00f;
                Z[1, i] = 0.25f;
                Z[2, i] = 0.50f;
                Z[3, i] = 0.75f;
                Z[4, i] = 1.00f;
            }
            for (int i = 0; i < n; ++i)
            {
                for (int j = 0; j < n; ++j)
                {
                    float XC2 = (X[i, j] - (1.0f / 2.0f)) * (X[i, j] - (1.0f / 2.0f));
                    float ZC2 = (Z[i, j] - (1.0f / 2.0f)) * (Z[i, j] - (1.0f / 2.0f));
                    Hauteurs[i, j] = (float)Math.Exp(-(XC2 + ZC2));
                    Instantiate(particle, new Vector3(X[i, j], Hauteurs[i, j], Z[i, j]), Quaternion.identity);
                }
            }
        } else {

        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            buildSurface();
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        if (autoGenerateGrid)
        {

            for (int j = 0; j < ListePoints.Count; ++j)
            {
                for (int i = 0; i < ListePoints[j].Count - 1; ++i)
                {
                    Gizmos.DrawLine(ListePoints[j][i], ListePoints[j][i + 1]);
                }
            }
        }
    }
}
