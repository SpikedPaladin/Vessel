namespace Vessel {
    
    public class StandartMaterial : Material {
        public string id { get; construct; }
        
        public Vec3 ambient_color { get; set; }
        public Vec3 diffuse_color { get; set; }
        public Vec3 specular_color { get; set; }
        public float specular_exponent { get; set; }
        
        public Texture2D? ambient_texture { get; set; }
        public Texture2D? diffuse_texture { get; set; }
        public Texture2D? specular_texture { get; set; }
        
        public StandartMaterial(string id) {
            Object(id: id);
        }
        
        public string to_string() {
            var sb = new StringBuilder();
            sb.append("Material ");
            sb.append(id);
            sb.append(" { ambient: ");
            if (ambient_texture != null) {
                sb.append("( ");
                sb.append(ambient_color.to_string());
                sb.append(", ");
                sb.append(ambient_texture.path);
                sb.append_c(')');
            } else {
                sb.append(ambient_color.to_string());
            }
            sb.append(", diffuse: ");
            if (diffuse_texture != null) {
                sb.append("( ");
                sb.append(diffuse_color.to_string());
                sb.append(", ");
                sb.append(diffuse_texture.path);
                sb.append_c(')');
            } else {
                sb.append(diffuse_color.to_string());
            }
            sb.append(", specular: ");
            if (specular_texture != null) {
                sb.append("( ");
                sb.append(specular_color.to_string());
                sb.append(", ");
                sb.append(specular_texture.path);
                sb.append_c(')');
            } else {
                sb.append(specular_color.to_string());
            }
            sb.append(" }");
            return sb.str;
        }
    }
}