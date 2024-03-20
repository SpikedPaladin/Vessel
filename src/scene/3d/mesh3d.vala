namespace Vessel {
    
    public class Mesh3D : Node3D {
        public Mesh? mesh { get; set; }
        
        public override void render(Camera camera, ShaderMaterial scene_material) {
            base.render(camera, scene_material);
            
            mesh?.render(scene_material, camera, model_matrix, mvp_matrix);
        }
    }
}