namespace Vessel {
    
    public class Mesh : Object {
        public HashTable<string, Surface> surfaces = new HashTable<string, Surface>(str_hash, str_equal);
        public HashTable<string, StandartMaterial> materials { get; default = new HashTable<string, StandartMaterial>(str_hash, str_equal); set; }
        
        public Material? material;
        
        public string name { get; set; }
        
        public void add_surface_from_arrays(HashTable<ArrayType, ArrayBuffer> arrays, int draw_mode = GL.TRIANGLES) {
            var surface = new Surface();
            surface.arrays = arrays;
            surface.draw_mode = draw_mode;
            surfaces[@"surface#$(surfaces.length)"] = surface;
        }
        
        public void render(ShaderMaterial scene_material, Camera camera, Mat4 model_matrix, Mat4 mvp_matrix) {
            var material = material as ShaderMaterial ?? scene_material;
            
            material.use_program();
            var program = material.program;
            
            program.set_int("AmbientTex", 0);
            program.set_int("DiffuseTex", 1);
            program.set_int("SpecularTex", 2);
            // get view from camera position and rotation
            program.set_mat4("modelViewProjection", ref mvp_matrix);

            // ambient color and light position can vary throughout the scene
            program.set_vec3("AmbientLight", Vec3.from_data(0.6f, 0.6f, 0.6f));
            program.set_vec3("LightPosition", Vec3.from_data(0, 4, 0));
            program.set_vec3("CameraPosition", camera.position);
            program.set_mat4("model", ref model_matrix);
            surfaces.foreach((_, surface) => {
                surface.render(program);
            });
        }
    }
}