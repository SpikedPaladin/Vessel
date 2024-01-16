namespace Vessel {
    
    public abstract class Transformable3D : Object {
        protected Vec3 _position = Vec3();
        protected Mat4 model_matrix = Mat4.identity();
        public Vec3 position { get { return _position; } set { _position = value; } }
        public float x { get { return _position.x; } set { _position.x = value; } }
        public float y { get { return _position.y; } set { _position.y = value; } }
        public float z { get { return _position.z; } set { _position.z = value; } }
        public float rotation_x { get; set; default = 0; }
        public float rotation_y { get; set; default = 0; }
        public float rotation_z { get; set; default = 0; }
        public Vec3 scale = Vec3.from_data(1, 1, 1);
        protected Vec3 up_vec = Vec3.up();
        protected Vec3 right_vec = Vec3.right();
        protected Vec3 front_vec = Vec3.front();
        
        public bool is_model_matrix_dirty = true; // If true, the model matrix needs to be recalculated.
        
	    construct {
            notify.connect((s, p) => {
                is_model_matrix_dirty = true;
            });
	    }
	    
	    public bool on_recalculate_model_matrix(Mat4? parent_matrix) {
            if (is_model_matrix_dirty) {
                calculate_model_matrix(parent_matrix);
                is_model_matrix_dirty = false;
                
                return true;
            }
            return false;
        }
        
        private void calculate_model_matrix(Mat4? parent_matrix) {
            model_matrix = Mat4.identity();
            model_matrix.translate(ref _position);
            model_matrix.scale(ref scale);
            
            model_matrix.rotate(rotation_y, ref up_vec);
            model_matrix.rotate(rotation_x, ref right_vec);
            model_matrix.rotate(rotation_z, ref front_vec);
            
            if (parent_matrix != null) {
                parent_matrix.mul_mat(ref model_matrix);
                model_matrix = parent_matrix;
            }
        }
	}
}