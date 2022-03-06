
#if defined(SHADER_API_MOBILE)
    #undef _DETAILNORMAL_MAP
    #undef NONLINEAR_LIGHTPROBESH
    #undef PARALLAX
    #undef NEED_CENTROID_NORMAL
    #undef VERTEXLIGHT_PS
    #undef HEMIOCTAHEDRON_DECODING
    #undef BICUBIC_LIGHTMAP
    #undef BAKERY_BICUBIC
    #undef LTCGI
    #undef BAKERY_SHNONLINEAR

    #define SPECULAR_HIGHLIGHTS_OFF // TODO: fix precision issues on mobile
    #undef _DETAILALBEDO_MAP
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
#else
    #undef BAKERY_SH
    #undef BAKERY_RNM
#endif

#ifdef LTCGI
    #ifdef SPECULAR_HIGHLIGHTS_OFF
        #define LTCGI_SPECULAR_OFF
    #endif
#include "Assets/_pi_/_LTCGI/Shaders/LTCGI.cginc"
#endif


#if defined(BAKERY_SH) || defined(BAKERY_RNM)
    #define NEED_PARALLAX_DIR
    
    #ifdef BAKEDSPECULAR
        #define BAKERY_LMSPEC
    #endif
#endif