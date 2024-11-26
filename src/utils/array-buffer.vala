namespace Vessel {
    
    public class FloatArrayBuffer : ArrayBuffer {
        public Array<float> data = new Array<float>();
        
        public FloatArrayBuffer() {}
        
        public FloatArrayBuffer.from_array(float[] array) {
            append_array(array);
        }
        
        public FloatArrayBuffer append(float element) {
            data.append_val(element);
            return this;
        }
        
        public FloatArrayBuffer append_array(float[] array) {
            data.append_vals(array, array.length);
            return this;
        }
        
        public FloatArrayBuffer append_vec2(Vec2 vec) {
            append_array(vec.data);
            return this;
        }
        
        public FloatArrayBuffer append_vec3(Vec3 vec) {
            append_array(vec.data);
            return this;
        }
        
        public FloatArrayBuffer append_vec4(Vec4 vec) {
            append_array(vec.data);
            return this;
        }
        
        public override void bind(GL.VertexAttribute attr, int size) {
            create_vbo();
            
            attr.pointer(size, GL.FLOAT);
            attr.enable_array();
        }
        
        public override uint create_vbo() {
            vbo = GL.gen_buffer();
            GL.bind_buffer(GL.ARRAY_BUFFER, vbo);
            GL.buffer_floats(GL.ARRAY_BUFFER, data.data, GL.STATIC_DRAW);
            
            return vbo;
        }
        
        public override uint create_ibo() {
            ibo = GL.gen_buffer();
            GL.bind_buffer(GL.ELEMENT_ARRAY_BUFFER, ibo);
            GL.buffer_data(GL.ELEMENT_ARRAY_BUFFER, size(), get_data(), GL.STATIC_DRAW);
            
            return ibo;
        }
        
        public override GL.GLvoid[] get_data() {
            return (GL.GLvoid[]) data.data;
        }
        
        public override size_t size() {
            return data.length * sizeof(float);
        }
        
        public override int count() {
            return (int) data.length;
        }
    }
    
    public class UShortArrayBuffer : ArrayBuffer {
        public Array<ushort> data = new Array<ushort>();
        
        public UShortArrayBuffer() {}
        
        public UShortArrayBuffer.from_array(ushort[] array) {
            append_array(array);
        }
        
        public UShortArrayBuffer append(ushort element) {
            data.append_val(element);
            return this;
        }
        
        public UShortArrayBuffer append_array(ushort[] array) {
            data.append_vals(array, array.length);
            return this;
        }
        
        public override uint create_vbo() {
            vbo = GL.gen_buffer();
            GL.bind_buffer(GL.ARRAY_BUFFER, vbo);
            GL.buffer_data(GL.ARRAY_BUFFER, size(), get_data(), GL.STATIC_DRAW);
            
            return vbo;
        }
        
        public override uint create_ibo() {
            ibo = GL.gen_buffer();
            GL.bind_buffer(GL.ELEMENT_ARRAY_BUFFER, ibo);
            GL.buffer_data(GL.ELEMENT_ARRAY_BUFFER, size(), get_data(), GL.STATIC_DRAW);
            
            return ibo;
        }
        
        public override GL.GLvoid[] get_data() {
            return (GL.GLvoid[]) data.data;
        }
        
        public override size_t size() {
            return data.length * sizeof(ushort);
        }
        
        public override int count() {
            return (int) data.length;
        }
    }
    
    public abstract class ArrayBuffer {
        public uint vbo;
        public uint ibo;
        
        public virtual void bind(GL.VertexAttribute attr, int size) {}
        public abstract uint create_vbo();
        public abstract uint create_ibo();
        public abstract GL.GLvoid[] get_data();
        public abstract size_t size();
        public abstract int count();
    }
}