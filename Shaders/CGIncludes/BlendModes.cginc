#ifndef BLEND_MODES_INCLUDED
#define BLEND_MODES_INCLUDED
//******************************************************************************
// Selects the blend color, ignoring the base.
//******************************************************************************
float3 BlendMode_Normal(float3 base, float3 blend)
{
	return blend;
}

//******************************************************************************
// Looks at the color information in each channel and selects the base or blend 
// color—whichever is darker—as the result color.
//******************************************************************************
float3 BlendMode_Darken(float3 base, float3 blend)
{
	return min(base, blend);
}

//******************************************************************************
// Looks at the color information in each channel and multiplies the base color
// by the blend color.
//******************************************************************************
float3 BlendMode_Multiply(float3 base, float3 blend)
{
	return base*blend;
}

float3 BlendMode_MultiplyX2(float3 base, float3 blend)
{
	return base * blend * unity_ColorSpaceDouble.rgb;
}

//******************************************************************************
// Looks at the color information in each channel and darkens the base color to 
// reflect the blend color by increasing the contrast between the two.
//******************************************************************************
float BlendMode_ColorBurn(float base, float blend)
{
    if (base >= 1.0)
        return 1.0;
    else if (blend <= 0.0)
        return 0.0;
    else    
    	return 1.0 - min(1.0, (1.0-base) / blend);
}

float3 BlendMode_ColorBurn(float3 base, float3 blend)
{
	return float3(  BlendMode_ColorBurn(base.r, blend.r), 
					BlendMode_ColorBurn(base.g, blend.g), 
					BlendMode_ColorBurn(base.b, blend.b) );
}

//******************************************************************************
// Looks at the color information in each channel and darkens the base color to 
// reflect the blend color by decreasing the brightness.
//******************************************************************************
float BlendMode_LinearBurn(float base, float blend)
{
	return max(0, base + blend - 1);
}

float3 BlendMode_LinearBurn(float3 base, float3 blend)
{
	return float3(  BlendMode_LinearBurn(base.r, blend.r), 
					BlendMode_LinearBurn(base.g, blend.g), 
					BlendMode_LinearBurn(base.b, blend.b) );
}

//******************************************************************************
// Looks at the color information in each channel and selects the base or blend 
// color—whichever is lighter—as the result color.
//******************************************************************************
float3 BlendMode_Lighten(float3 base, float3 blend)
{
	return max(base, blend);
}

//******************************************************************************
// Looks at each channel’s color information and multiplies the inverse of the
// blend and base colors.
//******************************************************************************
float3 BlendMode_Screen(float3 base, float3 blend)
{
	return base + blend - base*blend;
}

//******************************************************************************
// Looks at the color information in each channel and brightens the base color 
// to reflect the blend color by decreasing contrast between the two. 
//******************************************************************************
float BlendMode_ColorDodge(float base, float blend)
{
	if (base <= 0.0)
		return 0.0;
	if (blend >= 1.0)
		return 1.0;
	else
		return min(1.0, base / (1.0-blend));
}

float3 BlendMode_ColorDodge(float3 base, float3 blend)
{
	return float3(  BlendMode_ColorDodge(base.r, blend.r), 
					BlendMode_ColorDodge(base.g, blend.g), 
					BlendMode_ColorDodge(base.b, blend.b) );
}

//******************************************************************************
// Looks at the color information in each channel and brightens the base color 
// to reflect the blend color by decreasing contrast between the two. 
//******************************************************************************
float BlendMode_LinearDodge(float base, float blend)
{
	return min(1, base + blend);
}

float3 BlendMode_LinearDodge(float3 base, float3 blend)
{
	return float3(  BlendMode_LinearDodge(base.r, blend.r), 
					BlendMode_LinearDodge(base.g, blend.g), 
					BlendMode_LinearDodge(base.b, blend.b) );
}

//******************************************************************************
// Multiplies or screens the colors, depending on the base color. 
//******************************************************************************
float BlendMode_Overlay(float base, float blend)
{
	return (base <= 0.5) ? 2*base*blend : 1 - 2*(1-base)*(1-blend);
}

// float3 BlendMode_Overlay(float3 base, float3 blend)
// {
// 	return float3(  BlendMode_Overlay(base.r, blend.r), 
// 					BlendMode_Overlay(base.g, blend.g), 
// 					BlendMode_Overlay(base.b, blend.b) );
// }

// optimized without unnecessary casting

float3 BlendMode_Overlay(float3 base, float3 blend)
{
	return (base <= 0.5) ? 2*base*blend : 1 - 2*(1-base)*(1-blend);
}

float3 BlendMode_Overlay_sRGB(float3 base, float3 blend)
{
	base = sqrt(base);
	return BlendMode_Overlay(base, blend);
}

//******************************************************************************
// Darkens or lightens the colors, depending on the blend color. 
//******************************************************************************
float BlendMode_SoftLight(float base, float blend)
{
	if (blend <= 0.5)
	{
		return base - (1-2*blend)*base*(1-base);
	}
	else
	{
		float d = (base <= 0.25) ? ((16*base-12)*base+4)*base : sqrt(base);
		return base + (2*blend-1)*(d-base);
	}
}

float3 BlendMode_SoftLight(float3 base, float3 blend)
{
	return float3(  BlendMode_SoftLight(base.r, blend.r), 
					BlendMode_SoftLight(base.g, blend.g), 
					BlendMode_SoftLight(base.b, blend.b) );
}

//******************************************************************************
// Multiplies or screens the colors, depending on the blend color.
//******************************************************************************
float BlendMode_HardLight(float base, float blend)
{
	return (blend <= 0.5) ? 2*base*blend : 1 - 2*(1-base)*(1-blend);
}

float3 BlendMode_HardLight(float3 base, float3 blend)
{
	return float3(  BlendMode_HardLight(base.r, blend.r), 
					BlendMode_HardLight(base.g, blend.g), 
					BlendMode_HardLight(base.b, blend.b) );
}

//******************************************************************************
// Burns or dodges the colors by increasing or decreasing the contrast, 
// depending on the blend color. 
//******************************************************************************
float BlendMode_VividLight(float base, float blend)
{
	return (blend <= 0.5) ? BlendMode_ColorBurn(base,2*blend) : BlendMode_ColorDodge(base,2*(blend-0.5));
}

float3 BlendMode_VividLight(float3 base, float3 blend)
{
	return float3(  BlendMode_VividLight(base.r, blend.r), 
					BlendMode_VividLight(base.g, blend.g), 
					BlendMode_VividLight(base.b, blend.b) );
}

//******************************************************************************
// Burns or dodges the colors by decreasing or increasing the brightness, 
// depending on the blend color.
//******************************************************************************
float BlendMode_LinearLight(float base, float blend)
{
	return (blend <= 0.5) ? BlendMode_LinearBurn(base,2*blend) : BlendMode_LinearDodge(base,2*(blend-0.5));
}

float3 BlendMode_LinearLight(float3 base, float3 blend)
{
	return float3(  BlendMode_LinearLight(base.r, blend.r), 
					BlendMode_LinearLight(base.g, blend.g), 
					BlendMode_LinearLight(base.b, blend.b) );
}

//******************************************************************************
// Replaces the colors, depending on the blend color.
//******************************************************************************
float BlendMode_PinLight(float base, float blend)
{
	return (blend <= 0.5) ? min(base,2*blend) : max(base,2*(blend-0.5));
}

float3 BlendMode_PinLight(float3 base, float3 blend)
{
	return float3(  BlendMode_PinLight(base.r, blend.r), 
					BlendMode_PinLight(base.g, blend.g), 
					BlendMode_PinLight(base.b, blend.b) );
}

//******************************************************************************
// Adds the red, green and blue channel values of the blend color to the RGB 
// values of the base color. If the resulting sum for a channel is 255 or 
// greater, it receives a value of 255; if less than 255, a value of 0.
//******************************************************************************
float BlendMode_HardMix(float base, float blend)
{
	return (base + blend >= 1.0) ? 1.0 : 0.0;
}

float3 BlendMode_HardMix(float3 base, float3 blend)
{
	return float3(  BlendMode_HardMix(base.r, blend.r), 
					BlendMode_HardMix(base.g, blend.g), 
					BlendMode_HardMix(base.b, blend.b) );
}

//******************************************************************************
// Looks at the color information in each channel and subtracts either the 
// blend color from the base color or the base color from the blend color, 
// depending on which has the greater brightness value. 
//******************************************************************************
float3 BlendMode_Difference(float3 base, float3 blend)
{
	return abs(base-blend);
}

//******************************************************************************
// Creates an effect similar to but lower in contrast than the Difference mode.
//******************************************************************************
float3 BlendMode_Exclusion(float3 base, float3 blend)
{
	return base + blend - 2*base*blend;
}

//******************************************************************************
// Looks at the color information in each channel and subtracts the blend color 
// from the base color.
//******************************************************************************
float3 BlendMode_Subtract(float3 base, float3 blend)
{
	return max(0, base - blend);
}

//******************************************************************************
// Looks at the color information in each channel and divides the blend color 
// from the base color.
//******************************************************************************
float BlendMode_Divide(float base, float blend)
{
	return blend > 0 ? min(1, base / blend) : 1;
}

float3 BlendMode_Divide(float3 base, float3 blend)
{
	return float3(  BlendMode_Divide(base.r, blend.r), 
					BlendMode_Divide(base.g, blend.g), 
					BlendMode_Divide(base.b, blend.b) );
}
#endif