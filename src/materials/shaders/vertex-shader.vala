using GL;

namespace Vessel {
    
    public class VertexShader : Shader {
        public float time;
        
        // Shader inputs
        private GL.Uniform model_matrix_handle;
        private GL.Uniform mv_matrix_handle;
        private GL.Uniform mvp_matrix_handle;
        private GL.Uniform unif_time;
        private GL.VertexAttribute attr_vertex_position;
        private GL.VertexAttribute attr_vertex_normal;
        private GL.VertexAttribute attr_vertex_tex_coord;
        private GL.VertexAttribute attr_vertex_color;
        private GL.Uniform unif_color;
        
        public VertexShader.default() {
            this.from_uri("resource:///vessel/shaders/vertex.glsl");
        }
        
        public VertexShader.from_uri(string uri) {
            try {
                var file = File.new_for_uri(uri);
                
                uint8[] file_contents;
                file.load_contents(null, out file_contents, null);
                shader_string = (string) file_contents;
            } catch (Error e) {
                warning(@"Could not load default fragment shader $(e.message)");
            }
        }
        
        public VertexShader.from_string(string source) {
            shader_string = source;
        }
        
        public void set_vertices(uint vertex_buffer_handle, int type = GL.FLOAT, int stride = 0, int offset = 0) {
            GL.bind_buffer(GL.ARRAY_BUFFER, vertex_buffer_handle);
            
            attr_vertex_position.enable_array();
            attr_vertex_position.pointer(3, type, GL.FALSE, stride, offset);
        }
        
        public void set_texture_coords(uint texture_coord_buffer_handle, int type = GL.FLOAT, int stride = 0, int offset = 0) {
            if (attr_vertex_tex_coord < 0)
                return;
            
            GL.bind_buffer(GL.ARRAY_BUFFER, texture_coord_buffer_handle);
            attr_vertex_tex_coord.enable_array();
            attr_vertex_color.pointer(2, type, GL.FALSE, offset, stride);
        }
        
        public void set_normals(uint normal_buffer_handle, int type = GL.FLOAT, int stride = 0, int offset = 0) {
            if (attr_vertex_normal < 0)
                return;
            
            GL.bind_buffer(GL.ARRAY_BUFFER, normal_buffer_handle);
            attr_vertex_normal.enable_array();
            attr_vertex_normal.pointer(3, type, GL.FALSE, stride, offset);
        }
        
        public void set_vertex_colors(uint vertex_color_buffer_handle, int type = GL.FLOAT, int stride = 0, int offset = 0) {
            if (attr_vertex_color < 0)
                return;
            
            program.set_boolean("HaveVertexColors", true);
            GL.bind_buffer(GL.ARRAY_BUFFER, vertex_color_buffer_handle);
            attr_vertex_color.enable_array();
            attr_vertex_color.pointer(4, type, GL.FALSE, stride, offset);
        }
        
        public void set_model_matrix(Mat4 matrix) {
            program.set_mat4("model", ref matrix);
        }
        
        public void set_model_view_matrix(Mat4 matrix) {
            program.set_mat4("modelView", ref matrix);
        }
        
        public void set_model_view_projection_matrix(Mat4 matrix) {
            program.set_mat4("modelViewProjection", ref matrix);
        }
        
        public void set_color(float[] color) {
            unif_color.set_4f(color[0], color[1], color[2], color[3]);
        }
        
        public override void apply_params() {
            base.apply_params();
            
            unif_time.set_1f(time);
        }
        
        public override void set_locations(GL.Program program) {
            base.set_locations(program);
            
            model_matrix_handle = get_uniform_location("model");
            mv_matrix_handle = get_uniform_location("modelView");
            mvp_matrix_handle = get_uniform_location("modelViewProjection");
            attr_vertex_position = get_attrib_location("vertexPosition");
            attr_vertex_normal = get_attrib_location("vertexNormal");
            attr_vertex_tex_coord = get_attrib_location("vertexTexCoord");
            attr_vertex_color = get_attrib_location("vertexColor");
            unif_color = get_uniform_location("color");
        }
    }
}