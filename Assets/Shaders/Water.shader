Shader "Intersection/Surface" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _GlowColor("Glow Color", Color) = (1, 1, 1, 1)
        _FadeLength("Fade Length", Range(0, 5)) = 1
    }
    SubShader {
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On

        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert alpha:fade nolightmap
 
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
            float4 screenPos;
            float eyeDepth;
        };

        half _Glossiness;
        half _Metallic;
        sampler2D _CameraDepthTexture;
        fixed4 _Color;
        fixed4 _GlowColor;
        float _FadeLength;

		void vert (inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            COMPUTE_EYEDEPTH(o.eyeDepth);
        }


        void surf (Input IN, inout SurfaceOutputStandard o) {
            float rawZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
            float sceneZ = LinearEyeDepth(rawZ);
            float partZ = IN.eyeDepth;
			float diff = (sceneZ - partZ);

            float intersect = 1 - saturate(diff / _FadeLength);

            fixed4 col = fixed4(lerp(tex2D(_MainTex, IN.uv_MainTex) * _Color, _GlowColor, pow(intersect, 4)));
            o.Albedo = col.rgb;
            o.Alpha = col.a;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }
        ENDCG
    }
    FallBack "Diffuse"
}