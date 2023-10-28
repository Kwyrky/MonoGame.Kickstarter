#if OPENGL
#define SV_POSITION POSITION
#define VS_SHADERMODEL vs_3_0
#define PS_SHADERMODEL ps_3_0
#else
#define VS_SHADERMODEL vs_4_0_level_9_1
#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

float4x4 World;
float4x4 View;
float4x4 Projection;

#if OPENGL
texture Texture;
sampler TextureSampler = sampler_state
{
    texture = <Texture>;
    MagFilter = linear;
    MinFilter = linear;
    MipFilter = linear;
    AddressU = wrap;
    AddressV = wrap;
};
#else
Texture2D Texture;
SamplerState TextureSampler
{
    magfilter = LINEAR;
    minfilter = LINEAR;
    mipfilter = LINEAR;
    AddressU = Wrap;
    AddressV = Wrap;
};
#endif

struct VertexShaderInput
{
    float4 Position : SV_POSITION;
    float4 Color : COLOR0;
    float2 UV : TEXCOORD0;
};
 
struct VertexShaderOutput
{
    float4 Position : SV_POSITION;
    float4 Color : COLOR0;
    float2 UV : TEXCOORD0;
};
 
struct PixelShaderOutput
{
    float4 Color : SV_TARGET;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output = (VertexShaderOutput) 0;
     
    float4 worldPosition = mul(input.Position, World);
    float4 viewPosition = mul(worldPosition, View);
    float4 projectionPosition = mul(viewPosition, Projection);
    output.Position = projectionPosition;

    output.Color = input.Color;

    output.UV = input.UV;
 
    return output;
}
 
PixelShaderOutput PixelShaderFunction(VertexShaderOutput input)
{
    PixelShaderOutput output;
 
#if OPENGL
    output.Color = input.Color * tex2D(TextureSampler, input.UV * 2);
#else
    output.Color = input.Color * Texture.Sample(TextureSampler, input.UV * 2);
#endif

    return output;
}
 
technique Technique1
{
    pass Pass1
    {
        VertexShader = compile VS_SHADERMODEL VertexShaderFunction();
        PixelShader = compile PS_SHADERMODEL PixelShaderFunction();
    }
}