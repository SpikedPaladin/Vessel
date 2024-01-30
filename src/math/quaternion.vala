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
            float c1 = Math.cosf(euler.y / 2);
            float s1 = Math.sinf(euler.y / 2);
            float c2 = Math.cosf(euler.z / 2);
            float s2 = Math.sinf(euler.z / 2);
            float c3 = Math.cosf(euler.x / 2);
            float s3 = Math.sinf(euler.x / 2);
            float c1c2 = c1*c2;
            float s1s2 = s1*s2;
            
            w = c1c2 * c3 - s1s2 * s3;
          	x = c1c2 * s3 + s1s2 * c3;
	        y = s1 * c2 * c3 + c1 * s2 * s3;
	        z = c1 * s2 * c3 - s1 * c2 * s3;
        }
        
        public Mat3 to_matrix() {
            float wx, wy, wz, xx, yy, yz, xy, xz, zz, x2, y2, z2;
            
            // calculate coefficients
            x2 = x + x; y2 = y + y;
            z2 = z + z;
            xx = x * x2; xy = x * y2; xz = x * z2;
            yy = y * y2; yz = y * z2; zz = z * z2;
            wx = w * x2; wy = w * y2; wz = w * z2;
            
            return Mat3.from_data(
                1.0F - (yy + zz), xy - wz, xz + wy,
                xy + wz, 1.0F - (xx + zz), yz - wx,
                xz - wy, yz + wx, 1.0F - (xx + yy)
            );
        }
        
        // YZX order
        public Vec3 to_euler() {
            var euler = Vec3();
            
            float sqw = w*w;
            float sqx = x*x;
            float sqy = y*y;
            float sqz = z*z;
            float unit = sqx + sqy + sqz + sqw; // if normalised is one, otherwise is correction factor
            float test = x*y + z*w;
            if (test > 0.499 * unit) { // singularity at north pole
                euler.y = 2 * Math.atan2f(x,w);
                euler.z = (float) Math.PI/2;
                euler.x = 0;
                return euler;
            }
            if (test < -0.499 * unit) { // singularity at south pole
                euler.y = -2 * Math.atan2f(x,w);
                euler.z = -((float)Math.PI)/2;
                euler.x = 0;
                return euler;
            }
            euler.y = Math.atan2f(2*y*w-2*x*z , sqx - sqy - sqz + sqw);
            euler.z = Math.asinf(2*test/unit);
            euler.x = Math.atan2f(2*x*w-2*y*z , -sqx + sqy - sqz + sqw);
            
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
        
        public string to_string() {
            return @"$w, $x, $y, $z";
        }
    }
}