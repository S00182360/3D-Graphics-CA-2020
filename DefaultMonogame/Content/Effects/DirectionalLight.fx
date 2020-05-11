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

bool TextureEnabled;
texture Texture;
float3 DiffuseColor;
float3 AmbientColor;
float3 LightDir;
float3 LightColor;

sampler TextureSampler = sampler_state
{
    texture = <Texture>;
};

struct VertexShaderInput
{
	float4 Position : SV_Position0;
	float2 UV :TEXCOORD0;
    float3 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
    float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    //Delcare output VertexShaderOutput after calculation
    VertexShaderOutput output;
    
    //Apply World and View matricies
    float4 worldPos = mul(input.Position, World);
    float4 viewPos = mul(worldPos, View);
	
    //Use world and view as calculated above and apply to output lighting effect
    output.Position = mul(viewPos, Projection);
    output.UV = input.UV;
    output.Normal = mul(input.Normal, World);
	
    //return output VertexShaderOutput
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input)
{
    //Set colour used for Diffuse
    float3 color = DiffuseColor;
    //If a texture needs to be considered, take the UV value from Texture
    //and apply to color
	if(TextureEnabled)
        color *= tex2D(TextureSampler, input.UV);
    
    //Ambient light color 
    float3 lighting = AmbientColor;
    //Normalize the direction of the light
    //Magnitude not relevant 
    float3 lightDir = normalize(lightDir);
    //Take input normal and ensure it is normalized
    float3 normal = normalize(input.Normal);
	
    //directional lighting effect has no falloff or attenuation
    //take the colour of the light, multiply by dot product 
    //of direction and normal for lambert lighing effect
    lighting += saturate(dot(lightDir, normal)) * LightColor;
    float3 output = saturate(lighting * color);
    return float4(output, 1);
}

technique BasicColorDrawing
{
	pass P0
	{
        VertexShader = compile VS_SHADERMODEL VertexShaderFunction();
        PixelShader = compile PS_SHADERMODEL PixelShaderFunction();
    }
};

//VertexShaderOutput MainVS(in VertexShaderInput input)
//{
//    VertexShaderOutput output = (VertexShaderOutput) 0;

//    output.Position = mul(input.Position, WorldViewProjection);
//    output.Color = input.Color;

//    return output;
//}

//float4 MainPS(VertexShaderOutput input) : COLOR
//{
//	return input.Color;
//}