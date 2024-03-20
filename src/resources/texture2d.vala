using GL;

namespace Vessel {
    
    public class Texture2D : Object {
        public string path { get; construct; }
        public uint id { get; private set; }
        
        /**
         * Loads a 2D texture from a resource and sets up a GL texture buffer.
         */
        public Texture2D(string path) throws Error {
            Object(path: path);
            var pixbuf = new Gdk.Pixbuf.from_resource(path);
            id = GL.gen_texture();
            GL.bind_texture(GL.TEXTURE_2D, id);
            GL.tex_image_2D(GL.TEXTURE_2D, 0, GL.RGB, pixbuf.width, pixbuf.height, 0, GL.RGB, GL.UNSIGNED_BYTE, pixbuf.get_pixels());
            GL.generate_mipmap(GL.TEXTURE_2D);
            GL.bind_texture(GL.TEXTURE_2D, 0);     // unbind
        }
    }
}