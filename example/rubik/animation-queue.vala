public class AnimationQueue : Object {
    public List<Animation> animations;
    
    construct {
        animations = new List<Animation>();
    }
    
    public void push(Animation animation) {
        animations.insert(animation, 0);
    }
    
    public void pop_all() {
        animations.foreach((item) => animations.remove(item));
    }
    
    public void render() {
        if (animations.is_empty())
            return;
        
        var current = animations.last().data;
        if (!current.initialized) {
            current.begin();
            current.initialized = true;
        }
        
        if (!current.run_until()) {
            current.execute();
        } else {
            current.end();
            animations.remove(current);
        }
    }
}

public class Animation {
    public bool initialized = false;
    
    public BeginFunc begin;
    public EndFunc end;
    public ExecuteFunc execute;
    public RunUntilFunc run_until;
    
    public delegate void BeginFunc();
    public delegate void EndFunc();
    public delegate void ExecuteFunc();
    public delegate bool RunUntilFunc();
}