namespace Vessel {
    
    public class GridFloor : Mesh3D {
        
        construct {
            mesh = new Mesh();
            mesh.draw_mode = GL.GL_LINES;
            
            float[] vertices = {};
            ushort[] indices = {};
            float[] colors = {};
            
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
                var point = points[i];
                vertices += point.x;
                vertices += point.y;
                vertices += point.z;
                
                indices += (ushort) i;
                
                colors += 0.33F;
                colors += 0.33F;
                colors += 0.33F;
                colors += 1;
            }
            
            mesh.set_data(vertices, null, null, colors, indices, false);
        }
    }
}