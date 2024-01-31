namespace Vessel {
    
    public class Camera : Node3D {
        protected Mat4 projection_matrix;
        protected Mat4 view_matrix;
        protected Mat4 result_matrix;
        protected Mat4 total_matrix;
        
        public Vec3 center = Vec3();
        public Vec3 up = Vec3.up();
        
        public Camera() {
            reset();
        }
        
        private void update() {
            result_matrix = projection_matrix;
            result_matrix.mul_mat(ref view_matrix);
        }
        
        public Vec3 get_view_dir() {
            return Vec3.from_data(-view_matrix.data[2], -view_matrix.data[6], -view_matrix.data[10]);
        }
        
        /**
         * Resets both the projection matrix and the view matrix.
         */
        public void reset() {
            reset_projection();
            reset_view();
        }
        
        /**
         * Resets the projection matrix, setting it to the identity matrix.
         */
        public void reset_projection() {
            projection_matrix = Mat4.identity();
            update();
        }
        
        /**
         * Resets the view matrix, setting it to the identity matrix.
         */
        public void reset_view() {
            view_matrix = Mat4.identity();
            update();
        }
        
        /**
         * Applies the camera to the next model object that will be drawn, by
         * multiplying the current projection and view matrices by the model matrix
         * passed to the function (which specifies the offset and rotation of the model
         * relative to the camera), and binds the matrix data to the specified
         * shader uniform variable.
         * 
         * @param model_matrix The model matrix
         * @param mv_matrix Result of multiplication (model * view)
         * @param mvp_matrix Result of multiplication (model * view * projection)
         */
        public void apply(ref Mat4 model_matrix, ref Mat4 mv_matrix, ref Mat4 mvp_matrix) {
            total_matrix = result_matrix;
            total_matrix.mul_mat(ref model_matrix);
            
            var mv = view_matrix;
            mv.mul_mat(ref model_matrix);
            mv_matrix.data = mv.data;
            mvp_matrix.data = total_matrix.data;
        }
        
        /**
         * Sets up a perspective projection. The previous projection matrix is ignored and overwritten.
         * 
         * Replicates the effects of the legacy ``glFrustum`` function within this camera.
         * Refer to that function for the complete description of the projection parameters.
         * 
         * @param left The coordinate of the left vertical clipping plane.
         * @param right The coordinate of the right vertical clipping plane.
         * @param bottom The coordinate of the bottom horizontal clipping plane.
         * @param top The coordinate of the top horizontal clipping plane.
         * @param near The coordinate of the near vertical clipping plane. Must be positive.
         * @param far The coordinate of the far vertical clipping plane. Must be positive.
         */
        public void set_frustum_projection(
            float left,
            float right,
            float bottom,
            float top,
            float near, float far
        ) {
            projection_matrix = Mat4.from_data(
                2f * near / (right - left), 0, (right + left) / (right - left), 0,
                0, 2f * near / (top - bottom), (top + bottom) / (top - bottom), 0,
                0, 0, -(far + near) / (far - near), -2f * far * near / (far - near),
                0, 0, -1, 0
            );
            
            update();
        }
        
        /**
         * Sets up a symmetrical perspective projection. The previous projection matrix is ignored and overwritten.
         * 
         * Replicates the effects of the legacy ``gluPerspective`` function within this camera.
         * Refer to that function for the complete description of the projection parameters.
         * 
         * @param fovy_deg The field of view angle, in degrees, in the y direction.
         * @param aspect The aspect ratio that determines the field of view in the x direction.
         *               The aspect ratio is the ratio of x (width) to y (height).
         * @param near The coordinate of the near vertical clipping plane. Must be positive.
         * @param far The coordinate of the far vertical clipping plane. Must be positive.
         */
        public void set_perspective_projection(float fovy_deg, float aspect, float near, float far) {
            var f = 1 / Math.tanf(deg_to_rad(fovy_deg / 2));
            
            projection_matrix = Mat4.from_data(
                f / aspect, 0, 0, 0,
                0, f, 0, 0,
                0, 0, -(far + near) / (far - near), -2 * far * near / (far - near),
                0, 0, -1, 0
            );
            
            update();
        }
        
        /**
         * Sets up an orthogonal projection. The previous projection matrix is ignored and overwritten.
         * 
         * Replicates the effects of the legacy ``glOrtho`` function within this camera.
         * Refer to that function for the complete description of the projection parameters.
         * 
         * @param left The coordinate of the left vertical clipping plane.
         * @param right The coordinate of the right vertical clipping plane.
         * @param bottom The coordinate of the bottom horizontal clipping plane.
         * @param top The coordinate of the top horizontal clipping plane.
         * @param near The coordinate of the near vertical clipping plane.
         * @param far The coordinate of the far vertical clipping plane.
         */
        public void set_ortho_projection(
            float left,
            float right,
            float bottom,
            float top,
            float near, float far
        ) {
            projection_matrix = Mat4.from_data(
                2f / (right - left), 0, 0, (right + left) / (right - left),
                0, 2f / (top - bottom), 0, (top + bottom) / (top - bottom),
                0, 0, -2f * far * near / (far - near), -(far + near) / (far - near),
                0, 0, 0, 1
            );
            
            update();
        }
        
        public void look_at() {
            Vec3 f = center;
            f.sub(ref _position);
            f.normalize();
            Vec3 u = up;
            u.normalize();
            Vec3 s = f.cross_product(ref u);
            s.normalize();
            u = s.cross_product(ref f);
            
            view_matrix = Mat4.from_data(
                s.x,  s.y,  s.z,  -s.dot_product(ref _position),
                u.x,  u.y,  u.z,  -u.dot_product(ref _position),
                -f.x, -f.y, -f.z, f.dot_product(ref _position),
                0, 0, 0, 1
            );
            update();
        }
    }
}
