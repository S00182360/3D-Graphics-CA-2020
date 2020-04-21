#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix WorldViewProjection;
float4x4 World;
float4x4 View;
float4x4 Projection;

texture2D Texture;
texture2D LightTexture;
bool IsEnabled = false;

float3 AmbientColor = float3(.15, .15, .15);
float3 DiffuseColor = float3(1, 1, 1);
float3 LightColor = float3(1, 0, 0);

float3 Position = float3(0, 0, 10);
float Attenuation = 20;
float Falloff = 2;

float3 CameraPos = float3(1, 1, 1);
float SpecularPower = 32;
float3 specularColor = float3(1, 0, 0);

sampler2D TextureSampler = sampler_state
{
    texture = <Texture>;
};

struct VertexShaderInput
{
	float4 Position : SV_POSITION0;
    float2 uv : TEXTCOORD0;
	float4 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION0;
    float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
    float3 ViewDirection : TEXCOORD3;
};

VertexShaderOutput VertexShaderFunc(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    float4 worldPos = mul(input.Position, World);
    float4 viewPos = mul(worldPos, View);
	
    output.Position = mul(viewPos, Projection);
    output.WorldPosition = worldPos;
    output.UV = input.uv;
    output.Normal = normalize(mul(input.Normal, World));
    output.ViewDirection = worldPos - CameraPos;
	
    return output;
}

float4 PixelShaderFunc(VertexShaderOutput input) : COLOR0
{
    float3 color = DiffuseColor;
	
	if(IsEnabled)
        color *= tex2D(TextureSampler, input.UV);
	
    float3 lighting = AmbientColor;
    float3 lightDirection = normalize(Position, input.WorldPosition);
    float3 normal = normalize(input.Normal);
    float3 difuse = normalize(dot(normal, lightDirection));
	
    float3 reflect = reflect(lightDirection, normal);
    float3 view = normalize(input.ViewDirection);
    float distance = distance(Position, input.WorldPosition);
	
    float atten = 1 - pow(clamp(distance / Attenuation, 0, 1), Falloff);
	
    lighting += difuse * atten * LightColor;
	
    return float4(color * lighting, 1);
}

technique Compiler
{
    pass Pass1
    {
        VertexShader = compile vs_5_0 VertexShaderFunc();
        PixelShader = compile ps_5_0 PixelShaderFunc();
    }
}

VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output = (VertexShaderOutput)0;

	output.Position = mul(input.Position, WorldViewProjection);
	output.Color = input.Color;

	return output;
}

float4 MainPS(VertexShaderOutput input) : COLOR
{
	return input.Color;
}

technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};