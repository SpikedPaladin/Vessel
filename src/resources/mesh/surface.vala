namespace Vessel {
    
    public class Surface : Object {
        public struct Point {
            public Vec3 v;
            public Vec2 uv;
            public Vec3 n;

            public Point (Vec3 v = Vec3(), Vec2 uv = Vec2(), Vec3 n = Vec3()) {
                this.v = v;
                this.uv = uv;
                this.n = n;
            }
        }
        
        public struct Face {
            public Point p[3];

            public string to_string () {
                return @"($(p[0].v)/$(p[0].uv)/$(p[0].n), $(p[1].v)/$(p[1].uv)/$(p[1].n), $(p[2].v)/$(p[2].uv)/$(p[2].n))";
            }
        }
        
        public HashTable<ArrayType, ArrayBuffer> arrays = new HashTable<ArrayType, ArrayBuffer>(null, null);
        public int draw_mode = GL.TRIANGLES;
        public bool is_dirty = true;
        public string id { get; set; }
        public uint vao { get; set; }
        public uint ibo { get; set; }
        
        /**
         * Number of vertices in this mesh. Pass this value to {@link GL.draw_arrays}
         */
        public int size { get; set; }
        
        public StandartMaterial? material { get; set; }
        
        public Surface() {}
        
        public void render(Material? mesh_material, GL.Program program) {
            var material = mesh_material as StandartMaterial ?? this.material;
            enable_arrays(program);
            // update the material
            if (material != null) {
                //message(@"$(material)");
                program.set_boolean("EnableShading", material.enable_shading);
                program.set_vec3("AmbientColor", material.ambient_color);
                if (material.ambient_texture != null) {
                    program.set_boolean("HaveAmbientTex", true);
                    GL.active_texture(GL.TEXTURE0);
                    GL.bind_texture(GL.TEXTURE_2D, material.ambient_texture.id);
                } else {
                    program.set_boolean("HaveAmbientTex", false);
                }
                program.set_vec3("DiffuseColor", material.diffuse_color);
                if (material.diffuse_texture != null) {
                    program.set_boolean("HaveDiffuseTex", true);
                    GL.active_texture(GL.TEXTURE1);
                    GL.bind_texture(GL.TEXTURE_2D, material.diffuse_texture.id);
                } else {
                    program.set_boolean("HaveDiffuseTex", false);
                }
                program.set_vec3("SpecularColor", material.specular_color);
                program.set_float("SpecularCoeff", material.specular_exponent);
                if (material.specular_texture != null) {
                    program.set_boolean("HaveSpecularTex", true);
                    GL.active_texture(GL.TEXTURE2);
                    GL.bind_texture(GL.TEXTURE_2D, material.specular_texture.id);
                } else {
                    program.set_boolean("HaveSpecularTex", false);
                }
            } else {
                program.set_vec3("AmbientColor", Vec3.from_data(1, 1, 1));
                program.set_vec3("DiffuseColor", Vec3.from_data(0.8F, 0.8F, 0.8F));
                program.set_vec3("SpecularColor", Vec3.from_data(0.5F, 0.5F, 0.5F));
                program.set_float("SpecularCoeff", 323);
                program.set_boolean("EnableShading", true);
                program.set_boolean("HaveAmbientTex", false);
                program.set_boolean("HaveDiffuseTex", false);
                program.set_boolean("HaveSpecularTex", false);
            }
            
            program.set_boolean("HaveVertexColors", arrays.contains(ArrayType.ARRAY_COLOR));
            program.set_boolean("Selected", false);
            GL.bind_vertex_array(vao);
            if (arrays.contains(ArrayType.ARRAY_INDEX)) {
                GL.bind_buffer(GL.ELEMENT_ARRAY_BUFFER, ibo);
                GL.draw_elements(draw_mode, arrays[ArrayType.ARRAY_INDEX].count(), GL.UNSIGNED_SHORT);
            } else {
                GL.draw_arrays(draw_mode, 0, size);
            }
        }
        
        public void enable_arrays(GL.Program program) {
            if (!is_dirty)
                return;
            
            vao = GL.gen_vertex_array();
            
            bind();
            
            // set up the vertex attribute locations for this data
            GL.VertexAttribute position_attr = program.get_attrib_location("vertexPosition");
            GL.VertexAttribute texcoord_attr = program.get_attrib_location("vertexTexCoord");
            GL.VertexAttribute normal_attr = program.get_attrib_location("vertexNormal");
            GL.VertexAttribute color_attr = program.get_attrib_location("vertexColor");
            
            if (position_attr != GL.NULL_ATTRIBUTE) {
                var vertexArray = (FloatArrayBuffer) arrays[ArrayType.ARRAY_VERTEX];
                vertexArray.bind(position_attr, 3);
                size = (int) vertexArray.data.length * 3;
            }
            
            if (texcoord_attr != GL.NULL_ATTRIBUTE && arrays.contains(ArrayType.ARRAY_TEXTURE)) {
                arrays[ArrayType.ARRAY_TEXTURE].bind(texcoord_attr, 2);
            }
            
            if (normal_attr != GL.NULL_ATTRIBUTE && arrays.contains(ArrayType.ARRAY_NORMAL)) {
                arrays[ArrayType.ARRAY_NORMAL].bind(normal_attr, 3);
            }
            
            if (arrays.contains(ArrayType.ARRAY_COLOR)) {
                arrays[ArrayType.ARRAY_COLOR].bind(color_attr, 4);
            }
            
            if (arrays.contains(ArrayType.ARRAY_INDEX)) {
                ibo = arrays[ArrayType.ARRAY_INDEX].create_ibo();
            }
            
            GL.bind_vertex_array(0);
            
            is_dirty = false;
        }
        
        public void bind() {
            GL.bind_vertex_array(vao);
        }
        
        public string to_string () {
            return @"$id (ibo: $ibo)";
        }
        
        ~Surface () {
            if (vao != 0)
                GL.delete_vertex_arrays({ vao });
        }
    }
    
    public enum ArrayType {
        ARRAY_VERTEX,
        ARRAY_NORMAL,
        ARRAY_TEXTURE,
        ARRAY_COLOR,
        ARRAY_INDEX;
    }
}