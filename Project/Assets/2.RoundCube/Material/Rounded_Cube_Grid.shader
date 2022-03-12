Shader "custom/Rounded cube Grid"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        [KeywordEnum(X, Y, Z)] _FACE("Face", Float) = 0


        [Toggle(_SHOW_COLOR_UV)] _ShowColorUV("是否用颜色显示UV", float) = 0


        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1
        [Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 1

        // KeywordEnum displays a popup menu for a **float** property, and enables corresponding shader keyword. 
        // This is used with "#pragma multi_compile" in shaders, to enable or disable parts of shader code. 
        // Each name will enable "property name" + underscore + "enum name", uppercased, shader keyword. 
        // Up to **9** names can be provided.
        [KeywordEnum(None, Add, Multiply)] _Overlay("Overlay mode", Float) = 0

        // PowerSlider displays a slider with a non-linear response for a Range shader property.
        // A slider with 3.0 response curve
        [PowerSlider(3.0)] _Shininess("Shininess", Range(0.01, 1)) = 0.08
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            #pragma shader_feature _FACE_X _FACE_Y _FACE_Z
            #pragma shader_feature _SHOW_COLOR_UV
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows vertex:vert

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            sampler2D _MainTex;

            struct Input
            {
                float2 cubeUV;
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)


            void vert(inout appdata_full v, out Input c)
            {
                UNITY_INITIALIZE_OUTPUT(Input, c);
#if defined(_SHOW_COLOR_UV)
#if  defined(_FACE_X)
                c.cubeUV = v.color.yz * 255;
#elif defined(_FACE_Y)
                c.cubeUV = v.color.xz * 255;
#elif defined(_FACE_Z)
                c.cubeUV = v.color.xy * 255;
#endif
#else
#if  defined(_FACE_X)
                c.cubeUV = v.vertex.yz;
#elif defined(_FACE_Y)
                c.cubeUV = v.vertex.xz;
#elif defined(_FACE_Z)
                c.cubeUV = v.vertex.xy;
#endif
#endif
            }


            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D(_MainTex, IN.cubeUV) * _Color;
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}