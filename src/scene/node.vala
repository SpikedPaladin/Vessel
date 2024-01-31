namespace Vessel {
    
    public class Node : Object {
        public weak Node? parent = null;
        public List<Node> children;
        public bool visible = true;
        
        construct {
            children = new List<Node>();
        }
        
        public virtual void add_child(Node child) {
            children.append(child);
            child.parent = this;
        }
        
        public virtual void pre_render() {}
        
        public virtual void render_to_viewport(Camera camera, Material? scene_material = null) {
            pre_render();
            render(camera, scene_material);
            post_render(camera, scene_material);
        }
        
        public virtual void render(Camera camera, Material? scene_material = null) {}
        
        public virtual void post_render(Camera camera, Material? scene_material = null) {
            children.foreach((child) => {
                if (child.visible)
                    on_render_child(child, camera, scene_material);
            });
        }
        
        public virtual void on_render_child(Node child, Camera camera, Material? scene_material) {
            child.render_to_viewport(camera, scene_material);
        }
    }
}