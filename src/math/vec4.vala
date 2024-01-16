namespace Vessel {
    
    /**
     * A 4-component vector.
     */
    public struct Vec4 {
        public float data[4];
        
        /**
         * Creates a new vector, zero initialized.
         */
        public Vec4() {}
        
        /**
         * Creates a vector whose contents are the copy of the given data.
         */
        public Vec4.from_data(float x, float y, float z, float w) {
            data[0] = x;
            data[1] = y;
            data[2] = z;
            data[3] = w;
        }
        
        /**
         * Creates a vector whose contents are the copy of the given array.
         */
        public Vec4.from_array([CCode (array_length = false)] float[] data) {
            this.data[0] = data[0];
            this.data[1] = data[1];
            this.data[2] = data[2];
            this.data[3] = data[3];
        }
        
        /**
         * Expands a 3x3 vector plus scalar into a 4x4 vector.
         */
        public Vec4.expand(ref Vec3 vec3, float w) {
            this.data[0] = vec3.data[0];
            this.data[1] = vec3.data[1];
            this.data[2] = vec3.data[2];
            this.data[3] = w;
        }
        
        /**
         * Adds the given vector, component-wise.
         */
        public void add(ref Vec4 other) {
            data[0] += other.data[0];
            data[1] += other.data[1];
            data[2] += other.data[2];
            data[3] += other.data[3];
        }
        
        /**
         * Subtracts the given vector, component-wise.
         */
        public void sub(ref Vec4 other) {
            data[0] -= other.data[0];
            data[1] -= other.data[1];
            data[2] -= other.data[2];
            data[3] -= other.data[3];
        }
        
        /**
         * Multiplies the given vector, component-wise.
         */
        public void mul_vec(ref Vec4 other) {
            data[0] *= other.data[0];
            data[1] *= other.data[1];
            data[2] *= other.data[2];
            data[3] *= other.data[3];
        }
        
        /**
         * Divides the given vector, component-wise.
         */
        public void div_vec(ref Vec4 other) {
            data[0] /= other.data[0];
            data[1] /= other.data[1];
            data[2] /= other.data[2];
            data[3] /= other.data[3];
        }
        
        /**
         * Computes the dot product of this vector and the other vector.
         */
        public float dot_product(ref Vec4 other) {
            return data[0] * other.data[0] + data[1] * other.data[1]
                 + data[2] * other.data[2] + data[3] * other.data[3];
        }
        
        /**
         * Multiplies the vector by the given scalar.
         */
        public void mul(float factor) {
            data[0] *= factor;
            data[1] *= factor;
            data[2] *= factor;
            data[3] *= factor;
        }
        
        /**
         * Divides the vector by the given scalar.
         */
        public void div(float factor) {
            data[0] /= factor;
            data[1] /= factor;
            data[2] /= factor;
            data[3] /= factor;
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
        
        /**
         * Convenience accessor for data[0].
         */
        public float x {
            get { return data[0]; }
        }
        
        /**
         * Convenience accessor for data[1].
         */
        public float y {
            get { return data[1]; }
        }
        
        /**
         * Convenience accessor for data[2].
         */
        public float z {
            get { return data[2]; }
        }
        
        /**
         * Convenience accessor for data[3].
         */
        public float w {
            get { return data[3]; }
        }
    }
}