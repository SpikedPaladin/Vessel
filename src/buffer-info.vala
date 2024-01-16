using GL;

namespace Vessel {
    
    public class BufferInfo : Object {
        public BufferType buffer_type;
        public Buffer buffer;
        public int target;
        public int usage;
        public uint id;
        
        public BufferInfo() {
            usage = GL_STATIC_DRAW;
        }
    }
    
    public class FloatBuffer : Buffer {
        public float[] data;
        
        public override GLvoid[] get_data() {
            return (GLvoid[]) data;
        }
        
        public override size_t size() {
            return data.length * sizeof(GLfloat);
        }
    }
    
    public class IntBuffer : Buffer {
        public int[] data;
        
        public override GLvoid[] get_data() {
            return (GLvoid[]) data;
        }
        
        public override size_t size() {
            return data.length * sizeof(GLint);
        }
    }
    
    public class ShortBuffer : Buffer {
        public ushort[] data;
        
        public override GLvoid[] get_data() {
            return (GLvoid[]) data;
        }
        
        public override size_t size() {
            return data.length * sizeof(GLushort);
        }
    }
    
    public abstract class Buffer {
        public abstract GLvoid[] get_data();
        public abstract size_t size();
    }
    
    public enum BufferType {
        FLOAT_BUFFER,
        SHORT_BUFFER,
        INT_BUFFER
    }
}