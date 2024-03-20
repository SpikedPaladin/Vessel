namespace Vessel {
    
    public class BoxMesh : PrimitiveMesh {
        
        public BoxMesh(Vec3 size = Vec3.from_data(1, 1, 1)) {
            float half_x = size.x * 0.5F;
            float half_y = size.y * 0.5F;
            float half_z = size.z * 0.5F;
            
            var arrays = new HashTable<ArrayType, ArrayBuffer>(null, null);
            arrays[ArrayType.ARRAY_VERTEX] = new FloatArrayBuffer.from_array({
                // 0-1-2-3 Front
                -half_x, half_y, half_z,
                half_x, half_y, half_z,
                half_x, -half_y, half_z,
                -half_x, -half_y, half_z,
                
                // 4-5-6-7 Back
                -half_x, half_y, -half_z,
                half_x, half_y, -half_z,
                half_x, -half_y, -half_z,
                -half_x, -half_y, -half_z
            });
            arrays[ArrayType.ARRAY_TEXTURE] = new FloatArrayBuffer.from_array({
                0, 1,   1, 1,   1, 0,   0, 0, // Front
                0, 0,   0, 1,   1, 1,   1, 0, // Right
                0, 0,   0, 1,   1, 1,   1, 0, // Bottom
                0, 0,   0, 1,   1, 1,   1, 0, // Left
                0, 0,   0, 1,   1, 1,   1, 0, // Top
                0, 1,   1, 1,   1, 0,   0, 0  // Back
            });
            arrays[ArrayType.ARRAY_NORMAL] = new FloatArrayBuffer.from_array({
                0, 0, 1,    0, 0, 1,    0, 0, 1,    0, 0, 1,  // Front
                1, 0, 0,    1, 0, 0,    1, 0, 0,    1, 0, 0,  // Right
                0, -1, 0,   0, -1, 0,   0, -1, 0,   0, -1, 0, // Bottom
                -1, 0, 0,   -1, 0, 0,   -1, 0, 0,   -1, 0, 0, // Left
                0, 1, 0,    0, 1, 0,    0, 1, 0,    0, 1, 0,  // Top
                0, 0, -1,   0, 0, -1,   0, 0, -1,   0, 0, -1  // Back
            });
            arrays[ArrayType.ARRAY_COLOR] = new FloatArrayBuffer.from_array({
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1, // Front
                1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1  // Back
            });
            arrays[ArrayType.ARRAY_INDEX] = new UShortArrayBuffer.from_array({
                0, 1, 2,   0, 2, 3, // Front
                2, 1, 5,   2, 5, 6, // Right
                3, 2, 6,   3, 6, 7, // Bottom
                0, 3, 7,   0, 7, 4, // Left
                1, 0, 4,   1, 4, 5, // Top
                6, 5, 4,   6, 4, 7  // Back
            });
            
            add_surface_from_arrays(arrays);
        }
    }
}