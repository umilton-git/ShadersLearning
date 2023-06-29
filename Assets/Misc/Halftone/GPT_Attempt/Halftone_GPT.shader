Shader "Custom/Halftone" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _DotSize ("Dot size", Range(1, 50)) = 20
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _DotSize;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                float gray = dot(col.rgb, fixed3(0.299, 0.587, 0.114));
                float dot = step(_DotSize, gray * 100.0) * gray;
                return fixed4(dot, dot, dot, col.a);
            }
            ENDCG
        }
    }
}