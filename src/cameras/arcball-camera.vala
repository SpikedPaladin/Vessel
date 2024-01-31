namespace Vessel {
    
    public class ArcballCamera : Camera {
        public double last_mouse_pos_x;
        public double last_mouse_pos_y;
        
        private Vec3 get_right_vec() {
            return Vec3.from_data(view_matrix.data[0], view_matrix.data[4], view_matrix.data[8]);
        }
        
        public void on_rotate(double x, double y, int width, int height) {
            // Get the homogenous position of the camera and pivot point
            Vec4 pos = Vec4.from_data(position.x, position.y, position.z, 1);
            Vec4 pivot = Vec4.from_data(center.x, center.y, center.z, 1);
            
            // step 1 : Calculate the amount of rotation given the mouse movement.
            float x_angle = (float) ((last_mouse_pos_x - x) * (2 * Math.PI / width)) * 15;
            float y_angle = (float) ((last_mouse_pos_y - y) * (Math.PI / height)) * 15;
            
            // Extra step to handle the problem when the camera direction is the same as the up vector
            if (get_view_dir().y * sgn(y_angle) > 0.99f)
                y_angle = 0;
            
            // step 2: Rotate the camera around the pivot point on the first axis.
            Mat4 rotation_x = Mat4.identity();
            rotation_x.rotate(x_angle, ref up);
            pos.sub(ref pivot);
            pos = rotation_x.mul_vec(ref pos);
            pos.add(ref pivot);
            
            // step 3: Rotate the camera around the pivot point on the second axis.
            Mat4 rotation_y = Mat4.identity();
            var right_vector = get_right_vec();
            rotation_y.rotate(y_angle, ref right_vector);
            pos.sub(ref pivot);
            pos = rotation_y.mul_vec(ref pos);
            pos.add(ref pivot);
            position = Vec3.from_array(pos.data);
            
            last_mouse_pos_x = x;
            last_mouse_pos_y = y;
            look_at();
        }
        
        private float sgn(float x) {
            if (x > 0) return 1;
            else if (x < 0) return -1;
            else return 0;
        }
    }
}
