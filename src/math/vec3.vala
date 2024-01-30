namespace Vessel {
    
    /**
     * A 3-component vector.
     */
    public struct Vec3 {
        public float data[3];
        
        /**
         * Creates a new vector, zero initialized.
         */
        public Vec3() {}
        
        /**
         * Creates a vector whose contents are the copy of the given data.
         */
        public Vec3.from_data(float x, float y, float z) {
            data[0] = x;
            data[1] = y;
            data[2] = z;
        }
        
        /**
         * Creates a vector whose contents are the copy of the given array.
         */
        public Vec3.from_array([CCode (array_length = false)] float[] data) {
            this.data[0] = data[0];
            this.data[1] = data[1];
            this.data[2] = data[2];
        }
        
        public float @get(int index) {
            return data[index];
        }
        
        /**
         * Adds the given vector, component-wise.
         */
        public void add(ref Vec3 other) {
            data[0] += other.data[0];
            data[1] += other.data[1];
            data[2] += other.data[2];
        }
        
        /**
         * Subtracts the given vector, component-wise.
         */
        public void sub(ref Vec3 other) {
            data[0] -= other.data[0];
            data[1] -= other.data[1];
            data[2] -= other.data[2];
        }
        
        /**
         * Multiplies the given vector, component-wise.
         */
        public void mul_vec(ref Vec3 other) {
            data[0] *= other.data[0];
            data[1] *= other.data[1];
            data[2] *= other.data[2];
        }
        
        /**
         * Divides the given vector, component-wise.
         */
        public void div_vec(ref Vec3 other) {
            data[0] /= other.data[0];
            data[1] /= other.data[1];
            data[2] /= other.data[2];
        }
        
        /**
         * Computes the dot product of this vector and the other vector.
         */
        public float dot_product(ref Vec3 other) {
            return data[0] * other.data[0] + data[1] * other.data[1] + data[2] * other.data[2];
        }
        
        /**
         * Computes the cross product of this vector and the other vector.
         */
        public Vec3 cross_product(ref Vec3 other) {
            return Vec3.from_data(
                data[1] * other.data[2] - data[2] * other.data[1],
                data[2] * other.data[0] - data[0] * other.data[2],
                data[0] * other.data[1] - data[1] * other.data[0]
            );
        }
        
        /**
         * Multiplies the vector by the given scalar.
         */
        public void mul(float factor) {
            data[0] *= factor;
            data[1] *= factor;
            data[2] *= factor;
        }
        
        /**
         * Divides the vector by the given scalar.
         */
        public void div(float factor) {
            data[0] /= factor;
            data[1] /= factor;
            data[2] /= factor;
        }
        
        /**
         * Computes the norm of this vector.
         */
        public float norm() {
            return Math.sqrtf(dot_product(ref this));
        }
        
        /**
         * Normalizes this vector, dividing it by its norm.
         * If the norm is zero, the result is undefined.
        */
        public void normalize() {
            div(norm());
        }
        
        public bool contains(Vec3 other) {
            return other.x == x && other.y == y && other.z == z;
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
        
        /**
         * Convenience accessor for data[2].
         */
        public float z {
            get { return data[2]; }
            set { data[2] = value; }
        }
        
        public string to_string() {
            return @"[$(data[0]), $(data[1]), $(data[2])]";
        }
        
        public Vec3.up() {
            data = { 0, 1, 0 };
        }
        
        public Vec3.front() {
            data = { 0, 0, 1 };
        }
        
        public Vec3.right() {
            data = { 1, 0, 0 };
        }
    }
}