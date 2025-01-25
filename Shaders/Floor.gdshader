shader_type spatial;

//Taken from https://www.shadertoy.com/view/ltXfRr

// --- alternate direct computation of ellipse geometry. Which is cheaper ? ( both have 5 sqrt +  5 div )
void ellips(in mat2 M, out vec2 A0, out vec2 A1, out float r0, out float r1) {
    vec2 I = M[0], J = M[1];                        // ellipse: P = cos(u).I + sin(u).J
    float a = ( dot(J,J) - dot(I,I) ) / dot (I,J),  // -> search for extrema of length(P)
          D = sqrt(a*a+4.),                         // get tan(u) -> s, c, axis*radii
          t0 = (a+D)/2., t1 = (a-D)/2.;
    A0 = (I + t0*J) / sqrt(1.+t0*t0);               // c = 1/sqrt(1+tÂ²), s = t/sqrt(1+tÂ²)
    A1 = (I + t1*J) / sqrt(1.+t1*t1);               // axis also encodes radius
    r0 = length(A0); A0 /= r0;
    r1 = length(A1); A1 /= r1;
    if (r1>r0){
		a=r0; r0=r1; r1=a;
		 I=A0;A0=A1;A1=I;    // sort eigenV
		}

}
// --- compute texture average on pixel footprint
vec4 anisotropic(sampler2D T, vec2 viewSize, vec2 uv) {
	float s = float(sampleCount);
    mat2 J = mat2(dFdx(uv), dFdy(uv));       // dFdxy: pixel footprint in texture space
    vec2 A,a; float M,m,l;
    ellips(J, A,a,M,m);
    A *= M;
    l = log2( m * viewSize.y );                            // MIPmap level corresponding to min radius
    //if (M/m>s) l = log2(M/s*R.y);               // optional
    vec4 O = vec4(0);
	float halfS = s / 2.0;
    for (float i = -halfS + 0.5; i<halfS; i++)                 // sample x16 along main axis at LOD min-radius
        O += textureLod(T, uv+(i/s)*A, l);
    return O/s;
}