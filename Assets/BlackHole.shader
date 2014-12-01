// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:1,bsrc:3,bdst:7,culm:0,dpts:2,wrdp:False,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32443,y:32556|diff-669-RGB,alpha-654-OUT,refract-800-OUT;n:type:ShaderForge.SFN_TexCoord,id:3,x:34222,y:32692,uv:0;n:type:ShaderForge.SFN_Vector2,id:4,x:34220,y:32857,v1:0.5,v2:0.5;n:type:ShaderForge.SFN_Distance,id:5,x:34025,y:32745|A-3-UVOUT,B-4-OUT;n:type:ShaderForge.SFN_Vector1,id:14,x:34024,y:32883,v1:2;n:type:ShaderForge.SFN_Multiply,id:15,x:33789,y:32745|A-5-OUT,B-14-OUT;n:type:ShaderForge.SFN_OneMinus,id:16,x:33595,y:32724|IN-15-OUT;n:type:ShaderForge.SFN_Clamp01,id:17,x:33433,y:32724|IN-16-OUT;n:type:ShaderForge.SFN_Slider,id:20,x:33451,y:33150,ptlb:node_20,ptin:_node_20,min:1,cur:1.810791,max:10;n:type:ShaderForge.SFN_Multiply,id:22,x:33205,y:32959|A-17-OUT,B-38-OUT,C-20-OUT,D-655-OUT;n:type:ShaderForge.SFN_Rotator,id:24,x:33003,y:32845|UVIN-646-UVOUT,ANG-22-OUT;n:type:ShaderForge.SFN_Sin,id:38,x:33458,y:32980|IN-39-T;n:type:ShaderForge.SFN_Time,id:39,x:33676,y:32964;n:type:ShaderForge.SFN_Multiply,id:455,x:33230,y:32550|A-15-OUT,B-456-OUT;n:type:ShaderForge.SFN_Vector1,id:456,x:33449,y:32625,v1:1;n:type:ShaderForge.SFN_OneMinus,id:457,x:33007,y:32703|IN-455-OUT;n:type:ShaderForge.SFN_TexCoord,id:646,x:33200,y:32766,uv:0;n:type:ShaderForge.SFN_Vector1,id:654,x:32748,y:32768,v1:0;n:type:ShaderForge.SFN_Tau,id:655,x:33461,y:33225;n:type:ShaderForge.SFN_Fresnel,id:656,x:33019,y:32423;n:type:ShaderForge.SFN_Tex2d,id:669,x:32787,y:32440,ptlb:node_669,ptin:_node_669,tex:7bb91c50e0c30a444aad41c42750c406,ntxv:2,isnm:False|MIP-656-OUT;n:type:ShaderForge.SFN_Multiply,id:692,x:32748,y:32618|A-457-OUT,B-24-UVOUT;n:type:ShaderForge.SFN_Multiply,id:774,x:32772,y:32830|A-455-OUT,B-24-UVOUT;n:type:ShaderForge.SFN_Add,id:800,x:32730,y:32979|A-692-OUT,B-24-UVOUT;proporder:20-669;pass:END;sub:END;*/

Shader "Shader Forge/BlackHole" {
    Properties {
        _node_20 ("node_20", Range(1, 10)) = 1.810791
        _node_669 ("node_669", 2D) = "black" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            #pragma glsl
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform float _node_20;
            uniform sampler2D _node_669; uniform float4 _node_669_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.screenPos = o.pos;
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float node_15 = (distance(i.uv0.rg,float2(0.5,0.5))*2.0);
                float node_455 = (node_15*1.0);
                float4 node_39 = _Time + _TimeEditor;
                float node_24_ang = (saturate((1.0 - node_15))*sin(node_39.g)*_node_20*6.28318530718);
                float node_24_spd = 1.0;
                float node_24_cos = cos(node_24_spd*node_24_ang);
                float node_24_sin = sin(node_24_spd*node_24_ang);
                float2 node_24_piv = float2(0.5,0.5);
                float2 node_24 = (mul(i.uv0.rg-node_24_piv,float2x2( node_24_cos, -node_24_sin, node_24_sin, node_24_cos))+node_24_piv);
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + (((1.0 - node_455)*node_24)+node_24);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float2 node_814 = i.uv0;
                finalColor += diffuseLight * tex2Dlod(_node_669,float4(TRANSFORM_TEX(node_814.rg, _node_669),0.0,(1.0-max(0,dot(normalDirection, viewDirection))))).rgb;
/// Final Color:
                return fixed4(lerp(sceneColor.rgb, finalColor,0.0),1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            #pragma glsl
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform float _node_20;
            uniform sampler2D _node_669; uniform float4 _node_669_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
                LIGHTING_COORDS(4,5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float node_15 = (distance(i.uv0.rg,float2(0.5,0.5))*2.0);
                float node_455 = (node_15*1.0);
                float4 node_39 = _Time + _TimeEditor;
                float node_24_ang = (saturate((1.0 - node_15))*sin(node_39.g)*_node_20*6.28318530718);
                float node_24_spd = 1.0;
                float node_24_cos = cos(node_24_spd*node_24_ang);
                float node_24_sin = sin(node_24_spd*node_24_ang);
                float2 node_24_piv = float2(0.5,0.5);
                float2 node_24 = (mul(i.uv0.rg-node_24_piv,float2x2( node_24_cos, -node_24_sin, node_24_sin, node_24_cos))+node_24_piv);
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + (((1.0 - node_455)*node_24)+node_24);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float2 node_815 = i.uv0;
                finalColor += diffuseLight * tex2Dlod(_node_669,float4(TRANSFORM_TEX(node_815.rg, _node_669),0.0,(1.0-max(0,dot(normalDirection, viewDirection))))).rgb;
/// Final Color:
                return fixed4(finalColor * 0.0,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
