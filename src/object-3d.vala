using GL;

namespace Vessel {
    
    public abstract class Object3D : Transformable3D {
        private Geometry3D geometry;
        private Mat4 mvp_matrix;
        private Mat4 mv_matrix;
        
        private bool is_container_only = true;
        
        public List<Object3D> childs;
        public Material material;
        public Color? color;
        
        construct {
            geometry = new Geometry3D();
            material = new Material();
            mvp_matrix = Mat4.identity();
            
            childs = new List<Object3D>();
        }
        
        public void add_child(Object3D child) {
            childs.append(child);
        }
        
        protected virtual void pre_render() {
            geometry.validate_buffers();
        }
        
        public virtual void render(Camera camera, Mat4? parent_matrix = null, Material? scene_material = null) {
            var material = scene_material == null ? this.material : scene_material;
            pre_render();
            
            geometry.make_current();
            
            var model_matrix_recalculated = on_recalculate_model_matrix(parent_matrix);
            
            // Apply camera before drawing the model
            camera.apply(ref model_matrix, ref mv_matrix, ref mvp_matrix);
            
            if (!is_container_only) {
                material.use_program();
                
                material.set_texture_coords(geometry.get_texture_coord_buffer_info().id);
                material.set_normals(geometry.get_normal_buffer_info().id);
                material.set_vertex_colors(geometry.get_color_buffer_info().id);
                
                material.set_vertices(geometry.get_vertex_buffer_info().id);
                material.set_light_pos();
                
                material.apply_params();
                
                material.set_model_matrix(model_matrix);
                material.set_model_view_matrix(mv_matrix);
                material.set_model_view_projection_matrix(mvp_matrix);
                
                if (color != null)
                    material.set_color(color);
                
                glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, geometry.get_index_buffer_info().id);
                glDrawElements(GL_TRIANGLES, geometry.get_num_indices(), GL_UNSIGNED_SHORT, null);
            }
            
            childs.foreach((child) => {
                if (model_matrix_recalculated)
                    child.is_model_matrix_dirty = true;
                
                child.render(camera, model_matrix, material);
            });
        }
        
        public new void set_data(float[] vertices, float[]? normals, float[]? texture_coords, float[]? colors, ushort[] indices) {
            geometry.set_data(vertices, normals, texture_coords, colors, indices, false);
            is_container_only = false;
        }
    }
}