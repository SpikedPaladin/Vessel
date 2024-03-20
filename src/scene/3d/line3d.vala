namespace Vessel {
    
    public class Line3D : Mesh3D {
        public float line_width = 1;
        
        construct {
            mesh = new Mesh();
            
            var arrays = new HashTable<ArrayType, ArrayBuffer>(null, null);
            
            arrays[ArrayType.ARRAY_VERTEX] = new FloatArrayBuffer.from_array({ 1, 1, 1, 0, 0, 0 });
            arrays[ArrayType.ARRAY_COLOR] = new FloatArrayBuffer.from_array({ 1, 1, 1, 1, 1, 1, 1, 1 });
            arrays[ArrayType.ARRAY_INDEX] = new UShortArrayBuffer.from_array({ 0, 1 });
            
            mesh.add_surface_from_arrays(arrays, GL.LINES);
        }
        
        public override void pre_render(Camera camera, ShaderMaterial scene_material) {
            base.pre_render(camera, scene_material);
            
            //GL.glLineWidth(line_width);
        }
        
        public override void post_render(Camera camera, ShaderMaterial scene_material) {
            //GL.glLineWidth(1F);
            
            base.post_render(camera, scene_material);
        }
    }
}