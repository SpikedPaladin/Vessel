namespace Vessel {
    
    public class Cube : Object3D {
        private float size;
        
        public Cube(float size) {
            this.size = size;
            
            init();
        }
        
        public void init() {
            float halfSize = size * 0.5F;
            float[] vertices = {
                halfSize, halfSize, halfSize, 			-halfSize, halfSize, halfSize,
                -halfSize, -halfSize, halfSize,			halfSize, -halfSize, halfSize, // 0-1-2-3 front

                halfSize, halfSize, -halfSize,			 halfSize, halfSize, halfSize,
                halfSize, -halfSize, halfSize,			 halfSize, -halfSize, -halfSize, // 5-0-3-4 right

                -halfSize, halfSize, -halfSize,			halfSize, halfSize, -halfSize,
                halfSize, -halfSize, -halfSize, 		-halfSize, -halfSize, -halfSize, // 6-5-4-7 back

                -halfSize, halfSize, halfSize, 			-halfSize, halfSize, -halfSize,
                -halfSize, -halfSize, -halfSize,		-halfSize,-halfSize, halfSize, // 1-6-7-2 left

                -halfSize, halfSize, halfSize,			 halfSize, halfSize, halfSize,
                halfSize, halfSize, -halfSize,			-halfSize, halfSize, -halfSize,  // 1-0-5-6 top

                halfSize, -halfSize, halfSize, 			-halfSize, -halfSize, halfSize,
                -halfSize, -halfSize, -halfSize,		halfSize, -halfSize, -halfSize, // 3-2-7-4 bottom
            };
            
            float[] texture_coords = {
                0, 1,   1, 1,   1, 0,   0, 0, // front
                0, 0,   0, 1,   1, 1,   1, 0, // right
                0, 1,   1, 1,   1, 0,   0, 0, // back
                0, 0,   0, 1,   1, 1,   1, 0, // left
                0, 0,   0, 1,   1, 1,   1, 0, // top
                0, 0,   0, 1,   1, 1,   1, 0, // bottom
            };
            
            float[] colors = {
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1
            };
            
            float[] normals = {
                0, 0, 1,   0, 0, 1,   0, 0, 1,   0, 0, 1, // front
                1, 0, 0,   1, 0, 0,   1, 0, 0,   1, 0, 0, // right
                0, 0, -1,  0, 0, -1,  0, 0, -1,  0, 0, -1, // back
                -1, 0, 0,  -1, 0, 0,  -1, 0, 0,  -1, 0, 0, // left
                0, 1, 0,   0, 1, 0,   0, 1, 0,   0, 1, 0, // top
                0, -1, 0,  0, -1, 0,  0, -1, 0,  0, -1, 0, // bottom
            };
            
            ushort[] indices = {
                0, 1, 2, 0, 2, 3,
                4, 5, 6, 4, 6, 7,
                8, 9, 10, 8, 10, 11,
                12, 13, 14, 12, 14, 15,
                16, 17, 18, 16, 18, 19,
                20, 21, 22, 20, 22, 23
            };
            
            set_data(vertices, normals, texture_coords, colors, indices);
        }
    }
}