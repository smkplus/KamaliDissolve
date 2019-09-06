using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WorldMask : MonoBehaviour
{
    public Transform[] arrayTransform;
    public Vector4[] arrayPosition;
    public float[] arraySize;
    public Material material;

    private void Awake()
    {
        arrayPosition = new Vector4[arrayTransform.Length];
        arraySize = new float[arrayTransform.Length];
    }

    private void Update()
    {
        for (int i = 0; i < arrayTransform.Length; i++)
        {
            arrayPosition[i]= arrayTransform[i].position;
            arraySize[i]= arrayTransform[i].localScale.x -1;

        }
        
        material.SetVectorArray("_arrayPosition",arrayPosition);
        material.SetFloatArray("_arraySize",arraySize);
    }
}
