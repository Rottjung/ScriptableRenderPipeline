Shader "hidden/preview/Multiply_C3CB7BE2"
{
	Properties
	{
				[HideInInspector] [NonModifiableTextureData] [NoScaleOffset] Texture_FD0EDC2E("Texture", 2D) = "white" {}
	}
	CGINCLUDE
	#include "UnityCG.cginc"
			void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA)
			{
			    RGBA = float4(R, G, B, A);
			}
			void Unity_Multiply_float(float4 first, float4 second, out float4 result)
			{
			    result = first * second;
			}
			void Unity_HSVToRGB_float(float3 hsv, out float3 rgb)
			{
			    //Reference code from:https://github.com/Unity-Technologies/PostProcessing/blob/master/PostProcessing/Resources/Shaders/ColorGrading.cginc#L175
			    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			    float3 P = abs(frac(hsv.xxx + K.xyz) * 6.0 - K.www);
			    rgb = hsv.z * lerp(K.xxx, saturate(P - K.xxx), hsv.y);
			}
			void Unity_Multiply_float(float first, float second, out float result)
			{
			    result = first * second;
			}
	struct GraphVertexInput
	{
	     float4 vertex : POSITION;
	     float3 normal : NORMAL;
	     float4 tangent : TANGENT;
	     float4 texcoord0 : TEXCOORD0;
	     float4 lightmapUV : TEXCOORD1;
	     UNITY_VERTEX_INPUT_INSTANCE_ID
	};
			struct SurfaceInputs{
				half4 uv0;
			};
			struct SurfaceDescription{
				float Multiply_C3CB7BE2_result;
			};
			UNITY_DECLARE_TEX2D(Texture_FD0EDC2E);
			float Combine_76C873_G;
			float Combine_76C873_B;
			float Combine_76C873_A;
			float4 Property_23AD7FD4_UV;
			float Multiply_C3CB7BE2_second;
			GraphVertexInput PopulateVertexData(GraphVertexInput v){
				return v;
			}
			SurfaceDescription PopulateSurfaceData(SurfaceInputs IN) {
				half4 uv0 = IN.uv0;
				float4 Combine_76C873_RGBA;
				Unity_Combine_float(_Time.y, Combine_76C873_G, Combine_76C873_B, Combine_76C873_A, Combine_76C873_RGBA);
				float4 Property_23AD7FD4_RGBA = UNITY_SAMPLE_TEX2D(Texture_FD0EDC2E,uv0.xy);
				float Property_23AD7FD4_R = Property_23AD7FD4_RGBA.r;
				float Property_23AD7FD4_G = Property_23AD7FD4_RGBA.g;
				float Property_23AD7FD4_B = Property_23AD7FD4_RGBA.b;
				float Property_23AD7FD4_A = Property_23AD7FD4_RGBA.a;
				float4 Multiply_89C71AC1_result;
				Unity_Multiply_float(Property_23AD7FD4_RGBA, Combine_76C873_RGBA, Multiply_89C71AC1_result);
				float3 HSVtoRGB_AE8D0A0E_rgb;
				Unity_HSVToRGB_float((Multiply_89C71AC1_result.xyz), HSVtoRGB_AE8D0A0E_rgb);
				float Split_81BA869A_R = HSVtoRGB_AE8D0A0E_rgb[0];
				float Split_81BA869A_G = HSVtoRGB_AE8D0A0E_rgb[1];
				float Split_81BA869A_B = HSVtoRGB_AE8D0A0E_rgb[2];
				float Split_81BA869A_A = 1.0;
				float Multiply_9164EC34_result;
				Unity_Multiply_float(Split_81BA869A_R, Split_81BA869A_G, Multiply_9164EC34_result);
				float Multiply_841C266E_result;
				Unity_Multiply_float(Multiply_9164EC34_result, Split_81BA869A_B, Multiply_841C266E_result);
				float Multiply_C3CB7BE2_result;
				Unity_Multiply_float(Multiply_841C266E_result, Multiply_C3CB7BE2_second, Multiply_C3CB7BE2_result);
				SurfaceDescription surface = (SurfaceDescription)0;
				surface.Multiply_C3CB7BE2_result = Multiply_C3CB7BE2_result;
				return surface;
			}
	ENDCG
	SubShader
	{
	    Tags { "RenderType"="Opaque" }
	    LOD 100
	    Pass
	    {
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
	        #include "UnityCG.cginc"
	        struct GraphVertexOutput
	        {
	            float4 position : POSITION;
	            half4 uv0 : TEXCOORD;
	        };
	        GraphVertexOutput vert (GraphVertexInput v)
	        {
	            v = PopulateVertexData(v);
	            GraphVertexOutput o;
	            o.position = UnityObjectToClipPos(v.vertex);
	            o.uv0 = v.texcoord0;
	            return o;
	        }
	        fixed4 frag (GraphVertexOutput IN) : SV_Target
	        {
	            float4 uv0  = IN.uv0;
	            SurfaceInputs surfaceInput = (SurfaceInputs)0;;
	            surfaceInput.uv0  =uv0;
	            SurfaceDescription surf = PopulateSurfaceData(surfaceInput);
	            return half4(surf.Multiply_C3CB7BE2_result, surf.Multiply_C3CB7BE2_result, surf.Multiply_C3CB7BE2_result, 1.0);
	        }
	        ENDCG
	    }
	}
}
