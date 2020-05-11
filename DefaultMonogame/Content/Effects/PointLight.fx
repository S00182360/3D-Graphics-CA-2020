//matrix WorldViewProjection;
float4x4 World;
float4x4 View;
float4x4 Projection;

texture2D Texture;
//texture2D LightTexture;
bool IsEnabled = false;

float3 AmbientColor = float3(.15, .15, .15);
float3 DiffuseColor = float3(1, 1, 1);
float3 LightColor = float3(1, 0, 0);

float3 Position = float3(0, 0, 10);
float Attenuation = 20;
float Falloff = 2;

float3 CameraPos = float3(1, 1, 1);
//float SpecularPower = 32;
//float3 specularColor = float3(1, 0, 0);

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
    //Declare output to be returned
    VertexShaderOutput output;
	
    //Apply world and view matrices to point light
    float4 worldPos = mul(input.Position, World);
    float4 viewPos = mul(worldPos, View);
	
    //set variables from input to output with aplicable transforms
    output.Position = mul(viewPos, Projection);
    output.WorldPosition = worldPos;
    output.UV = input.uv;
    output.Normal = normalize(mul(input.Normal, World));
    output.ViewDirection = worldPos - CameraPos;
	
    //return VertexShaderOutput
    return output;
}

float4 PixelShaderFunc(VertexShaderOutput input) : COLOR0
{
    //Set diffuse colour
    float3 color = DiffuseColor;
	
    //Only apply texture to colour if enabled.
    //Prevents compile error
	if(IsEnabled)
        color *= tex2D(TextureSampler, input.UV);
	
    //set ambient colour, transform direction, normal and difuse
    float3 lighting = AmbientColor;
    float3 lightDirection = normalize(Position - input.WorldPosition);
    float3 normal = normalize(input.Normal);
    float3 difuse = normalize(dot(normal, lightDirection));
	
    //Calculate reflection verctor, view normalisationa and distance from light to pixel
    float3 reflect = reflect(lightDirection, normal);
    float3 view = normalize(input.ViewDirection);
    float distance = distance(Position, input.WorldPosition);
	
    //calculate intensity of light at distance above using inverse law,
    //with FallOff determining rate of loss in intensity
    float atten = 1 - pow(clamp(distance / Attenuation, 0, 1), Falloff);
	
    //Apply lighting attenuation and difuse to LightColor
    lighting += difuse * atten * LightColor;
	
    //Return colour of pixel with lighting effect applied
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

//VertexShaderOutput MainVS(in VertexShaderInput input)
//{
//	VertexShaderOutput output = (VertexShaderOutput)0;

//	output.Position = mul(input.Position, WorldViewProjection);
//	output.Color = input.Color;

//	return output;
//}

//float4 MainPS(VertexShaderOutput input) : COLOR
//{
//	return input.Color;
//}

//technique BasicColorDrawing
//{
//	pass P0
//	{
//		VertexShader = compile VS_SHADERMODEL MainVS();
//		PixelShader = compile PS_SHADERMODEL MainPS();
//	}
//};