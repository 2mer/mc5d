#version 150

uniform sampler2D DiffuseSampler;

uniform vec4 ColorModulate;
uniform int Multiplier;// just checking ints work
uniform vec2 OutSize;
//uniform float Time;
uniform float pTime;

//in vec2 texCoord;
in vec2 texCoord;

out vec4 fragColor;

vec3 palette(in float t) {
    vec3 a=vec3(.5, .5, .5);
    vec3 b=vec3(.5, .5, .5);
    vec3 c=vec3(2., 1., 0.);
    vec3 d=vec3(.50, .20, .25);

    return a+b*cos(6.28318*(c*t+d));
}

vec4 coolColors() {
    vec2 uv = texCoord;
    float resolution = OutSize.x / OutSize.y;

    vec3 finalColor=vec3(0.);

    uv-=.5;
    uv=uv*2.;
    uv.x*=resolution;

    vec2 uv0=uv;

    for (float iter=0.;iter<2.;iter++){
        float d0=length(uv);
        d0*=d0;
        d0*=d0;
        d0=.05/d0;
        d0=smoothstep(-20., 30., d0);

        uv*=5.;
        uv*=d0/.4;
        uv += iter*1.5;
        uv=fract(uv);
        uv-=.5;

        float d=length(uv);

        vec3 col=palette(length(uv0)+(pTime*.5));

        d=sin(d*8.+pTime)/8.;
        d=abs(d);
        d=.02/d;

        finalColor+=col*=d;

    }

    return vec4(finalColor, 1);
}

float not(float v) {
    return 1-v;
}

float circle(vec2 sPos, vec2 cPos, float rad) {
    float d = distance(sPos, cPos);
    return not(step(rad, d));
}

float smoothCircle(vec2 sPos, vec2 cPos, float rad, float strength) {
    float d = distance(sPos, cPos);
    return not(smoothstep(strength * rad, rad, d));
}

vec4 mix(float progress, vec4 a, vec4 b) {
    return (progress * a) + (not(progress) * b);
}

void main() {

    vec4 super = texture(DiffuseSampler, texCoord) * ColorModulate * float(Multiplier);
    vec4 coolClr = coolColors();

    vec2 uv = texCoord;
    float resolution = OutSize.x / OutSize.y;

    //    center uv
    uv -= 0.5;
    uv *= 2;

    // fix resolution
    uv.x *= resolution;

    float isCircle = smoothCircle(uv, vec2(0, 0), 0.9, 0.8);
    float isOuterCircle = smoothCircle(uv, vec2(0, 0), 2., 1.);

    vec4 finalColor = mix(isCircle, coolClr, super);
    finalColor += coolClr * 0.2 * isOuterCircle, finalColor;

    fragColor = finalColor;
}