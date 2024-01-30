namespace Vessel {
    
    /**
     * A 3x3 matrix.
     */
    public struct Mat3 {
        public float data[9];
        
        /**
         * Creates a new matrix, zero initialized.
         */
        public Mat3() {}
        
        /**
         * Creates a matrix whose contents are the copy of the given data.
         * Warning: the data are specified in column-first-index order, which is different from
         * the internal storage format (row-first-index).
         */
        public Mat3.from_data(
            float a11, float a12, float a13,
            float a21, float a22, float a23,
            float a31, float a32, float a33
        ) {
            data[0] = a11;
            data[1] = a21;
            data[2] = a31;
            
            data[3] = a12;
            data[4] = a22;
            data[5] = a32;
            
            data[6] = a13;
            data[7] = a23;
            data[8] = a33;
        }
        
        /**
         * Given two vectors ``a`` and ``b``, computes a matrix equal to ``a * bT``.
         */
        public Mat3.from_vec_mul(ref Vec3 a, ref Vec3 b) {
            data[0] = a.data[0] * b.data[0];
            data[1] = a.data[1] * b.data[0];
            data[2] = a.data[2] * b.data[0];
            
            data[3] = a.data[0] * b.data[1];
            data[4] = a.data[1] * b.data[1];
            data[5] = a.data[2] * b.data[1];
            
            data[6] = a.data[0] * b.data[2];
            data[7] = a.data[1] * b.data[2];
            data[8] = a.data[2] * b.data[2];
        }
        
        /**
         * Creates a matrix whose contents are the copy of the given array, assumed to have at least 9 elements.
         */
        public Mat3.from_array([CCode (array_length = false)] float[] data) {
            this.data = data;
        }
        
        /**
         * Creates an identity matrix.
         */
        public Mat3.identity() {
            data[0 * 3 + 0] = 1;
            data[1 * 3 + 1] = 1;
            data[2 * 3 + 2] = 1;
        }
        
        public Vec3 @get(int index) {
            return Vec3.from_data(data[index], data[index + 1], data[index + 2]);
        }
        
        /**
         * Adds the given matrix, component-wise.
         */
        public void add(ref Mat3 other) {
            for (int i = 0; i < 9; i++)
                data[i] += other.data[i];
        }
        
        /**
         * Subtracts the given matrix, component-wise.
         */
        public void sub(ref Mat3 other) {
            for (int i = 0; i < 9; i++)
                data[i] -= other.data[i];
        }
        
        /**
         * Multiplies the matrix by the given scalar, component-wise.
         */
        public void mul(float factor) {
            for (int i = 0; i < 9; i++)
                data[i] *= factor;
        }
        
        /**
         * Divides the matrix by the given scalar, component-wise.
         */
        public void div(float factor) {
            for (int i = 0; i < 9; i++)
                data[i] /= factor;
        }
        
        /**
         * Multiplies the given matrix using the linear algebra definition of matrix multiplication.
         */
        public void mul_mat(ref Mat3 other) {
            float res[9]; // Zero initialized
            
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    res[j * 3 + i] = 0;
                    
                    for (int k = 0; k < 3; k++)
                        res[j * 3 + i] += data[k * 3 + i] * other.data[j * 3 + k];
                }
            }
            
            data = res;
        }
        
        /**
         * Multiplies this matrix by the given vector and returns the result as a new vector.
         */
        public Vec3 mul_vec(ref Vec3 vec) {
            Vec3 res = Vec3(); // Zero initialized
            
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++)
                    res.data[i] += data[j * 3 + i] * vec.data[j];
            }
            
            return res;
        }
        
        /**
         * Returns a new matrix that is the transposition of this matrix.
         */
        public Mat3 transposed() {
            Mat3 res = Mat3();
            
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++)
                    res.data[i * 3 + j] = data[j * 3 + i];
            }
            
            return res;
        }
        
        /**
         * Computes the determinant of this matrix.
         */
        public float det() {
            return det_helper3(data[0:3], data[3:6], data[6:9]);
        }
        
        /**
         * Returns a new matrix that is the inversion of this matrix.
         * @param success Set to ``false`` if the matrix cannot be inverted (its determinant is zero)
         *                and ``true`` otherwise.
         * @return The inverted matrix if the matrix was not successfully inverted,
         *         otherwise the return value is undefined.
         */
        public Mat3 inverted(out bool success) {
            float det = det();
            
            if (Math.fabsf(det) < 0.00001f) {
                success = false;
                return Mat3();
            }
            
            success = true;
            
            float inv_det = 1.0f / det;
            Mat3 res = Mat3();
            
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    int i1 = (i + 1) % 3;
                    int j1 = (j + 1) % 3;
                    int i2 = (i + 2) % 3;
                    int j2 = (j + 2) % 3;
                    // Warning: computing determinants from transposed matrix! i becomes j and the other way round
                    res.data [j * 3 + i] = inv_det *
                        (data[i1 * 3 + j1] * data[i2 * 3 + j2] - data[i2 * 3 + j1] * data[i1 * 3 + j2]);
                }
            }
            
            return res;
        }
        
        /**
         * Multiples this matrix by a matrix that specifies a rotation around
         * the given axis by the given angle.
         * 
         * Be careful with these rotations. Unlike quaternion-based transformations,
         * they may incur gimbal lock.
         * 
         * @param angle_deg The rotation angle in degrees
         * @param axis The rotation axis
         */
        public void rotate(float angle_deg, ref Vec3 axis) {
            Vec3 axis_normalized = axis;
            axis_normalized.normalize();
            
            float angle_rad = deg_to_rad(angle_deg);
            
            // M = uuT + (cos a) (1 - uuT) + (sin a) S
            Mat3 tmp1 = Mat3.from_vec_mul(ref axis_normalized, ref axis_normalized);
            Mat3 tmp2 = Mat3.identity();
            tmp2.sub(ref tmp1);
            tmp2.mul(Math.cosf(angle_rad));
            tmp1.add(ref tmp2);
            
            Mat3 s = Mat3.from_data(
                0, -axis_normalized.z, axis_normalized.y,
                axis_normalized.z, 0, -axis_normalized.x,
                -axis_normalized.y, axis_normalized.x, 0
            );
            s.mul(Math.sinf(angle_rad));
            tmp1.add(ref s);
            
            mul_mat(ref tmp1);
        }
        
        public string to_string() {
            var str = "";
            
            for (int i = 0; i < 3; i++) {
                str += @"$(this[i])\n";
            }
            return str;
        }
    }
}