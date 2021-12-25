﻿Shader "Simple Lit"
{
    Properties
    {
        [KeywordEnum(Opaque, Cutout, Fade, Transparent)] _Mode ("Rendering Mode", Int) = 0

        _Cutoff ("Alpha Cuttoff", Range(0, 1)) = 0.5

        // pre-generated lookup textures give much better results than any approximations i've found for fresnel
        // generated with cmgen from google filament, with energy compensation
        // possible to swap out with another one, similar to one used in unreal, but energy compensation needs to be removed in code
        [NonModifiableTextureData] _DFG ("DFG Lut", 2D) = "black" {}

        _MainTex ("Base Map", 2D) = "white" {}
        _MainTexArray ("Base Map Array", 2DArray) = "" {}
            _AlbedoSaturation ("Saturation", Range(0,2)) = 1
            _Color ("Base Color", Color) = (1,1,1,1)

        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _GlossinessMin ("Smoothness Min", Range(0,1)) = 0
        [Gamma] _Metallic ("Metallic", Range(0,1)) = 0
        _MetallicMin ("Metallic Min", Range(0,1)) = 0
        _Occlusion ("Occlusion", Range(0,1)) = 0
        _Reflectance ("Reflectance", Range(0.0, 1.0)) = 0.5


        // Packed texture same as the HDRP/Lit Mask Map
        // Red Channel - Metallic
        // Green Channel - Occlusion
        // Blue Channel - Detail Mask
        // Alpha Channel - Smoothness (Inverted Roughness)
        //
        // useful tools for packing outside of unity https://matheusdalla.gumroad.com/l/EasyChannelPacking
        // more advanced packing in unity https://github.com/s-ilent/SmartTexture or
        // https://github.com/Dreadrith/DreadScripts/tree/main/Texture%20Utility
        _MetallicGlossMap ("Packed Mask:Metallic (R) | Occlusion (G) | Detail Mask (B) | Smoothness (A)", 2D) = "white" {}
        _MetallicGlossMapArray ("Packed Mask Array:Metallic (R) | Occlusion (G) | Detail Mask (B) | Smoothness (A)", 2DArray) = "" {}

        // properties used only for texture packing
        // texture get removed when pressing the close button
        _IsPackingMetallicGlossMap ("", Float) = 0
        _MetallicMap ("Metallic Map", 2D) = "black" {}
        [Enum(R, 0, G, 1, B, 2, A, 3)]  _MetallicMapChannel ("", Int) = 0
        _OcclusionMap ("Occlusion Map", 2D) = "white" {}
        [Enum(R, 0, G, 1, B, 2, A, 3)]  _OcclusionMapChannel ("", Int) = 0
        _DetailMaskMap ("Detail Mask", 2D) = "white" {}
        [Enum(R, 0, G, 1, B, 2, A, 3)]  _DetailMaskMapChannel ("", Int) = 0
        _SmoothnessMap ("Smoothness Map", 2D) = "white" {}
        [Enum(R, 0, G, 1, B, 2, A, 3)]  _SmoothnessMapChannel ("", Int) = 0
        [ToggleUI] _SmoothnessMapInvert ("Use Roughness", Float) = 0


        [Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
            _BumpMapArray ("Normal Map Array", 2DArray) = "" {}
            _BumpScale ("Bump Scale", Float) = 1

        [ToggleOff(SPECULAR_HIGHLIGHTS_OFF)] _SpecularHighlights("Specular Highlights", Float) = 1
        [ToggleOff(REFLECTIONS_OFF)] _GlossyReflections("Reflections", Float) = 1

        // removes fresnel from reflections on dark parts of the lightmap
        _SpecularOcclusion ("Specular Occlusion", Range(0,1)) = 0

        [Toggle(GEOMETRIC_SPECULAR_AA)] _GSAA ("Geometric Specular AA", Int) = 0
            [PowerSlider(2)] _specularAntiAliasingVariance ("Variance", Range(0.0, 1.0)) = 0.15
            [PowerSlider(2)] _specularAntiAliasingThreshold ("Threshold", Range(0.0, 1.0)) = 0.1

        [Toggle(EMISSION)] _EnableEmission ("Emission", Int) = 0
            _EmissionMap ("Emission Map", 2D) = "white" {}
            [ToggleUI] _EmissionMultBase ("Multiply Base", Int) = 0
            [HDR] _EmissionColor ("Emission Color", Color) = (0,0,0)

        // Detail texture difference from standard:
        // Uses blend mode overlay,
        // Optional smoothness texture can be packed as albedo alpha
        _DetailAlbedoMap ("Detail Albedo:Albedo (RGB) | Smoothness (A)", 2D) = "linearGrey" {}
        [Normal] _DetailNormalMap ("Detail Normal", 2D) = "bump" {}
            [Enum(UV0, 0, UV1, 1)]  _DetailMapUV ("Detail UV", Int) = 0
            _DetailAlbedoScale ("Albedo Scale", Range(0.0, 2.0)) = 1
            _DetailNormalScale ("Normal Scale", Float) = 1
            _DetailSmoothnessScale ("Smoothness Scale", Range(0.0, 2.0)) = 0

        [Toggle(PARALLAX)] _EnableParallax ("Parallax", Int) = 0
            _Parallax ("Height Scale", Range (0, 0.2)) = 0.02
            _ParallaxMap ("Height Map", 2D) = "white" {}
            [IntRange] _ParallaxSteps ("Parallax Steps", Range(1,50)) = 25
            _ParallaxOffset ("Parallax Offset", Range(-1, 1)) = 0


        [Toggle(NONLINEAR_LIGHTPROBESH)] _NonLinearLightProbeSH ("Non-linear Light Probe SH", Int) = 0

        // specular highlights from lightmaps (Directional, SH and RNM) and for dynamic objects from light probes
        [Toggle(BAKEDSPECULAR)] _BakedSpecular ("Baked Specular ", Int) = 0

        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Source Blend", Int) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Destination Blend", Int) = 0
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
        [Enum(Off, 0, On, 1)] _AlphaToMask ("Alpha To Coverage", Int) = 0

        // property blocks needed to work properly if used in VRChat
        // https://github.com/z3y/UdonBakeryAdapter/
        [KeywordEnum(None, SH, RNM)] Bakery ("Bakery Mode", Int) = 0
            _RNM0("RNM0", 2D) = "black" {}
            _RNM1("RNM1", 2D) = "black" {}
            _RNM2("RNM2", 2D) = "black" {}

        
        // array using uv0 Z for the array index, meshes do not need to be generated with new uv data,
        // only changing the data in memory is enough, unless they are built in unity meshes (cube, sphere, etc)
        // if meshes are static unity will combine them before build and it keeps the modified uv data
        // array instanced using instanced float named _TextureIndex, make sure to also enable instancing
        //
        // scripts for using texture arrays https://github.com/z3y/shaders/tree/main/Scripts/TextureArrays
        // and in vrchat https://github.com/z3y/shaders/tree/main/Scripts/UdonPropertyBlocks
        // for instanced arrays drop the prefab in the scene and on build it will take all values from the C# scripts and handle them on start with one udon behaviour
        // If building for multiple platforms be sure to compress 2D arrays again for the target platform. Unity does not handle this automatically and it can lead to huge performance issues
        // Recommended tool that handles this properly and automatically https://github.com/pschraut/UnityTexture2DArrayImportPipeline
        [KeywordEnum(Default, Array, Array Instanced)] _Texture ("Sampling Mode", Int) = 0
        
        [HideInInspector] [ToggleOff(_TEXTURE_DEFAULT)] _KeywordOffTexture ("", Float) = 1
        [HideInInspector] [ToggleOff(_MODE_OPAQUE)] _KeywordOffOpaque ("", Float) = 1
        [HideInInspector] [ToggleOff(BAKERY_NONE)] _KeywordOffBakery ("", Float) = 1
        // keyword enums suck ill fix it later



    }

    SubShader
    {
        CGINCLUDE
        #pragma target 4.5
        #pragma vertex vert
        #pragma fragment frag
        #pragma fragmentoption ARB_precision_hint_fastest // probably doesnt do anything
        
        #ifndef UNITY_PBS_USE_BRDF1
            #ifndef SHADER_API_MOBILE
            #define SHADER_API_MOBILE
            #endif
        #endif

        // comment out to enable
        #pragma skip_variants VERTEXLIGHT_ON
        #pragma skip_variants LOD_FADE_CROSSFADE
        ENDCG

        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        Pass
        {
            Name "FORWARDBASE"
            Tags { "LightMode"="ForwardBase" }
            ZWrite [_ZWrite]
            Cull [_Cull]
            AlphaToMask [_AlphaToMask]
            Blend [_SrcBlend] [_DstBlend]

            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ VERTEXLIGHT_ON // already defined in vertex by multi_compile_fwdbase
            #pragma multi_compile _ LOD_FADE_CROSSFADE
            

            #define BICUBIC_LIGHTMAP
            #pragma shader_feature_local _ _MODE_CUTOUT _MODE_FADE _MODE_TRANSPARENT
            #pragma shader_feature_local _ BAKERY_SH BAKERY_RNM
            #pragma shader_feature_local SPECULAR_HIGHLIGHTS_OFF
            #pragma shader_feature_local REFLECTIONS_OFF
            #pragma shader_feature_local EMISSION
            #pragma shader_feature_local NONLINEAR_LIGHTPROBESH
            #pragma shader_feature_local BAKEDSPECULAR
            #pragma shader_feature_local GEOMETRIC_SPECULAR_AA
            #pragma shader_feature_local PARALLAX

            #pragma shader_feature_local _ _TEXTURE_ARRAY _TEXTURE_ARRAY_INSTANCED
            #pragma shader_feature_local _MASK_MAP
            #pragma shader_feature_local _NORMAL_MAP
            #pragma shader_feature_local _DETAILALBEDO_MAP
            #pragma shader_feature_local _DETAILNORMAL_MAP

            #include "PassCGI.cginc"
            ENDCG
        }

        Pass
        {
            Name "FORWARD_DELTA"
            Tags { "LightMode"="ForwardAdd" }
            Fog { Color (0,0,0,0) }
            Blend [_SrcBlend] One
            Cull [_Cull]
            ZWrite Off
            ZTest LEqual
            AlphaToMask [_AlphaToMask]

            CGPROGRAM
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_instancing
            #pragma multi_compile_fog

            #pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma shader_feature_local _ _MODE_CUTOUT _MODE_FADE _MODE_TRANSPARENT
            #pragma shader_feature_local SPECULAR_HIGHLIGHTS_OFF
            #pragma shader_feature_local NONLINEAR_LIGHTPROBESH
            #pragma shader_feature_local GEOMETRIC_SPECULAR_AA
            #pragma shader_feature_local PARALLAX

            #pragma shader_feature_local _ _TEXTURE_ARRAY _TEXTURE_ARRAY_INSTANCED
            #pragma shader_feature_local _MASK_MAP
            #pragma shader_feature_local _NORMAL_MAP
            #pragma shader_feature_local _DETAILALBEDO_MAP
            #pragma shader_feature_local _DETAILNORMAL_MAP

            
            #include "PassCGI.cginc"

            ENDCG
        }

        Pass
        {
            Name "SHADOWCASTER"
            Tags { "LightMode"="ShadowCaster" }
            ZWrite On
            Cull [_Cull]
            ZTest LEqual

            CGPROGRAM
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #pragma multi_compile _ LOD_FADE_CROSSFADE
            
            #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

            #pragma shader_feature_local _ _TEXTURE_ARRAY _TEXTURE_ARRAY_INSTANCED

            #pragma shader_feature_local _ _MODE_CUTOUT _MODE_FADE _MODE_TRANSPARENT

            #include "PassCGI.cginc"
            ENDCG
        }

        Pass
        {
            Name "META"
            Tags { "LightMode"="Meta" }
            Cull Off

            CGPROGRAM
            #pragma shader_feature EDITOR_VISUALIZATION

            #pragma shader_feature_local _ _MODE_CUTOUT _MODE_FADE _MODE_TRANSPARENT
            #pragma shader_feature_local EMISSION

            #pragma shader_feature_local _ _TEXTURE_ARRAY _TEXTURE_ARRAY_INSTANCED        

            #include "PassCGI.cginc"
            ENDCG
        }
    }
    CustomEditor "z3y.Shaders.SimpleLit.ShaderEditor"
}
