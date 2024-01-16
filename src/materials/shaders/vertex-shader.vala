using GL;

namespace Vessel {
    
    public class VertexShader : Shader {
        public float time;
        
        // Shader inputs
        private int model_matrix_handle;
        private int mv_matrix_handle;
        private int mvp_matrix_handle;
        private int unif_time;
        private int attr_vertex_position;
        private int attr_vertex_normal;
        private int attr_vertex_tex_coord;
        private int attr_vertex_color;
        private int unif_color;
        
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
        
        public void set_vertices(uint vertex_buffer_handle, int type = GL_FLOAT, int stride = 0, int? offset = null) {
            glBindBuffer(GL_ARRAY_BUFFER, vertex_buffer_handle);
            glEnableVertexAttribArray(attr_vertex_position);
            glVertexAttribPointer(attr_vertex_position, 3, type, (GLboolean) GL_FALSE, 0, (GLvoid[]) offset);
        }
        
        public void set_texture_coords(uint texture_coord_buffer_handle, int type = GL_FLOAT, int stride = 0, int? offset = null) {
            if (attr_vertex_tex_coord < 0)
                return;
            
            glBindBuffer(GL_ARRAY_BUFFER, texture_coord_buffer_handle);
            glEnableVertexAttribArray(attr_vertex_tex_coord);
            glVertexAttribPointer(attr_vertex_tex_coord, 2, type, (GLboolean) GL_FALSE, 0, (GLvoid[]) offset);
        }
        
        public void set_normals(uint normal_buffer_handle, int type = GL_FLOAT, int stride = 0, int? offset = null) {
            if (attr_vertex_normal < 0)
                return;
            
            glBindBuffer(GL_ARRAY_BUFFER, normal_buffer_handle);
            glEnableVertexAttribArray(attr_vertex_normal);
            glVertexAttribPointer(attr_vertex_normal, 3, type, (GLboolean) GL_FALSE, 0, (GLvoid[]) offset);
        }
        
        public void set_vertex_colors(uint vertex_color_buffer_handle, int type = GL_FLOAT, int stride = 0, int? offset = null) {
            if (attr_vertex_color < 0)
                return;
            
            glBindBuffer(GL_ARRAY_BUFFER, vertex_color_buffer_handle);
            glEnableVertexAttribArray(attr_vertex_color);
            glVertexAttribPointer(attr_vertex_color, 4, type, (GLboolean) GL_FALSE, 0, (GLvoid[]) offset);
        }
        
        public void set_model_matrix(float[] matrix) {
            glUniformMatrix4fv(model_matrix_handle, 1, (GLboolean) GL_FALSE, matrix);
        }
        
        public void set_model_view_matrix(float[] matrix) {
            glUniformMatrix4fv(mv_matrix_handle, 1, (GLboolean) GL_FALSE, matrix);
        }
        
        public void set_model_view_projection_matrix(float[] matrix) {
            glUniformMatrix4fv(mvp_matrix_handle, 1, (GLboolean) GL_FALSE, matrix);
        }
        
        public void set_color(float[] color) {
            glUniform4f(unif_color, color[0], color[1], color[2], color[3]);
        }
        
        public override void apply_params() {
            base.apply_params();
            
            glUniform1f(unif_time, time);
        }
        
        public override void set_locations(uint program_handle) {
            base.set_locations(program_handle);
            
            model_matrix_handle = get_uniform_location("model");
            mv_matrix_handle = get_uniform_location("modelView");
            mvp_matrix_handle = get_uniform_location("modelViewProjection");
            attr_vertex_position = get_attrib_location("vertexPosition");
            attr_vertex_normal = get_attrib_location("vertexNormal");
            attr_vertex_tex_coord = get_attrib_location("vertexTexCoord");
            attr_vertex_color = get_attrib_location("vertexColor");
            unif_color = get_uniform_location("color");
            unif_time = get_uniform_location("time");
        }
    }
}