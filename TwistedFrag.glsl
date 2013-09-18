uniform vec3 mouse;
uniform float mouseSize;
uniform float translucency;
uniform int peerInside;
uniform int selected;
uniform int toon;

varying vec4 diffuse,ambientGlobal, ambient, ecPos;
varying vec3 normal,halfVector;
varying float dist;
 
 varying vec4 myver;
void main()
{
// outlining stuff
vec3 NN = normalize(normal);
float ink = dot(normalize(-vec3(ecPos*2)), NN);
ink = clamp(pow(ink*3.0, 20.0), 0.0, 1.0);

    vec3 n,halfV;
    float NdotL,NdotHV;
    vec4 color = ambientGlobal;
    float att,spotEffect;
     
    /* a fragment shader can't write a verying variable, hence we need
    a new variable to store the normalized interpolated normal */
    n = normalize(normal);
     
    // Compute the ligt direction
    vec3 lightDir = vec3(gl_LightSource[0].position-ecPos);
     
	 gl_LightSource[0].spotDirection = vec3(0, 0, -1);
	 
    /* compute the distance to the light source to a varying variable*/
    dist = length(lightDir);
 
    /* compute the dot product between normal and ldir */
    NdotL = max(dot(n,normalize(lightDir)),0.0);
 
    if (NdotL > 0.0) {
     
        spotEffect = dot(normalize(gl_LightSource[0].spotDirection), normalize(-lightDir));
        if (spotEffect > gl_LightSource[0].spotCosCutoff) {
            spotEffect = pow(spotEffect, gl_LightSource[0].spotExponent);
            att = spotEffect / (gl_LightSource[0].constantAttenuation +
                    gl_LightSource[0].linearAttenuation * dist +
                    gl_LightSource[0].quadraticAttenuation * dist * dist);
                 
            color += att * (diffuse * NdotL + ambient);
         
             
            halfV = normalize(halfVector);
            NdotHV = max(dot(n,halfV),0.0);
            color += att * gl_FrontMaterial.specular * gl_LightSource[0].specular * pow(NdotHV,gl_FrontMaterial.shininess);
        }
    }

	float d = (myver.y - mouse.y)*(myver.y - mouse.y) + (myver.x - mouse.x)*(myver.x - mouse.x)+ (myver.z - mouse.z)*(myver.z - mouse.z);	
		
	 if (d < mouseSize*mouseSize)
	{
		if (peerInside == 1)
		{
			// if distance is less than % of mouseSize
			//if (d < 0.7*0.7*mouseSize*mouseSize)
			if (d > 0.98*mouseSize)
			{
				translucency = d / mouseSize;
				//translucency = 0.9;
			}
			else if (d > 0.95*mouseSize)
			{
				translucency = .95;
			}
			else if (d > 0.90*mouseSize)
			{
				translucency = .90;
			}
			else	// if distance is between 90 and 100% of mouseSize, do a little fading (d = ratio*mouseSize*mouseSize)
			{
				translucency = 0;
			}
			
		}
	
		gl_FragColor = vec4(vec3(color * .7), translucency);
	}
	else
	{
		gl_FragColor = vec4(vec3(color), translucency);
		//gl_FragColor = vec4(vec3(gl_Normal.x, gl_Normal.y, gl_Normal.z), translucency);
	}

	
	// outline in black
	if (toon == 1)
	{
		gl_FragColor = gl_FragColor - vec4((1-ink), (1-ink), (1-ink), 0.0);
	}
	
	// highlight selected in brighter red
	if (selected == 1)
	{
			gl_FragColor = gl_FragColor + vec4(0.2, 0.2, 0.2, 0);
			gl_FragColor.r = gl_FragColor.r + .5;
			
	}
}