namespace Vessel {
    
    public class Viewport {
        public Node current_scene = new Node();
        public Camera current_camera = new Camera();
        public ShaderMaterial global_material = new ShaderMaterial();
        
        public Viewport() {
            GL.clear_color(0, 0, 0, 0);
        }
        
        public void render() {
            GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
            current_scene.render_to_viewport(current_camera, global_material);
            GL.flush();
            GL.finish();
        }
        
        public void resize(int width, int height) {
            //GL.viewport(0, 0, width, height);
            current_camera.set_perspective_projection(70, (float) width / (float) height, 0.01f, 100f);
        }
    }
}