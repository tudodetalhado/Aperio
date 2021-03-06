/*******************************************************************
	Fragment
	DOT Post-process Shader : Dot Screen Shader
*******************************************************************/

vec2 center = vec2(0.5, 0.5);
float angle = 1.57;
float scale = 1.0;
vec2 tSize = vec2(1024, 1024);

uniform sampler2D source;

vec2 vUv = gl_TexCoord[0].st;

float pattern() {

	float s = sin( angle ), c = cos( angle );

	vec2 tex = vUv * tSize - center;
	vec2 point = vec2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;

	return ( sin( point.x ) * sin( point.y ) ) * 4.0;

}

void main() {

	vec4 color = texture2D( source, vUv );

	float average = ( color.r + color.g + color.b ) / 3.0;

	gl_FragColor = vec4( vec3( average * 10.0 - 5.0 + pattern() ), color.a );

}