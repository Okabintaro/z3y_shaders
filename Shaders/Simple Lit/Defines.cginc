#define grayscaleVec half3(0.2125, 0.7154, 0.0721)
#define TAU 6.28318530718
#define glsl_mod(x,y) (((x)-(y)*floor((x)/(y))))


#if defined(SHADER_API_MOBILE)
    #undef _DETAILNORMAL_MAP
    #undef NONLINEAR_LIGHTPROBESH
    #undef PARALLAX
    #undef BAKEDSPECULAR
    #undef DIRLIGHTMAP_COMBINED
    #undef NEED_CENTROID_NORMAL
    #undef VERTEXLIGHT_PS
    #undef HEMIOCTAHEDRON_DECODING
    #undef BICUBIC_LIGHTMAP
    #undef BAKERY_BICUBIC
#endif

#ifdef UNITY_PASS_META
    #include "UnityMetaPass.cginc"
#endif

#if defined(LIGHTMAP_SHADOW_MIXING) && defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) && defined(LIGHTMAP_ON)
    #define NEED_SCREEN_POS
#endif

#ifdef LIGHTMAP_ON
    #if defined(BAKERY_RNM) || defined(BAKERY_SH) || defined(BAKERY_VERTEXLM)
        #define BAKERYLM_ENABLED
        #undef DIRLIGHTMAP_COMBINED
    #endif
#endif


#if defined(BAKERY_SH) || defined(BAKERY_RNM) || defined(BAKERY_VOLUME)

    #ifdef BAKERY_SH
        #define BAKERY_SHNONLINEAR
    #endif

    #define NEED_PARALLAX_DIR
    
    #ifdef BAKEDSPECULAR
        #define _BAKERY_LMSPEC
        #define BAKERY_LMSPEC
    #endif

    #include "../CGIncludes/Bakery.cginc"
#endif