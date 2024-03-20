namespace Vessel {
    
    public class WavefrontLoader {
        
        public static Mesh load(string path, string? materials_path = null, string? texture_path = null) throws Error {
            var materials = new HashTable<string, StandartMaterial> (str_hash, str_equal);
            var surfaces = new HashTable<string, Surface> (str_hash, str_equal);
            var data = new Utf8InputStream(resources_open_stream(path, ResourceLookupFlags.NONE));
            var vertexArray = new FloatArrayBuffer();
            var uvArray = new FloatArrayBuffer();
            var normalArray = new FloatArrayBuffer();
            Vec3[] vertices = {};           // all the vertices in the .obj
            Vec2[] uvs = {};                // all the UVs in the .obj
            Vec3[] normals = {};            // all the normals in the .obj
            Surface.Face[] faces = {};         // only the faces of the current surface
            string? surface_id = null;
            StandartMaterial? material = null;      // the current material
            
            while (data.next_line()) {
                if (data.skip_char('#')) {                 // comments
                    continue;
                } else if (data.skip_symbol("mtllib")) {
                    string mtllib = data.read_string();
                    foreach (var mat in load_materials(@"$(materials_path ?? Path.get_dirname(path))/$mtllib", texture_path)) {
                        materials[mat.id] = mat;
                    }
                } else if (data.skip_symbol("usemtl")) {
                    string mat_id = data.read_string();
                    if (!materials.contains(mat_id))
                        throw new IOError.INVALID_DATA("%s:line %u:%s is not a valid material ID", path, data.lineno, mat_id);
                    // save a new surface with the previous material first
                    if (faces.length > 0) {
                        var surface = new Surface() {
                            id = surface_id ?? @"surface#$(surfaces.length)",
                            material = material
                        };
                        surface.arrays[ArrayType.ARRAY_VERTEX] = vertexArray;
                        surface.arrays[ArrayType.ARRAY_TEXTURE] = uvArray;
                        surface.arrays[ArrayType.ARRAY_NORMAL] = normalArray;
                        surfaces[surface.id] = surface;
                        vertexArray = new FloatArrayBuffer();
                        uvArray = new FloatArrayBuffer();
                        normalArray = new FloatArrayBuffer();
                        // reset faces
                        faces = {};
                        material = null;
                        surface_id = null;
                    }
                    material = materials[mat_id];
                } else if (data.skip_symbol("o")) {
                    if (faces.length > 0) {
                        var surface = new Surface() {
                            id = surface_id ?? @"surface#$(surfaces.length)",
                            material = material
                        };
                        surface.arrays[ArrayType.ARRAY_VERTEX] = vertexArray;
                        surface.arrays[ArrayType.ARRAY_TEXTURE] = uvArray;
                        surface.arrays[ArrayType.ARRAY_NORMAL] = normalArray;
                        surfaces[surface.id] = surface;
                        vertexArray = new FloatArrayBuffer();
                        uvArray = new FloatArrayBuffer();
                        normalArray = new FloatArrayBuffer();
                        // reset faces
                        faces = {};
                        material = null;
                        surface_id = null;
                    }
                    surface_id = data.read_string();
                    if (surface_id.length == 0)        // object name is optional
                        surface_id = null;
                } else if (data.skip_symbol("v")) {
                    float x = data.parse_float();
                    float y = data.parse_float();
                    float z = data.parse_float();
                    try {
                        float w = data.parse_float(); // w
                        x /= w;
                        y /= w;
                        z /= w;
                    } catch (Error e) { /* ignore */ }
                    vertices += Vec3.from_data(x, y, z);
                } else if (data.skip_symbol("vt")) {       // texture coordinates
                    float u = data.parse_float();
                    float v = data.parse_float();
                    try {
                        data.parse_float(); // w
                    } catch (Error e) { /* ignore */ }
                    uvs += Vec2.from_data(u, v);
                } else if (data.skip_symbol("vn")) {       // normals
                    float x = data.parse_float();
                    float y = data.parse_float();
                    float z = data.parse_float();
                    var normal = Vec3.from_data(x, y, z);
                    normal.normalize();
                    normals += normal;
                } else if (data.skip_symbol("f")) {        // face
                    Surface.Point points[3];
                    int npoints = 0;

                    while (!data.at_end_of_line) {
                        int vi = -1, vt = -1, vn = -1;

                        vi = data.parse_int();
                        if (data.skip_char('/')) {
                            if (data.peek_char() != '/')
                                vt = data.parse_int();
                        }
                        if (data.skip_char('/'))
                            vn = data.parse_int();

                        if (vi - 1 < 0 || vi - 1 >= vertices.length)
                            throw new IOError.INVALID_DATA("%s:line %u: invalid vertex ID %d", path, data.lineno, vi - 1);
                        
                        points[npoints % 3].v = vertices[vi - 1];
                        //vertexArray.append(vertices[vi - 1]);
                        
                        if (vt != -1) {
                            if (vt - 1 < 0 || vt - 1 >= uvs.length)
                                throw new IOError.INVALID_DATA("%s:line %u: invalid texture ID %d", path, data.lineno, vt - 1);
                            
                            //uvArray.append(uvs[vt - 1]);
                            points[npoints % 3].uv = uvs[vt - 1];
                        }
                        if (vn != -1) {
                            if (vn - 1 < 0 || vn - 1 >= normals.length)
                                throw new IOError.INVALID_DATA("%s:line %u: invalid normal ID %d", path, data.lineno, vn - 1);
                            
                            //normalArray.append(normals[vn - 1]);
                            points[npoints % 3].n = normals[vn - 1];
                        }
                        
                        npoints++;
                        if (npoints >= 3) {
                            foreach (var point in points) {
                                vertexArray.append_vec3(point.v);
                                uvArray.append_vec2(point.uv);
                                normalArray.append_vec3(point.n);
                            }
                            faces += Surface.Face() { p = points };
                            points[1] = points[2];
                            npoints += 2;
                        }
                    }
                }
            }
            
            if (faces.length > 0) {
                var surface = new Surface() {
                    id = surface_id ?? @"surface#$(surfaces.length)",
                    material = material
                };
                surface.arrays[ArrayType.ARRAY_VERTEX] = vertexArray;
                surface.arrays[ArrayType.ARRAY_TEXTURE] = uvArray;
                surface.arrays[ArrayType.ARRAY_NORMAL] = normalArray;
                surfaces[surface.id] = surface;
                vertexArray = new FloatArrayBuffer();
                uvArray = new FloatArrayBuffer();
                normalArray = new FloatArrayBuffer();
                faces = {};
                material = null;
                surface_id = null;
            }
            
            return new Mesh() {
                surfaces = surfaces,
                materials = materials
            };
        }
        
        /**
         * Parse a .mtl file and return all the materials found.
         */
        public static StandartMaterial[] load_materials(string path, string? texture_path = null) throws Error {
            StandartMaterial[] mats = {};
            var data = new Utf8InputStream(resources_open_stream(path, ResourceLookupFlags.NONE));
            
            while (data.next_line()) {
                if (data.at_end_of_line || data.skip_char('#')) {  // empty line or comment
                    continue;
                } else if (data.skip_symbol("newmtl")) {
                    string mtlname = data.read_string();
                    mats += new StandartMaterial(mtlname);
                } else {
                    if (mats.length == 0)
                        throw new IOError.INVALID_DATA("line %u: material undefined here", data.lineno);
                    
                    if (data.skip_symbol("Ka")) {
                        float x = data.parse_float();
                        float y = data.parse_float();
                        float z = data.parse_float();
                        mats[mats.length - 1].ambient_color = Vec3.from_data(x, y, z);
                    } else if (data.skip_symbol("Kd")) {
                        float x = data.parse_float();
                        float y = data.parse_float();
                        float z = data.parse_float();
                        mats[mats.length - 1].diffuse_color = Vec3.from_data(x, y, z);
                    } else if (data.skip_symbol("Ks")) {
                        float x = data.parse_float();
                        float y = data.parse_float();
                        float z = data.parse_float();
                        mats[mats.length - 1].specular_color = Vec3.from_data(x, y, z);
                    } else if (data.skip_symbol("Ns")) {
                        mats[mats.length - 1].specular_exponent = data.parse_float();
                    } else if (data.skip_symbol("map_Ka")) {
                        string filename = Path.get_basename(data.read_string());
                        mats[mats.length - 1].ambient_texture = new Texture2D(@"$(texture_path ?? path)/$filename");
                    } else if (data.skip_symbol("map_Kd")) {
                        string filename = Path.get_basename(data.read_string());
                        mats[mats.length - 1].diffuse_texture = new Texture2D(@"$(texture_path ?? path)/$filename");
                    } else if (data.skip_symbol("map_Ks")) {
                        string filename = Path.get_basename(data.read_string());
                        mats[mats.length - 1].specular_texture = new Texture2D(@"$(texture_path ?? path)/$filename");
                    }
                }
            }
            
            return mats;
        }
    }
}