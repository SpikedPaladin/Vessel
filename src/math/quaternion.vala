namespace Vessel {
    
    public struct Quaternion {
        public float x;
        public float y;
        public float z;
        public float w;
        
        public Quaternion() {}
        
        public Quaternion.identity() {
            w = 1;
        }
        
        public Quaternion.from_axis(Vec3 axis, float angle) {
            w = Math.cosf(angle / 2.0F);
            float c = Math.sinf(angle / 2.0F);
            x = c * axis.x;
            y = c * axis.y;
            z = c * axis.z;
        }
        
        public Quaternion.from_x_rotation(float angle) {
            this.from_axis(Vec3.right(), angle);
        }
        
        public Quaternion.from_y_rotation(float angle) {
            this.from_axis(Vec3.up(), angle);
        }
        
        public Quaternion.from_z_rotation(float angle) {
            this.from_axis(Vec3.front(), angle);
        }
        
        public Quaternion.from_euler(Vec3 euler) {
            float cy = Math.cosf(euler.x * 0.5F);
            float sy = Math.sinf(euler.x * 0.5F);
            float cr = Math.cosf(euler.z * 0.5F);
            float sr = Math.sinf(euler.z * 0.5F);
            float cp = Math.cosf(euler.y * 0.5F);
            float sp = Math.sinf(euler.y * 0.5F);

            w = cy * cr * cp + sy * sr * sp;
            x = cy * sr * cp - sy * cr * sp;
            y = cy * cr * sp + sy * sr * cp;
            z = sy * cr * cp - cy * sr * sp;
        }
        
        public Vec3 to_euler() {
            var euler = Vec3();
            // Roll (x-axis rotation)
            float sinr_cosp = +2F * (w * x + y * z);
            float cosr_cosp = +1F - 2F * (x * x + y * y);
            euler.x = Math.atan2f(sinr_cosp, cosr_cosp);

            // Pitch (y-axis rotation)
            float sinp = +2.0F * (w * y - z * x);
            if (Math.fabsf(sinp) >= 1)
                euler.y = Math.copysignf((float) Math.PI / 2F, sinp); // use 90 degrees if out of range
            else
                euler.y = Math.asinf(sinp);

            // Yaw (z-axis rotation)
            float siny_cosp = +2F * (w * z + x * y);
            float cosy_cosp = +1F - 2F * (y * y + z * z);
            euler.z = Math.atan2f(siny_cosp, cosy_cosp);
            return euler;
        }
        
        public float norm() {
            return Math.sqrtf(w*w + x*x + y*y + z*z);
        }
        
        public void normalize(Quaternion other) {
            float len = other.norm();
            
            w = other.w / len;
            x = other.x / len;
            y = other.y / len;
            z = other.z / len;
        }
        
        public void mul(Quaternion other) {
            Quaternion result = Quaternion();
            
            /*
            Formula from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/arithmetic/index.htm
                     a*e - b*f - c*g - d*h
                + i (b*e + a*f + c*h- d*g)
                + j (a*g - b*h + c*e + d*f)
                + k (a*h + b*g - c*f + d*e)
            */
            result.w = other.w * w - other.x * x - other.y * y - other.z * z;
            result.x = other.x * w + other.w * x + other.y * z - other.z * y;
            result.y = other.w * y - other.x * z + other.y * w + other.z * x;
            result.z = other.w * z + other.x * y - other.y * x + other.z * w;
            
            this.w = result.w;
            this.x = result.x;
            this.y = result.y;
            this.z = result.z;
        }
        
        public float to_axis_angle(ref Vec3 axis) {
            float angle = 2F * Math.acosf(w);
            float divider = Math.sqrtf(1F - w * w);
            
            if (divider != 0.0) {
                // Calculate the axis
                axis.x = x / divider;
                axis.y = y / divider;
                axis.z = z / divider;
            } else {
                // Arbitrary normalized axis
                axis.x = 1;
                axis.y = 0;
                axis.z = 0;
            }
            return angle;
        }
        
        
    }
}