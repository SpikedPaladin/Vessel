namespace Vessel {
    
    /**
     * A 2-component vector.
     */
    public struct Vec2 {
        public float data[2];
        
        /**
         * Creates a new vector, zero initialized.
         */
        public Vec2() {}
        
        /**
         * Creates a vector whose contents are the copy of the given data.
         */
        public Vec2.from_data(float x, float y) {
            data[0] = x;
            data[1] = y;
        }
        
        /**
         * Creates a vector whose contents are the copy of the given array.
         */
        public Vec2.from_array([CCode (array_length = false)] float[] data) {
            this.data[0] = data[0];
            this.data[1] = data[1];
        }
        
        /**
         * Convenience accessor for data[0].
         */
        public float x {
            get { return data[0]; }
            set { data[0] = value; }
        }
        
        /**
         * Convenience accessor for data[1].
         */
        public float y {
            get { return data[1]; }
            set { data[1] = value; }
        }
        
        public string to_string() {
            return @"<$x,$y>";
        }
    }
}