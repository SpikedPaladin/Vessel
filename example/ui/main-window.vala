using Vessel;

[GtkTemplate (ui = "/example/window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    public unowned Gtk.GLArea area;
    [GtkChild]
    public unowned Gtk.ToggleButton toggle_pause;
    [GtkChild]
    private unowned Adw.ComboRow render_mode_row;
    [GtkChild]
    private unowned Adw.PreferencesGroup objects;
    [GtkChild]
    private unowned Gtk.Popover object_popover;
    [GtkChild]
    private unowned Adw.SpinRow center_x;
    [GtkChild]
    private unowned Adw.SpinRow center_y;
    [GtkChild]
    private unowned Adw.SpinRow center_z;
    
    public ArcballCamera camera = new ArcballCamera();
    private Viewport viewport;
    private Material wave_material;
    public int render_mode = -1;
    
    public MainWindow(Gtk.Application app) {
        Object(application: app);
        
        render_mode_row.notify["selected"].connect(() => render_mode = (int) render_mode_row.selected);
        
        center_x.notify["value"].connect(() => update_eye());
        center_y.notify["value"].connect(() => update_eye());
        center_z.notify["value"].connect(() => update_eye());
        
        wave_material = new ShaderMaterial(new VertexShader.from_uri("resource:///example/wave-vertex.glsl"));
        
        area.set_allowed_apis(Gdk.GLAPI.GL);
        
        area.add_tick_callback(() => {
            if (!toggle_pause.active)
                area.queue_render();
            
            return true;
        });
    }
    
    private void update_eye() {
        camera.center = Vec3.from_data((float) center_x.value, (float) center_y.value, (float) center_z.value);
        camera.look_at();
    }
    
    [GtkCallback]
    public bool zoom(double x, double y) {
        if (y > 0) {
            camera.move_forward(-0.05F);
        } else
            camera.move_forward(0.05F);
        camera.look_at();
        return true;
    }
    
    [GtkCallback]
    public void on_add_object() {
        object_popover.popup();
    }
    
    [GtkCallback]
    public void add_cube() {
        add_object("Cube",
            new Mesh3D() {
                mesh = new BoxMesh()
            }
        );
    }
    
    [GtkCallback]
    public void add_sphere() {
        add_object("Sphere",
            new Mesh3D() {
                mesh = new SphereMesh(1, 50, 50)
            }
        );
    }
    
    [GtkCallback]
    public void add_wave_sphere() {
        add_object("Wave Sphere",
            new Mesh3D() {
                mesh = new SphereMesh(2, 60, 60) {
                    material = wave_material
                }
            }
        );
    }
    
    [GtkCallback]
    public void add_rubik_cube() {
        add_object("Rubik Cube", new RubikCube());
    }
    
    [GtkCallback]
    public void add_chess_board() {
        try {
            add_object("Chess Board", new Mesh3D() {
                scale = Vec3.from_data(4, 4, 4),
                mesh = WavefrontLoader.load(@"/example/models/ChessBoard.obj", "/example/materials", "/example/textures")
            });
        } catch (Error error) {
            message(@"Error while loading ChessBoard.obj: $(error.message)");
        }
    }
    
    public void add_object(string name, Node3D object) {
        object_popover.popdown();
        viewport.current_scene.add_child(object);
        var row = new Adw.ExpanderRow() {
            title = name
        };
        
        if (object is RubikCube) {
            var scramble_row = new Adw.EntryRow() {
                title = "Scramble",
                show_apply_button = true
            };
            scramble_row.apply.connect(() => ((RubikCube) object).run_scramble(scramble_row.text));
            row.add_row(scramble_row);
            
            var reset_row = new Adw.ActionRow() {
                title = "Reset"
            };
            Gtk.Button suffix;
            reset_row.add_suffix(suffix = new Gtk.Button() {
                valign = Gtk.Align.CENTER,
                icon_name = "view-refresh-symbolic",
                tooltip_text = "Reset",
                css_classes = { "flat" }
            });
            suffix.clicked.connect(((RubikCube) object).reset);
            row.add_row(reset_row);
        }
        
        var x_row = new Adw.SpinRow.with_range(-10, 10, 0.1) {
            title = "X",
            @value = 0
        };
        object.bind_property("x", x_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(x_row);
        
        var y_row = new Adw.SpinRow.with_range(-10, 10, 0.1) {
            title = "Y",
            @value = 0
        };
        object.bind_property("y", y_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(y_row);
        
        var z_row = new Adw.SpinRow.with_range(-10, 10, 0.1) {
            title = "Z",
            @value = 0
        };
        object.bind_property("z", z_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(z_row);
        
        Gtk.Button suffix;
        row.add_suffix(suffix = new Gtk.Button() {
            valign = Gtk.Align.CENTER,
            icon_name = "edit-delete-symbolic",
            tooltip_text = "Delete",
            css_classes = { "flat" }
        });
        suffix.clicked.connect(() => {
            viewport.current_scene.children.remove(object);
            objects.remove(row);
        });
        objects.add(row);
    }
    
    [GtkCallback]
    public void on_rotate(double x, double y) {
        camera.on_rotate(x, y, area.get_width() / 2, area.get_height() / 2);
    }
    
    [GtkCallback]
    public void on_start_rotate(double x, double y) {
        camera.last_mouse_pos_x = 0;
        camera.last_mouse_pos_y = 0;
    }
    
    [GtkCallback]
    public void on_fp_rotate(double x, double y) {
        camera.yaw((float) (x - camera.last_mouse_pos_x) * 0.001F);
        camera.pitch((float) (y - camera.last_mouse_pos_y) * 0.001F);
        camera.last_mouse_pos_x = x;
        camera.last_mouse_pos_y = y;
        camera.look_at();
    }
    
    [GtkCallback]
    public void on_start_fp_rotate(double x, double y) {
        camera.last_mouse_pos_x = 0;
        camera.last_mouse_pos_y = 0;
    }
    
    [GtkCallback]
    public bool on_render(Gtk.GLArea area, Gdk.GLContext ctx) {
        // switch (render_mode) {
        //     case 0:
        //         GL.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_FILL);
        //         render_mode = -1;
        //         break;
        //     case 1:
        //         GL.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE);
        //         render_mode = -1;
        //         break;
        //     case 2:
        //         GL.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_POINT);
        //         render_mode = -1;
        //         break;
        // }
        
        // wave_material.time++;
        
        viewport.render();
        return true;
    }
    
    [GtkCallback]
    public void on_realize(Gtk.Widget area) {
        (area as Gtk.GLArea)?.make_current();
        viewport = new Viewport();
        viewport.current_camera = camera;
        viewport.current_camera.position = Vec3.from_data(0, 0, 3);
        viewport.current_camera.look_at();
        add_object("Debug Grid", new GridFloor());
        add_object("Example Cube",
            new Mesh3D() {
                mesh = new BoxMesh()
            }
        );
    }
    
    [GtkCallback]
    public void on_resize(int width, int height) {
        viewport.resize(width, height);
    }
}
