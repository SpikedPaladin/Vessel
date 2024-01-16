namespace Vessel {
    
    public class Renderer {
        public Scene current_scene;
        
        public Renderer() {
            current_scene = new Scene();
        }
        
        public void render() {
            current_scene.render();
        }
        
        public void resize(int width, int height) {
            current_scene.resize(width, height);
        }
    }
}