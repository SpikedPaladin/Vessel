namespace Vessel {
    
    /**
     * A 4x4 matrix.
     */
    public struct Mat4 {
        public float data[16];
        
        /**
         * Creates a new matrix, zero initialized.
         */
        public Mat4() {}
        
        /**
         * Creates a matrix whose contents are the copy of the given data.
         * Warning: the data are specified in column-first-index order, which is different from
         * the internal storage format (row-first-index).
         */
        public Mat4.from_data(
            float a11, float a12, float a13, float a14,
            float a21, float a22, float a23, float a24,
            float a31, float a32, float a33, float a34,
            float a41, float a42, float a43, float a44
        ) {
            data[0]  = a11;
            data[1]  = a21;
            data[2]  = a31;
            data[3]  = a41;
            
            data[4]  = a12;
            data[5]  = a22;
            data[6]  = a32;
            data[7]  = a42;
            
            data[8]  = a13;
            data[9]  = a23;
            data[10] = a33;
            data[11] = a43;
            
            data[12] = a14;
            data[13] = a24;
            data[14] = a34;
            data[15] = a44;
        }
        
        /**
         * Given two vectors ``a`` and ``b``, computes a matrix equal to ``a * bT``.
         */
        public Mat4.from_vec_mul(ref Vec4 a, ref Vec4 b) {
            data[0]  = a.data[0] * b.data[0];
            data[1]  = a.data[1] * b.data[0];
            data[2]  = a.data[2] * b.data[0];
            data[3]  = a.data[3] * b.data[0];
            
            data[4]  = a.data[0] * b.data[1];
            data[5]  = a.data[1] * b.data[1];
            data[6]  = a.data[2] * b.data[1];
            data[7]  = a.data[3] * b.data[1];
            
            data[8]  = a.data[0] * b.data[2];
            data[9]  = a.data[1] * b.data[2];
            data[10] = a.data[2] * b.data[2];
            data[11] = a.data[3] * b.data[2];
            
            data[12] = a.data[0] * b.data[3];
            data[13] = a.data[1] * b.data[3];
            data[14] = a.data[2] * b.data[3];
            data[15] = a.data[3] * b.data[3];
        }
        
        /**
         * Creates a matrix whose contents are the copy of the given array, assumed to have at least 16 elements.
         */
        public Mat4.from_array([CCode (array_length = false)] float[] data) {
            this.data = data;
        }
        
        /**
         * Creates an identity matrix.
         */
        public Mat4.identity() {
            data[0 * 4 + 0] = 1;
            data[1 * 4 + 1] = 1;
            data[2 * 4 + 2] = 1;
            data[3 * 4 + 3] = 1;
        }
        
        /**
         * Creates an expansion of the given 3x3 matrix into 4x4:
         * 
         * A  0
         * 
         * 0  1
         */
        public Mat4.expand(ref Mat3 mat3) {
            data[0]  = mat3.data[0];
            data[1]  = mat3.data[1];
            data[2]  = mat3.data[2];
            
            data[4]  = mat3.data[3];
            data[5]  = mat3.data[4];
            data[6]  = mat3.data[5];
            
            data[8]  = mat3.data[6];
            data[9]  = mat3.data[7];
            data[10] = mat3.data[8];
            
            data[3 * 4 + 3] = 1;
        }
        
        /**
         * Adds the given matrix, component-wise.
         */
        public void add(ref Mat4 other) {
            for (int i = 0; i < 16; i++)
                data[i] += other.data[i];
        }
        
        /**
         * Subtracts the given matrix, component-wise.
         */
        public void sub(ref Mat4 other) {
            for (int i = 0; i < 16; i++)
                data[i] -= other.data[i];
        }
        
        /**
         * Multiplies the matrix by the given scalar, component-wise.
         */
        public void mul(float factor) {
            for (int i = 0; i < 16; i++)
                data[i] *= factor;
        }
        
        /**
         * Divides the matrix by the given scalar, component-wise.
         */
        public void div(float factor) {
            for (int i = 0; i < 16; i++)
                data[i] /= factor;
        }
        
        /**
         * Multiplies the given matrix using the linear algebra definition of matrix multiplication.
         */
        public void mul_mat(ref Mat4 other) {
            float res[16]; // Zero initialized
            
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 4; j++) {
                    res[j * 4 + i] = 0;
                    
                    for (int k = 0; k < 4; k++)
                        res[j * 4 + i] += data[k * 4 + i] * other.data[j * 4 + k];
                }
            }
            
            data = res;
        }
        
        /**
         * Multiplies this matrix by the given vector and returns the result as a new vector.
         */
        public Vec4 mul_vec(ref Vec4 vec) {
            Vec4 res = Vec4(); // Zero initialized
            
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 4; j++)
                    res.data[i] += data[j * 4 + i] * vec.data[j];
            }
            
            return res;
        }
        
        /**
         * Returns a new matrix that is the transposition of this matrix.
         */
        public Mat4 transposed() {
            Mat4 res = Mat4();
            
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 4; j++)
                    res.data[i * 4 + j] = data[j * 4 + i];
            }
            
            return res;
        }
        
        /**
         * Computes the determinant of this matrix.
         */
        public float det() {
            return data[0]  * det_helper3(data[4:8], data[9:12], data[13:16])
                 - data[4]  * det_helper3(data[1:4], data[9:12], data[13:16])
                 + data[8]  * det_helper3(data[1:4], data[4:8],  data[13:16])
                 - data[12] * det_helper3(data[1:4], data[4:8],  data[9:12] );
        }
        
        /**
         * Returns a new matrix that is the inversion of this matrix.
         * @param success Set to ``false`` if the matrix cannot be inverted (its determinant is zero)
         *                and ``true`` otherwise.
         * @return The inverted matrix if the matrix was not successfully inverted,
         *         otherwise the return value is undefined.
         */
        public Mat4 inverted(out bool success) {
            float det = det();
            
            if (Math.fabsf(det) < 0.00001f) {
                success = false;
                return Mat4();
            }
            
            success = true;
            
            float inv_det = 1.0f / det;
            Mat3 transposed_submatrix = Mat3();
            Mat4 res = Mat4();
            
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 4; j++) {
                    int i1 = (i + 1) % 4;
                    int j1 = (j + 1) % 4;
                    int i2 = (i + 2) % 4;
                    int j2 = (j + 2) % 4;
                    int i3 = (i + 3) % 4;
                    int j3 = (j + 3) % 4;
                    
                    // Warning: computing determinants from transposed matrix! i becomes j and the other way round
                    transposed_submatrix.data = {
                        data[i1 * 4 + j1], data[i1 * 4 + j2], data[i1 * 4 + j3],
                        data[i2 * 4 + j1], data[i2 * 4 + j2], data[i2 * 4 + j3],
                        data[i3 * 4 + j1], data[i3 * 4 + j2], data[i3 * 4 + j3]
                    };
                    
                    res.data [j * 4 + i] = inv_det * transposed_submatrix.det();
                }
            }
            
            return res;
        }
        
        /**
         * Multiples this matrix by a matrix that specifies a translation
         * by the given vector.
         * 
         * @param translation The translation vector
         */
        public void translate(ref Vec3 translation) {
            var tmp = Mat4.from_data(
                1, 0, 0, translation.x,
                0, 1, 0, translation.y,
                0, 0, 1, translation.z,
                0, 0, 0, 1
            );
            
            mul_mat(ref tmp);
        }
        
        /**
         * Multiples this matrix by a matrix that specifies a scale operation
         * by the given factors in the x, y and z directions.
         * 
         * @param scale_factors The scale factor vector
         */
        public void scale(ref Vec3 scale_factors) {
            var tmp = Mat4.from_data(
                scale_factors.x, 0, 0, 0,
                0, scale_factors.y, 0, 0,
                0, 0, scale_factors.z, 0,
                0, 0, 0, 1
            );
            
            mul_mat(ref tmp);
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
            
            var tmp = Mat4.expand(ref tmp1);
            mul_mat(ref tmp);
        }
    }
}