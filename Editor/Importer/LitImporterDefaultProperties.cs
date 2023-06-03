
namespace z3y
{
    public static class LitImporterConstants
    {
        public const string DefaultPropertiesInclude = @"
[Enum(Opaque, 0, Cutout, 1, Fade, 2, Transparent, 3, Additive, 4, Multiply, 5)]_Mode(""Rendering Mode"", Float) = 0
[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend(""Source Blend"", Float) = 1
[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend(""Destination Blend"", Float) = 0
[Enum(Off, 0, On, 1)] _ZWrite(""ZWrite"", Float) = 1
[Enum(Off, 0, On, 1)] _AlphaToMask(""AlphaToMask"", Float) = 0
[Enum(UnityEngine.Rendering.CullMode)] _Cull(""Cull"", Float) = 2
[HideInInspector] BAKERY_META_ALPHA_ENABLE(""Enable Bakery alpha meta pass"", Float) = 1
";

        public const string DefaultPropertiesIncludeAfter = @"
[ToggleUI] _BakeryAlphaDither(""Bakery Alpha Dither"", Float) = 0
[ToggleOff(_GLOSSYREFLECTIONS_OFF)] _GlossyReflections(""Reflections"", Float) = 1
[ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SpecularHighlights(""Specular Highlights"", Float) = 1
[HideInInspector] [NonModifiableTextureData] [NoScaleOffset] _DFG(""DFG"", 2D) = ""white"" {}
";

        public const string DefaultConfigFile = @"
DEFINES_START
    // #define BAKERY_MONOSH // enable mono sh globally
DEFINES_END

";
    }

}