using GL;

namespace Vessel {
    
    public class Scene {
        public Camera camera;
        
        public int render_mode = -1;
        public List<Object3D> childs;
        
        public Scene() {
            childs = new List<Object3D>();
            glEnable(GL_DEBUG_OUTPUT);
            glDebugMessageCallback(on_gl_error);
            
            glClearColor(71.0f / 255, 95.0f / 255, 121.0f / 255, 1);
            glEnable(GL_MULTISAMPLE);
            glEnable(GL_DEPTH_TEST);
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
            camera = new Camera();
        }
        
        private void on_gl_error(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, string message) {
            stderr.printf("GL CALLBACK: %s type = 0x%x, severity = 0x%x, message = %s\n",
                ( type == GL_DEBUG_TYPE_ERROR ? "** GL ERROR **" : "" ),
                type, severity, message );
        }
        
        public void resize(int width, int height) {
            glViewport(0, 0, width, height);
            camera.set_perspective_projection(70, (float) width / (float) height, 0.01f, 100f);
        }
        
        public void add_child(Object3D child) {
            childs.append(child);
        }
        
        public void render() {
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            
            update_render_mode();
            
            childs.foreach((child) => {
                child.render(camera);
            });
        }
        
        private void update_render_mode() {
            switch (render_mode) {
                case 0:
                    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
                    glEnable(GL_DEPTH_TEST);
                    glEnable(GL_CULL_FACE);
                    render_mode = -1;
                    break;
                case 1:
                    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
                    glDisable(GL_DEPTH_TEST);
                    glDisable(GL_CULL_FACE);
                    render_mode = -1;
                    break;
                case 2:
                    glPolygonMode(GL_FRONT_AND_BACK, GL_POINT);
                    glDisable(GL_DEPTH_TEST);
                    glDisable(GL_CULL_FACE);
                    render_mode = -1;
                    break;
            }
        }
    }
}