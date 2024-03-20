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
        
        public virtual void pre_render(Camera camera, ShaderMaterial scene_material) {}
        
        public virtual void render_to_viewport(Camera camera, ShaderMaterial scene_material) {
            pre_render(camera, scene_material);
            render(camera, scene_material);
            post_render(camera, scene_material);
        }
        
        public virtual void render(Camera camera, ShaderMaterial scene_material) {}
        
        public virtual void post_render(Camera camera, ShaderMaterial scene_material) {
            children.foreach((child) => {
                if (child.visible)
                    on_render_child(child, camera, scene_material);
            });
        }
        
        public virtual void on_render_child(Node child, Camera camera, ShaderMaterial scene_material) {
            child.render_to_viewport(camera, scene_material);
        }
    }
}