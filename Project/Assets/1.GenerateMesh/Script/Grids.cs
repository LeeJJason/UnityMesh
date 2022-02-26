using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[RequireComponent(typeof(MeshFilter)), RequireComponent(typeof(MeshRenderer))]
public class Grids : MonoBehaviour
{
    public int xSize = 10;
    public int ySize = 5;

    private Vector3[] vertices;
    private Mesh mesh;

    private void Awake()
    {
        StartCoroutine(Generate());
    }


    private IEnumerator Generate() 
    {
        WaitForSeconds wait = new WaitForSeconds(0.05f);

        mesh = new Mesh();
        mesh.name = "Generate";
        MeshFilter filer = GetComponent<MeshFilter>();
        filer.mesh = mesh;

        vertices = new Vector3[(xSize + 1) * (ySize + 1)];
        Vector2[] uv = new Vector2[vertices.Length];
        Vector4[] tangents = new Vector4[vertices.Length];
        Vector4 tangent = new Vector4(1, 0, 0, -1);
        for (int i = 0, y = 0; y <= ySize; ++y) 
        {
            for (int x = 0; x <= xSize; ++x, ++i) 
            {
                vertices[i] = new Vector3(x, y, 0);
                uv[i] = new Vector2((float)x / xSize, (float)y / ySize);
                tangents[i] = tangent;
                //yield return wait;
            }
        }

        mesh.vertices = vertices;
        mesh.uv = uv;
        // 正反面控制，顺时针正面，逆时针背面
        int[] triangles = new int[xSize * ySize * 6];
        for (int ti = 0, vi = 0, y = 0; y < ySize; ++y, ++vi) 
        {
            for (int x = 0; x < xSize; ++x, ti += 6, ++vi) 
            {
                triangles[ti] = vi;
                triangles[ti + 3] = triangles[ti + 2] = vi + 1;
                triangles[ti + 4] = triangles[ti + 1] = vi + xSize + 1;
                triangles[ti + 5] = vi + xSize + 2;

                //mesh.triangles = triangles;
                //yield return wait;
            }
        }
        mesh.triangles = triangles;
        mesh.RecalculateNormals();
        yield return null;
    }

    private void OnDrawGizmos()
    {
        if (vertices == null)
            return;

        for (int i = 0; i <vertices.Length; ++i) 
        {
            Gizmos.DrawSphere(vertices[i], 0.1f);
        }
    }
}
