Shader "Smkgames/worldSpaceFade" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("Normal Map",2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
         Pass {
            ZWrite On
            ColorMask 0
        }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NormalMap;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos: TEXCOORD2;
            float3 viewDir;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void vert (inout appdata_full v, out Input o){
            UNITY_INITIALIZE_OUTPUT(Input,o);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        }

        uniform float4 _arrayPosition [5];
        uniform float _arraySize [5];
         
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            
            
         float4 color = float4(0,0,0,0);
         
         for(int i = 0; i < 5;i++){
             float dist = distance(IN.worldPos, 
               float4(_arrayPosition[i].xyz, 1.0));
            
            if (dist < _arraySize[i])
            {
               color += float4(1.0, 1.0, 1.0, 1.0); 
            }
             }
            
             
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha =  saturate(1-color);
            o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_MainTex));
        }
        ENDCG
    }
    FallBack "Diffuse"
    }