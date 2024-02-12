#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
// vignette https://www.shadertoy.com/view/XdcXRH
uniform float iTime;
uniform float vignetteStrength=1.0;
void mainImage()
{
    float timeFactor = ( 1.0 + sin( iTime ) ) / 2.0;
    vec2 nCoord = fragCoord/iResolution.xy;
    vec4 color = texture( iChannel0, nCoord );
    vec2 centeredCoord = nCoord - 0.5;
    
    float distance = sqrt( dot( centeredCoord,centeredCoord ) );
    
    fragColor = mix( color, vec4(0), distance * vignetteStrength * timeFactor );
}