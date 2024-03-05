using GL;

namespace Vessel {
    
    public class Mesh {
        public Material material;
        public int draw_mode = GL_TRIANGLES;
        
        private bool have_created_buffers;
        private uint vao_id = 0;
        
        private BufferInfo[] buffers;
        
        private const int VERTEX_BUFFER_KEY  = 0;
        private const int NORMAL_BUFFER_KEY  = 1;
        private const int TEXTURE_BUFFER_KEY = 2;
        private const int COLOR_BUFFER_KEY   = 3;
        private const int INDEX_BUFFER_KEY   = 4;
        
        public Mesh() {
            have_created_buffers = false;
            
            buffers = new BufferInfo[] {
                new BufferInfo() {
                    buffer_type = BufferType.FLOAT_BUFFER,
                    target = GL_ARRAY_BUFFER
                },
                new BufferInfo() {
                    buffer_type = BufferType.FLOAT_BUFFER,
                    target = GL_ARRAY_BUFFER
                },
                new BufferInfo() {
                    buffer_type = BufferType.FLOAT_BUFFER,
                    target = GL_ARRAY_BUFFER
                },
                new BufferInfo() {
                    buffer_type = BufferType.FLOAT_BUFFER,
                    target = GL_ARRAY_BUFFER
                },
                new BufferInfo() {
                    buffer_type = BufferType.SHORT_BUFFER,
                    target = GL_ELEMENT_ARRAY_BUFFER
                }
            };
        }
        
        public void render(Material? scene_material, Mat4 model_matrix, Mat4 mv_matrix, Mat4 mvp_matrix) {
            var material = this.material == null ? scene_material : this.material;
            make_current();
            
            material.use_program();
            
            material.set_texture_coords(get_texture_coord_buffer_info().id);
            material.set_normals(get_normal_buffer_info().id);
            material.set_vertex_colors(get_color_buffer_info().id);
            
            material.set_vertices(get_vertex_buffer_info().id);
            material.set_light_pos();
            
            material.apply_params();
            
            material.set_model_matrix(model_matrix);
            material.set_model_view_matrix(mv_matrix);
            material.set_model_view_projection_matrix(mvp_matrix);
            
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, get_index_buffer_info().id);
            glDrawElements(draw_mode, get_num_indices(), GL_UNSIGNED_SHORT, null);
        }
        
        public void set_data(
            float[] vertices,
            float[]? normals,
            float[]? texture_coords,
            float[]? colors,
            ushort[] indices,
            bool create_vbos
        ) {
            buffers[VERTEX_BUFFER_KEY].buffer = new FloatBuffer() { data = vertices };
            buffers[INDEX_BUFFER_KEY].buffer = new ShortBuffer() { data = indices };
            
            if (normals != null)
                buffers[NORMAL_BUFFER_KEY].buffer = new FloatBuffer() { data = normals };
            
            if (texture_coords != null)
                buffers[TEXTURE_BUFFER_KEY].buffer = new FloatBuffer() { data = texture_coords };
            
            if (colors != null)
                buffers[COLOR_BUFFER_KEY].buffer = new FloatBuffer() { data = colors };
            
            if (create_vbos)
                create_buffers();
        }
        
        private void create_buffers() {
            if (vao_id == 0) {
                uint id_array[1];
                glGenVertexArrays(1, id_array);
                vao_id = id_array[0];
            }
            
            make_current();
            
            foreach (var info in buffers) {
                uint id_array[1];
                glGenBuffers(1, id_array);
                var id = id_array[0];
                
                if (info.buffer != null) {
                    glBindBuffer(info.target, id);
                    glBufferData(info.target, info.buffer.size(), info.buffer.get_data(), info.usage);
                    glBindBuffer(info.target, 0);
                }
                
                info.id = id;
            }
            
            have_created_buffers = true;
        }
        
        public BufferInfo get_vertex_buffer_info() {
            return buffers[VERTEX_BUFFER_KEY];
        }
        
        public BufferInfo get_texture_coord_buffer_info() {
            return buffers[TEXTURE_BUFFER_KEY];
        }
        
        public BufferInfo get_normal_buffer_info() {
            return buffers[NORMAL_BUFFER_KEY];
        }
        
        public BufferInfo get_color_buffer_info() {
            return buffers[COLOR_BUFFER_KEY];
        }
        
        public BufferInfo get_index_buffer_info() {
            return buffers[INDEX_BUFFER_KEY];
        }
        
        public int get_num_indices() {
            return ((ShortBuffer) buffers[INDEX_BUFFER_KEY].buffer).data.length;
        }
        
        public void make_current() {
            glBindVertexArray(vao_id);
        }
        
        public void validate_buffers() {
            if (!have_created_buffers)
                create_buffers();
        }
        
        ~Mesh() {
            if (vao_id != 0) {
                uint[] id_array = { vao_id };
                glDeleteVertexArrays(1, id_array);
            }
        }
    }
}