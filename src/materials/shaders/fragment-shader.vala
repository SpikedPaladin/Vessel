using GL;

namespace Vessel {
    
    public class FragmentShader : Shader {
        private int light_pos_handle;
        
        public FragmentShader.from_uri(string uri) {
            try {
                var file = File.new_for_uri(uri);
                
                uint8[] file_contents;
                file.load_contents(null, out file_contents, null);
                shader_string = (string) file_contents;
            } catch (Error e) {
                warning(@"Could not load default fragment shader $(e.message)");
            }
        }
        
        public FragmentShader.from_string(string source) {
            shader_string = source;
        }
        
        public FragmentShader.default() {
            try {
                var file = File.new_for_uri("resource:///vessel/shaders/fragment.glsl");
                
                uint8[] file_contents;
                file.load_contents(null, out file_contents, null);
                shader_string = (string) file_contents;
            } catch (Error e) {
                warning(@"Could not load default fragment shader $(e.message)");
            }
        }
        
        public void set_light_pos() {
            program.set_vec3("lightPos", Vec3.from_data(0.5F, 0.5F, 0.5F));
            //glUniform3f(light_pos_handle, 0F, 0F, 5F);
        }
        
        public override void set_locations(GL.Program program) {
            base.set_locations(program);
            
            //light_pos_handle = get_uniform_location("lightPos");
        }
    }
}