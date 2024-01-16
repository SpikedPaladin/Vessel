using Vessel;

[GtkTemplate (ui = "/example/window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    public unowned Gtk.GLArea area;
    [GtkChild]
    public unowned Gtk.ToggleButton toggle_pause;
    [GtkChild]
    private unowned Adw.ComboRow render_mode;
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
    
    public ArcballCameraNew camera = new ArcballCameraNew();
    private Renderer renderer;
    private float frame_count = 0;
    
    public MainWindow(Gtk.Application app) {
        Object(application: app);
        
        render_mode.notify["selected"].connect(() => renderer.current_scene.render_mode = (int) render_mode.selected);
        
        center_x.notify["value"].connect(() => update_eye());
        center_y.notify["value"].connect(() => update_eye());
        center_z.notify["value"].connect(() => update_eye());
        
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
        var new_pos = camera.position;
        if (y > 0) {
            new_pos.mul(1.05F);
        } else
            new_pos.mul(0.95F);
        camera.position = new_pos;
        camera.look_at();
        return true;
    }
    
    [GtkCallback]
    public void on_add_object() {
        object_popover.popup();
    }
    
    [GtkCallback]
    public void add_cube() {
        add_object(new Cube(1), "Cube");
    }
    
    [GtkCallback]
    public void add_sphere() {
        add_object(new Sphere(1, 50, 50) { color = Color.blue() }, "Sphere");
    }
    
    [GtkCallback]
    public void add_wave_sphere() {
        var object = new Sphere(2, 60, 60);
        object.material = new Material(new VertexShader.from_uri("resource:///example/wave-vertex.glsl"));
        add_object(object, "Wave Sphere");
    }
    
    [GtkCallback]
    public void add_rubik_cube() {
        var object = new RubikCube();
        add_object(object, "Rubik Cube");
    }
    
    public void add_object(Object3D object, string name) {
        object_popover.popdown();
        renderer.current_scene.add_child(object);
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
        
        var rx_row = new Adw.SpinRow.with_range(-360, 360, 1) {
            title = "Rotation X",
            @value = 0
        };
        object.bind_property("rotation_x", rx_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(rx_row);
        
        var ry_row = new Adw.SpinRow.with_range(-360, 360, 1) {
            title = "Rotation Y",
            @value = 0
        };
        object.bind_property("rotation_y", ry_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(ry_row);
        
        var rz_row = new Adw.SpinRow.with_range(-360, 360, 1) {
            title = "Rotation Z",
            @value = 0
        };
        object.bind_property("rotation_z", rz_row, "value", GLib.BindingFlags.BIDIRECTIONAL);
        row.add_row(rz_row);
        
        Gtk.Button suffix;
        row.add_suffix(suffix = new Gtk.Button() {
            valign = Gtk.Align.CENTER,
            icon_name = "edit-delete-symbolic",
            tooltip_text = "Delete",
            css_classes = { "flat" }
        });
        suffix.clicked.connect(() => {
            renderer.current_scene.childs.remove(object);
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
    public bool on_render(Gtk.GLArea area, Gdk.GLContext ctx) {
        area.make_current();
        
        renderer.current_scene.childs.foreach((child) => {
            child.material.time = frame_count;
        });
        frame_count++;
        
        renderer.render();
        return true;
    }
    
    [GtkCallback]
    public void on_realize(Gtk.Widget area) {
        (area as Gtk.GLArea)?.make_current();
        renderer = new Renderer();
        renderer.current_scene.camera = camera;
        renderer.current_scene.camera.position = Vec3.from_data(0, 0, 3);
        renderer.current_scene.camera.look_at();
        add_object(new Cube(1), "Example Cube");
    }
    
    [GtkCallback]
    public void on_resize(int width, int height) {
        renderer.resize(width, height);
    }
}
