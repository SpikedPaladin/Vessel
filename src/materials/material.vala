using GL;

namespace Vessel {
    
    public class Material {
        private VertexShader vertex_shader;
        private FragmentShader fragment_shader;
        
        public float time;
        
        private uint vertex_shader_handle;
        private uint fragment_shader_handle;
        
        /**
         * Indicates that one of the material properties was changed and that the shader program should
         * be re-compiled.
         */
        private bool is_dirty = true;
        /**
         * Holds a reference to the shader program
         */
        private uint program_handle = 0;
        
        public Material(VertexShader? vertex_shader = null, FragmentShader? fragment_shader = null) {
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
            vertex_shader.set_model_matrix(model_matrix.data);
        }
        
        public void set_model_view_matrix(Mat4 mv_matrix) {
            vertex_shader.set_model_view_matrix(mv_matrix.data);
        }
        
        public void set_model_view_projection_matrix(Mat4 mvp_matrix) {
            vertex_shader.set_model_view_projection_matrix(mvp_matrix.data);
        }
        
        public void set_color(Color color) {
            vertex_shader.set_color(color.data);
        }
        
        public void set_light_pos() {
            fragment_shader.set_light_pos();
        }
        
        protected void create_shaders() {
            if (vertex_shader == null) {
                // Create default vertex shader
                vertex_shader = new VertexShader.default();
            }
            
            if (fragment_shader == null) {
                // Create default fragment shader
                fragment_shader = new FragmentShader.default();
            }
            
            program_handle = create_program(vertex_shader.shader_string, fragment_shader.shader_string);
            if (program_handle == 0) {
                is_dirty = false;
                return;
            }
            
            vertex_shader.set_locations(program_handle);
            fragment_shader.set_locations(program_handle);
            
            is_dirty = false;
        }
        
        public void use_program() {
            if (is_dirty)
                create_shaders();
            
            glUseProgram(program_handle);
        }
        
        public void apply_params() {
            vertex_shader.time = time;
            vertex_shader.apply_params();
            
            fragment_shader.apply_params();
        }
        
        private uint create_program(string vertex_source, string fragment_source) {
            vertex_shader_handle = create_shader(GL_VERTEX_SHADER, vertex_source);
            if (vertex_shader_handle == 0)
                return 0;
            
            fragment_shader_handle = create_shader(GL_FRAGMENT_SHADER, fragment_source);
            if (fragment_shader_handle == 0)
                return 0;
            
            var program = glCreateProgram();
            if (program != 0) {
                glAttachShader(program, vertex_shader_handle);
                glAttachShader(program, fragment_shader_handle);
                glLinkProgram(program);
                
                int[] link_status = { GL_FALSE };
                glGetProgramiv(program, GL_LINK_STATUS, link_status);
                if (link_status[0] != GL_TRUE) {
                    warning("Could not link program!");
                    glDeleteProgram(program);
                    program = 0;
                }
            }
            
            return program;
        }
        
        private uint create_shader(uint shader_type, string source) {
            var shader = glCreateShader(shader_type);
            
            if (shader != 0) {
                glShaderSource(shader, 1, { source, null }, null);
                glCompileShader(shader);
                
                int[] compiled = { GL_FALSE };
                glGetShaderiv(shader, GL_COMPILE_STATUS, compiled);
                
                if (compiled[0] == GL_FALSE) {
                    warning(@"Could not compile $(shader_type == GL_FRAGMENT_SHADER ? "fragment" : "vertex") shader");
                }
            }
            
            return shader;
        }
        
        ~Material() {
            if (vertex_shader_handle != 0)
                glDeleteShader(vertex_shader_handle);
            
            if (fragment_shader_handle != 0)
                glDeleteShader(fragment_shader_handle);
            
            if (program_handle != 0)
                glDeleteProgram(program_handle);
        }
    }
}