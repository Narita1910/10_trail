Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
       Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Cull Off


        GrabPass{"_BackgroundTexture"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 grabpos : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _BackgroundTexture;
            float4 _MainTex_ST;
            fixed4 _MainColor;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.grabpos = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = fixed4(_MainColor.rgb, tex2D(_MainTex, i.uv).a * _MainColor.a);
                // apply fog
            //fixed4 col = tex2Dproj(_BackgroundTexture, i.grabpos
              //  + 100.0
              //  * (decal.a + 0.5)
             //   * float4(ddx(i.uv.x), ddy(i.uv.x), 0.0, 0.0)
           // );
           // col.a = 1.0;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
