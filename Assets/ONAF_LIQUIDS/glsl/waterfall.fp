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
	vec2 uv = vTexCoord.st;
	vec2 uvScroll = mod(vec2(timer * 0.125, timer*-texture(tex_scroll, uv).r) * 0.25, 1.0);
	float speedMap = getTexel((uv += uvScroll) * 0.125).r;
	uv += ( uvScroll + speedMap );
	uv = mod(uv, 1.0);
	SetMaterialProps(mat, uv);
	
	mat.Specular = texture(speculartexture, uv).rgb;
	mat.Normal = ApplyNormalMap(uv);
	mat.Base = getTexel(uv);
	
	vec3 eyedir = normalize(uCameraPos.xyz-pixelpos.xyz) * 0.5;
	mat.Base += mat.Base * getTexel((eyedir.xz*2) - (uvScroll*2.0)) * 1;
	mat.Base += getTexel(uv*0.5);
	mat.Base /= 1.5;
	mat.Base.a = 1.0;
	mat.AO = mat.Specular.r;
}
