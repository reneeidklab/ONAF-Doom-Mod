#define pi 3.14159265358979323846

vec2 warpUV(vec2 uv, float timeOffset, float mult, vec2 scroll)
{
	vec2 offset = vec2(0,0);
	float t = timer + timeOffset;
	offset.y = 0.5*sin(pi * 3.0 * (uv.x + t * 0.125)) * 0.1 * mult;
	offset.x = 0.5*sin(pi * 3.0 * (uv.y + t * 0.125)) * 0.1 * mult;
    uv += offset + scroll;
	return uv;
}

void SetupMaterial(inout Material mat)
{
    mat.Roughness = 1.0;
	mat.Metallic = 0;
	vec2 uv = vTexCoord.st * 0.5;
	SetMaterialProps(mat, uv);
	
	mat.Specular = texture(speculartexture, warpUV(uv, 0, 0.5, vec2(0,timer*0.05))).rgb;
	mat.Normal = ApplyNormalMap(warpUV(uv, 15, 0.3, vec2(timer*0.07,0)));
	mat.Base = getTexel(warpUV(uv, 0, 0.4, vec2(0,0)));
	
	vec3 cloud = mat.Specular.rgb * mat.Base.rgb * 2.0;
	vec4 bigCloud = texture(speculartexture, warpUV((uv*(1.0-sin(timer*0.025)*0.125)) + mat.Normal.yx, 0, 1.0, vec2(timer*-0.1,timer*0.05)));
	mat.Base = getTexel(warpUV(uv, 0, 1.0, vec2(timer+mat.Normal.x*0.125,timer+mat.Normal.y*0.125)));
	vec4 emit = texture(tex_emit, warpUV(uv, 0, 1.0, vec2(timer*0.125,timer*0.125)));
	mat.Base += vec4(mat.Specular * bigCloud.r, 1.0) * texture(speculartexture, warpUV(uv*0.333, 0, 0.4, vec2(0, timer*0.1)));
	vec3 eyedir = normalize(uCameraPos.xyz-pixelpos.xyz) * 0.333;
	mat.Base += mat.Base * bigCloud.r * 0.25;
	mat.Base += mat.Base * cloud.r * 0.35;
	mat.Base *= getTexel(warpUV(eyedir.xy*2, 0, 2.0, vec2(0, timer*-0.05)) + (mat.Normal.xy * 0.2) * (1.0-mat.Specular.r)) * 2;
	mat.Base *= emit;
	mat.Base += getTexel(warpUV(uv, 0, 0.4, vec2(0,0)));
	mat.Base.a = 1.0;
	mat.Glow = mat.Base;
	mat.AO = mat.Specular.r;
}
