using Vessel;

public class ColoredCube : Mesh3D {
    public Vec3 initial_position = Vec3();
    public Vec3 prev_position = Vec3();
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
    
    public override void pre_render() {
        if (!initialized) {
            mesh = new Mesh();
            mesh.set_data(vertices, null, null, colors, indices, false);
            initial_position = prev_position = position;
            
            initialized = true;
        }
        
        base.pre_render();
    }
    
    public void push_position() {
        prev_position = position;
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