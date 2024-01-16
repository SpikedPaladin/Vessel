namespace Vessel {
    
    public struct Color {
        public float data[4];
        
        public Color() {}
        
        public Color.red() {
            data = { 1, 0, 0, 1 };
        }
        
        public Color.green() {
            data = { 0, 1, 0, 1 };
        }
        
        public Color.blue() {
            data = { 0, 0, 1, 1 };
        }
        
        public Color.white() {
            data = { 1, 1, 1, 1 };
        }
        
        public Color.black() {
            data = { 0, 0, 0, 1 };
        }
        
        public float r {
            get { return data[0]; }
            set { data[0] = value; }
        }
        public float g {
            get { return data[1]; }
            set { data[1] = value; }
        }
        public float b {
            get { return data[2]; }
            set { data[2] = value; }
        }
        public float a {
            get { return data[3]; }
            set { data[3] = value; }
        }
    }
}