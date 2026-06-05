#version 320 es
precision mediump float;

// Inputs from Hyprland Vertex Shader
in vec2 v_texcoord;
uniform sampler2D tex;

// Custom Output Fragment Color
out vec4 fragColor;

void main() {
    vec2 uv = v_texcoord;
    
    // 1. CRT Distortion (Subtle screen curvature)
    vec2 dc = abs(0.5 - uv);
    uv.x += (uv.x - 0.5) * (dc.y * dc.y) * 0.04;
    uv.y += (uv.y - 0.5) * (dc.x * dc.x) * 0.04;
    
    // Crop out pixels pushed outside visible frame bounds
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // 2. Sample texture using standard ES 3.2 texture function
    vec4 color = texture(tex, uv);
    
    // 3. Apply horizontal scanlines
    float scanline = sin(uv.y * 1200.0) * 0.08;
    color.rgb -= scanline;
    
    // 4. Vignette shading (Dark edges)
    float vignette = uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    vignette = clamp(pow(16.0 * vignette, 0.25), 0.0, 1.0);
    color.rgb *= vignette;

    // Output final color payload
    fragColor = color;
}
