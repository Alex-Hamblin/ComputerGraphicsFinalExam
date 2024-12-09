Shader "Custom/Rim Light"
{
	    Properties
    {
        _RimColor("Rim Color", Color) = (0, 0.5, 0.5, 0.0)
        _RimPower("Rim Power", Range (0.5,8.0)) = 3.0
        _MainTex("Texture",2D) = "White" {}

    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert 
        struct Input
        {
            float3 viewDir;
            float2 uv_MainTex;
        };

        float4 _RimColor;
        float _RimPower;
        sampler2D _MainTex;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1.0 - saturate (dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);
            fixed4 c =  tex2D(_MainTex,IN.uv_MainTex);
            o.Albedo = c.rgb + _RimColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
