namespace Vessel {
    
    public class GridFloor : Mesh3D {
        
        construct {
            mesh = new Mesh() {
                material = new StandartMaterial("grid_floor") {
                    enable_shading = false
                }
            };
            
            var vertices = new FloatArrayBuffer();
            var colors = new FloatArrayBuffer();
            var indices = new UShortArrayBuffer();
            
            var lines = 20F;
            var size = 10F;
            var half_size = size / 2F;
            var spacing = size / lines;
            
            Vec3[] points = {};
            
            for (float x = -half_size; x <= half_size; x += spacing) {
                points += Vec3.from_data(x, 0, -half_size);
                points += Vec3.from_data(x, 0, half_size);
            }
            
            for (float z = -half_size; z <= half_size; z += spacing) {
                points += Vec3.from_data(-half_size, 0, z);
                points += Vec3.from_data(half_size, 0, z);
            }
            
            for (int i = 0; i < points.length; i++) {
                vertices.append_vec3(points[i]);
                indices.append((ushort) i);
                colors.append_vec4(Vec4.from_data(0.33F, 0.33F, 0.33F, 1F));
            }
            
            var arrays = new HashTable<ArrayType, ArrayBuffer>(null, null);
            
            arrays[ArrayType.ARRAY_VERTEX] = vertices;
            arrays[ArrayType.ARRAY_COLOR] = colors;
            arrays[ArrayType.ARRAY_INDEX] = indices;
            
            mesh.add_surface_from_arrays(arrays, GL.LINES);
        }
    }
}