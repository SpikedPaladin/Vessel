namespace Vessel {
    
    public class Mesh3D : Node3D {
        public Mesh? mesh { get; set; }
        
        public override void pre_render() {
            mesh?.validate_buffers();
        }
        
        public override void render(Camera camera, Material? scene_material = null) {
            base.render(camera, scene_material);
            mesh?.render(scene_material, model_matrix, mv_matrix, mvp_matrix);
        }
    }
}