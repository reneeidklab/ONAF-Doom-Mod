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
	
	mat.Specular = texture(speculartexture, warpUV(uv, 0, 2.0, vec2(0,timer*0.5))).rgb;
	mat.Normal = ApplyNormalMap(warpUV(uv, 15, 1.0, vec2(timer*0.25,0)));
	mat.Base = getTexel(warpUV(uv - (mat.Normal.xy * 1.0), 0, 0.6, vec2(0,0)));
	
	vec3 cloud = mat.Specular.rgb * mat.Base.rgb * 2.0;
	vec4 bigCloud = texture(speculartexture, warpUV((uv*(1.0-sin(timer*0.025)*0.25)) + mat.Normal.xy/1.5, 0, 1.0, vec2(timer*0.1,timer*0.05)));
	mat.Base = getTexel(warpUV(uv + (mat.Normal.xy * 0.05), 0, 1.0, vec2(timer*0.25,timer*0.25)));
	mat.Base += vec4(mat.Specular * bigCloud.b, 1.0) * texture(speculartexture, warpUV(uv*0.5, 0, 1.0, vec2(0, timer*0.25)));
	vec3 eyedir = normalize(uCameraPos.xyz-pixelpos.xyz) * 0.5 ;
	mat.Base += mat.Base * bigCloud.r * 0.35;
	mat.Base += mat.Base * cloud.b * 0.35;
	mat.Base += mat.Base * getTexel(warpUV(eyedir.zx + (mat.Normal.xy*0.05)*5, 0, 3.0, vec2(0, timer*-0.05)) + (mat.Normal.xy * 0.2) * (1.0-mat.Specular.b)) * 3;
	mat.Base += getTexel(warpUV(uv + (mat.Normal.xy * 0.125) * 1.5, 0.5, 0.25, vec2(timer*0.15,timer*0.15)));
	mat.Base /= 1.666;
	mat.Base.a = 1.0;
	mat.AO = mat.Specular.b;
}
