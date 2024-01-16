using GL;

namespace Vessel {
    
    public abstract class Shader : Object {
        public string shader_string;
        private uint program_handle;
        
        public virtual void apply_params() {}
        
        public virtual void set_locations(uint program_handle) {
            this.program_handle = program_handle;
        }
        
        public int get_uniform_location(string name) {
            return glGetUniformLocation(program_handle, name);
        }
        
        public int get_attrib_location(string name) {
            return glGetAttribLocation(program_handle, name);
        }
    }
}