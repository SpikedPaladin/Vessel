using Vessel;

public class ColoredCube : Object3D {
    public Vec3 initial_position = Vec3();
    public Vec3 prev_position = Vec3();
    public new Vec3 up_vec = Vec3.up();
    public new Vec3 front_vec = Vec3.front();
    public new Vec3 right_vec = Vec3.right();
    private bool initialized = false;
    
    public float[] vertices = {
        0.5F, 0.5F, 0.5F, 			-0.5F, 0.5F, 0.5F,
        -0.5F, -0.5F, 0.5F,			0.5F, -0.5F, 0.5F, // 0-1-2-3 front

        0.5F, 0.5F, -0.5F,			 0.5F, 0.5F, 0.5F,
        0.5F, -0.5F, 0.5F,			 0.5F, -0.5F, -0.5F, // 5-0-3-4 right

        -0.5F, 0.5F, -0.5F,			0.5F, 0.5F, -0.5F,
        0.5F, -0.5F, -0.5F, 		-0.5F, -0.5F, -0.5F, // 6-5-4-7 back

        -0.5F, 0.5F, 0.5F, 			-0.5F, 0.5F, -0.5F,
        -0.5F, -0.5F, -0.5F,		-0.5F,-0.5F, 0.5F, // 1-6-7-2 left

        -0.5F, 0.5F, 0.5F,			 0.5F, 0.5F, 0.5F,
        0.5F, 0.5F, -0.5F,			-0.5F, 0.5F, -0.5F,  // 1-0-5-6 top

        0.5F, -0.5F, 0.5F, 			-0.5F, -0.5F, 0.5F,
        -0.5F, -0.5F, -0.5F,		0.5F, -0.5F, -0.5F, // 3-2-7-4 bottom
    };
    
    float[] colors = {
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,
        0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1,   0, 0, 0, 1
    };
    
    ushort[] indices = {
        0, 1, 2, 0, 2, 3,
        4, 5, 6, 4, 6, 7,
        8, 9, 10, 8, 10, 11,
        12, 13, 14, 12, 14, 15,
        16, 17, 18, 16, 18, 19,
        20, 21, 22, 20, 22, 23
    };
    
    public void rotate_x(float amount) {
        if (rotation_y == -180) {
            rotation_x -= amount;
        } else if (rotation_y == -90)
            rotation_z -= amount;
        else
            rotation_x += amount;
    }
    
    public void rotate_z(float amount) {
        
    }
    
    public Vec3 get_front_vec() {
        if (rotation_y == 90 || rotation_y == -270)
            return Vec3.from_data(1, 0, 0);
        if (rotation_y == -90 || rotation_y == 270)
            return Vec3.from_data(-1, 0, 0);
        if (Math.fabs(rotation_x) == 180)
            return Vec3.from_data(0, 0, -1);
        
        return Vec3.from_data(0, 0, 1);
    }
    
    public Vec3 get_right_vec() {
        if (rotation_y == 90 || rotation_y == -270)
            return Vec3.from_data(0, 0, -1);
        if (rotation_y == -90 || rotation_y == 270)
            return Vec3.from_data(0, 0, 1);
        if (Math.fabs(rotation_x) == 180)
            return Vec3.from_data(-1, 0, 0);
        
        return Vec3.from_data(1, 0, 0);
    }
    
    public override void pre_render() {
        if (!initialized) {
            set_data(vertices, null, null, colors, indices);
            initial_position = prev_position = position;
            
            initialized = true;
        }
        
        base.pre_render();
    }
    
    public void push_position() {
        prev_position = position;
        if (rotation_y == rotation_x == -90 && rotation_z == 0) {
            rotation_y = 0;
            rotation_z = -90;
        }
        if (rotation_x == -180 && rotation_y == rotation_z == -90) {
            rotation_x = 0;
            rotation_y = 90;
            rotation_z = 90;
        }
        front_vec = get_front_vec();
        right_vec = get_right_vec();
    }
    
    public void set_face_color(Face face, float[] color) {
        var new_colors = colors.copy();
        var color_index = 0;
        for (int i = face.start_index(); i < face.end_index(); i++) {
            if (color_index != 3) {
                new_colors[i] = color[color_index];
            }
            if (color_index == 3)
                color_index = 0;
            else
                color_index++;
        }
        colors = new_colors;
    }
    
    public enum Face {
        FRONT, RIGHT, BACK, LEFT, TOP, BOTTOM;
        
        public int start_index() {
            switch (this) {
                case FRONT:
                    return 0;
                case RIGHT:
                    return 16;
                case BACK:
                    return 32;
                case LEFT:
                    return 48;
                case TOP:
                    return 64;
                case BOTTOM:
                    return 80;
                default:
                    assert_not_reached();
            }
        }
        
        public int end_index() {
            switch (this) {
                case FRONT:
                    return 15;
                case RIGHT:
                    return 31;
                case BACK:
                    return 47;
                case LEFT:
                    return 63;
                case TOP:
                    return 79;
                case BOTTOM:
                    return 95;
                default:
                    assert_not_reached();
            }
        }
    }
}