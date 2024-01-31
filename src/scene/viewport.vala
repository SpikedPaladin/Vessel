using GL;

namespace Vessel {
    
    public class Viewport {
        public Node current_scene = new Node();
        public Camera current_camera = new Camera();
        public Material global_material = new Material();
        
        public Viewport() {
            glClearColor(0, 0, 0, 0);
            glEnable(GL_MULTISAMPLE);
            glEnable(GL_DEPTH_TEST);
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        }
        
        public void render() {
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            current_scene.render_to_viewport(current_camera, global_material);
        }
        
        public void resize(int width, int height) {
            glViewport(0, 0, width, height);
            current_camera.set_perspective_projection(70, (float) width / (float) height, 0.01f, 100f);
        }
    }
}