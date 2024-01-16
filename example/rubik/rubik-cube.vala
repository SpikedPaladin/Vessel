using Vessel;

public class RubikCube : Object3D {
    private float[] red = { 1, 0, 0 };
    private float[] green = { 0, 1, 0 };
    private float[] blue = { 0, 0, 1 };
    private float[] yellow = { 1, 1, 0 };
    private float[] orange = { 1, 0.5F, 0 };
    private float[] white = { 1, 1, 1 };
    
    private ColoredCube[]? cubes;
    private AnimationQueue queue;
    
    construct {
        queue = new AnimationQueue();
        
        cubes = {
            // Top back, ltr
            new ColoredCube() { x = -1.05F, y = 1.05F, z = -1.05F },
            new ColoredCube() { x = 0F, y = 1.05F, z = -1.05F },
            new ColoredCube() { x = 1.05F, y = 1.05F, z = -1.05F },
            // Top middle, ltr
            new ColoredCube() { x = -1.05F, y = 1.05F, z = 0 },
            new ColoredCube() { x = 0F, y = 1.05F, z = 0 },
            new ColoredCube() { x = 1.05F, y = 1.05F, z = 0 },
            // Top front, ltr
            new ColoredCube() { x = -1.05F, y = 1.05F, z = 1.05F },
            new ColoredCube() { x = 0F, y = 1.05F, z = 1.05F },
            new ColoredCube() { x = 1.05F, y = 1.05F, z = 1.05F },
            // Middle back, ltr
            new ColoredCube() { x = -1.05F, y = 0, z = -1.05F },
            new ColoredCube() { x = 0F, y = 0, z = -1.05F },
            new ColoredCube() { x = 1.05F, y = 0, z = -1.05F },
            // Middle middle, ltr
            new ColoredCube() { x = -1.05F, y = 0, z = 0 },
            null,
            new ColoredCube() { x = 1.05F, y = 0, z = 0 },
            // Middle front, ltr
            new ColoredCube() { x = -1.05F, y = 0, z = 1.05F },
            new ColoredCube() { x = 0F, y = 0, z = 1.05F },
            new ColoredCube() { x = 1.05F, y = 0, z = 1.05F },
            // Bottom back, ltr
            new ColoredCube() { x = -1.05F, y = -1.05F, z = -1.05F },
            new ColoredCube() { x = 0F, y = -1.05F, z = -1.05F },
            new ColoredCube() { x = 1.05F, y = -1.05F, z = -1.05F },
            // Bottom middle, ltr
            new ColoredCube() { x = -1.05F, y = -1.05F, z = 0 },
            new ColoredCube() { x = 0F, y = -1.05F, z = 0 },
            new ColoredCube() { x = 1.05F, y = -1.05F, z = 0 },
            // Bottom front, ltr
            new ColoredCube() { x = -1.05F, y = -1.05F, z = 1.05F },
            new ColoredCube() { x = 0F, y = -1.05F, z = 1.05F },
            new ColoredCube() { x = 1.05F, y = -1.05F, z = 1.05F },
        };
        
        // Paint top
        for (int i = 0; i < 9; i++)
            cubes[i].set_face_color(ColoredCube.Face.TOP, white);
        
        // Paint bottom
        for (int i = 18; i < 27; i++)
            cubes[i].set_face_color(ColoredCube.Face.BOTTOM, yellow);
        
        // paint left
        for (int i = 0; i < 27; i += 3)
            cubes[i].set_face_color(ColoredCube.Face.LEFT, orange);
        
        // paint right
        for (int i = 2; i < 27; i += 3)
            cubes[i].set_face_color(ColoredCube.Face.RIGHT, red);
        
        // paint back
        for (int i = 0; i < 27; i += 9)
            for (int j = 0; j < 3; j++)
                cubes[i + j].set_face_color(ColoredCube.Face.BACK, blue);
        
        // paint front
        for (int i = 6; i < 27; i += 9)
            for (int j = 0; j < 3; j++)
                cubes[i + j].set_face_color(ColoredCube.Face.FRONT, green);
        
        foreach (var cube in cubes)
            if (cube != null)
                add_child(cube);
    }
    
    public void reset() {
        foreach (var cube in cubes) {
            if (cube == null)
                continue;
            
            queue.pop_all();
            cube.position = cube.initial_position;
            cube.push_position();
            cube.rotation_x = 0;
            cube.rotation_y = 0;
            cube.rotation_z = 0;
        }
    }
    
    public void run_scramble(string scramble) {
        bool backward = false;
        bool twice = false;
        
        var list = new List<AnimInfo?>();
        for (int char_index = scramble.char_count(); char_index > -1; char_index--) {
            
            var ch = scramble.get_char(char_index);
            if (ch == '\'') {
                backward = true;
                continue;
            } else if (ch == '2') {
                twice = true;
                continue;
            } else if (ch == 'R') {
                list.append(AnimInfo() { side = 'R', backward = !backward, twice = twice });
            } else if (ch == 'U') {
                list.append(AnimInfo() { side = 'U', backward = !backward, twice = twice });
            } else if (ch == 'L') {
                list.append(AnimInfo() { side = 'L', backward = backward, twice = twice });
            }
            
            backward = twice = false;
        }
        
        list.reverse();
        
        foreach (var anim in list) {
            if (anim.twice)
                push_animation(anim.side, vec_from_side(anim.side), anim.backward);
            
            push_animation(anim.side, vec_from_side(anim.side), anim.backward);
        }
    }
    
    public Vec3 vec_from_side(unichar side) {
        switch (side) {
            case 'R':
            case 'L':
                return Vec3.right();
            case 'U':
                return Vec3.front();
            default:
                assert_not_reached();
        }
    }
    
    public void push_animation(unichar side, Vec3 axis, bool backward) {
        float progress = 0;
        float amount = backward ? -1 : 1;
        
        ColoredCube[] targets = {};
        queue.push(new Animation() {
            begin = () => {
                if (side == 'U')
                    targets = get_up_cubes();
                else if (side == 'R')
                    targets = get_right_cubes();
                else if (side == 'L')
                    targets = get_left_cubes();
            },
            execute = () => {
                progress += amount;
                
                for (int i = 0; i < targets.length; i++) {
                    Vec4 pos = Vec4.from_data(targets[i].prev_position.x, targets[i].prev_position.y, targets[i].prev_position.z, 1);
                    Mat4 rotation_x = Mat4.identity();
                    rotation_x.rotate(progress, ref axis);
                    pos = rotation_x.mul_vec(ref pos);
                    
                    if (axis in Vec3.from_data(0, 1, 0))
                        targets[i].rotation_y += amount;
                    else if (axis in Vec3.from_data(1, 0, 0))
                        targets[i].rotate_x(amount);
                    else
                        targets[i].rotate_z(amount);
                    targets[i].position = Vec3.from_array(pos.data);
                }
            },
            run_until = () => (backward && progress <= -90) || (!backward && progress >= 90),
            end = () => {
                foreach (var cube in targets)
                    cube.push_position();
            }
        });
    }
    
    public override void render(Camera camera, Mat4? parent_matrix = null, Material? scene_material = null) {
        base.render(camera, parent_matrix, scene_material);
        
        queue.render();
        return;
    }
    
    private ColoredCube[] get_right_cubes() {
        return get_cubes((cube) => cube.x == 1.05F);
    }
    
    private ColoredCube[] get_left_cubes() {
        return get_cubes((cube) => cube.x == -1.05F);
    }
    
    private ColoredCube[] get_up_cubes() {
        return get_cubes((cube) => cube.y == 1.05F);
    }
    
    private ColoredCube[] get_cubes(ConditionFunc condition) {
        ColoredCube[] result = {};
        foreach (var cube in cubes) {
            if (cube != null && condition(cube))
                result += cube;
        }
        return result;
    }
    
    private delegate bool ConditionFunc(ColoredCube cube);
    
    private struct AnimInfo {
        unichar side;
        bool backward;
        bool twice;
    }
}