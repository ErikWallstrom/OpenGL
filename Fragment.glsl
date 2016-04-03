#version 120

uniform sampler2D diffuse;

void main(void)
{
	//gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
	gl_FragColor = texture2D(diffuse, vec2(0.8, 0.2));
	
}
