/*
	ガウシアンフィルタとSobel シェーダー2 by あるる（きのもと 結衣）
	Sobel with Gaussian filter Shader2 by @arlez80

	MIT License
*/

shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform float alpha : hint_range( 0.0, 1.0 ) = 1.0;

vec3 gaussian5x5( sampler2D tex, vec2 uv, vec2 pix_size )
{
	vec3 p = vec3( 0.0, 0.0, 0.0 );
	float coef[25] = { 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625, 0.015625, 0.0625, 0.09375, 0.0625, 0.015625, 0.0234375, 0.09375, 0.140625, 0.09375, 0.0234375, 0.015625, 0.0625, 0.09375, 0.0625, 0.015625, 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625 };

	for( int y=-2; y<=2; y++ ) {
		for( int x=-2; x<=2; x ++ ) {
			p += ( texture( tex, uv + vec2( float( x ), float( y ) ) * pix_size ).rgb ) * coef[(y+2)*5 + (x+2)];
		}
	}

	return p;
}

void fragment( )
{
	vec3 pix[9];	// 3 x 3

	// ガウシアンフィルタ
	for( int y=0; y<3; y ++ ) {
		for( int x=0; x<3; x ++ ) {
			pix[y*3+x] = gaussian5x5( SCREEN_TEXTURE, SCREEN_UV + vec2( float( x-1 ), float( y-1 ) ) * SCREEN_PIXEL_SIZE, SCREEN_PIXEL_SIZE );
		}
	}

	// Sobelフィルタ
	vec3 sobel_src_x = (
		pix[0] * -1.0
	+	pix[3] * -2.0
	+	pix[6] * -1.0
	+	pix[2] * 1.0
	+	pix[5] * 2.0
	+	pix[8] * 1.0
	);
	vec3 sobel_src_y = (
		pix[0] * -1.0
	+	pix[1] * -2.0
	+	pix[2] * -1.0
	+	pix[6] * 1.0
	+	pix[7] * 2.0
	+	pix[8] * 1.0
	);
	vec3 sobel = sqrt( sobel_src_x * sobel_src_x + sobel_src_y * sobel_src_y );

	COLOR = vec4( sobel, alpha );
}
