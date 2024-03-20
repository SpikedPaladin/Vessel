namespace Vessel {
    
    public class ShaderMaterial : Material {
        private VertexShader vertex_shader;
        private FragmentShader fragment_shader;
        
        public float time;
        
        private GL.Shader vertex_shader_handle;
        private GL.Shader fragment_shader_handle;
        
        /**
         * Indicates that one of the material properties was changed and that the shader program should
         * be re-compiled.
         */
        private bool is_dirty = true;
        /**
         * Holds a reference to the shader program
         */
        public GL.Program program = GL.NULL_PROGRAM;
        
        public ShaderMaterial(VertexShader? vertex_shader = null, FragmentShader? fragment_shader = null) {
            this.vertex_shader = vertex_shader;
            this.fragment_shader = fragment_shader;
        }
        
        public void set_vertices(uint vertex_buffer_handle) {
            vertex_shader.set_vertices(vertex_buffer_handle);
        }
        
        public void set_texture_coords(uint texture_coord_buffer_handle) {
            vertex_shader.set_texture_coords(texture_coord_buffer_handle);
        }
        
        public void set_normals(uint normal_buffer_handle) {
            vertex_shader.set_normals(normal_buffer_handle);
        }
        
        public void set_vertex_colors(uint vertex_color_buffer_handle) {
            vertex_shader.set_vertex_colors(vertex_color_buffer_handle);
        }
        
        public void set_model_matrix(Mat4 model_matrix) {
            vertex_shader.set_model_matrix(model_matrix);
        }
        
        public void set_model_view_matrix(Mat4 mv_matrix) {
            vertex_shader.set_model_view_matrix(mv_matrix);
        }
        
        public void set_model_view_projection_matrix(Mat4 mvp_matrix) {
            vertex_shader.set_model_view_projection_matrix(mvp_matrix);
        }
        
        public void set_color(Color color) {
            vertex_shader.set_color(color.data);
        }
        
        public void set_light_pos() {
            fragment_shader.set_light_pos();
        }
        
        public void create_shaders() {
            if (vertex_shader == null) {
                // Create default vertex shader
                vertex_shader = new VertexShader.default();
            }
            
            if (fragment_shader == null) {
                // Create default fragment shader
                fragment_shader = new FragmentShader.default();
            }
            
            program = create_program(vertex_shader.shader_string, fragment_shader.shader_string);
            if (program == 0) {
                is_dirty = false;
                return;
            }
            
            vertex_shader.set_locations(program);
            fragment_shader.set_locations(program);
            
            is_dirty = false;
        }
        
        public void use_program() {
            if (is_dirty)
                create_shaders();
            
            GL.use_program(program);
        }
        
        public void apply_params() {
            vertex_shader.time = time;
            vertex_shader.apply_params();
            
            fragment_shader.apply_params();
        }
        
        private uint create_program(string vertex_source, string fragment_source) {
            vertex_shader_handle = create_shader(GL.VERTEX_SHADER, vertex_source);
            if (vertex_shader_handle == 0)
                return 0;
            
            fragment_shader_handle = create_shader(GL.FRAGMENT_SHADER, fragment_source);
            if (fragment_shader_handle == 0)
                return 0;
            
            program = GL.Program();
            if (program != 0) {
                program.attach_shader(vertex_shader_handle);
                program.attach_shader(fragment_shader_handle);
                program.link();
            }
            
            return program;
        }
        
        private GL.Shader create_shader(GL.GLenum shader_type, string source) {
            var shader = GL.Shader(shader_type);
            shader.load(source);
            shader.compile();
            
            return shader;
        }
        
        ~ShaderMaterial() {
            if (vertex_shader_handle != 0)
                GL.delete_shader(vertex_shader_handle);
            
            if (fragment_shader_handle != 0)
                GL.delete_shader(fragment_shader_handle);
            
            if (program != 0)
                GL.delete_program(program);
        }
    }
}