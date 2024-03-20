using GL;

namespace Vessel {
    
    public abstract class Shader : Object {
        public string shader_string;
        protected GL.Program program;
        
        public virtual void apply_params() {}
        
        public virtual void set_locations(GL.Program program) {
            this.program = program;
        }
        
        public GL.Uniform get_uniform_location(string name) {
            return program.get_uniform_location(name);
        }
        
        public int get_attrib_location(string name) {
            return program.get_attrib_location(name);
        }
    }
}