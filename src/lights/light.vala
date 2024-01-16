namespace Vessel {
    
    public abstract class Light : Transformable3D {
        public Color color { get; set; default = Color(); }
        public float power { get; set; default = 0.5F; }
        
    }
}