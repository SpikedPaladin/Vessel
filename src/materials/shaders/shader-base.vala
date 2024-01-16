namespace Vessel {
    
    public abstract class ShaderBase {
        
        /**
         * This enum contains a mapping to GLSL data types names.
         */
        public enum DataType {
            FLOAT, VEC2, VEC3, VEC4,
            INT, IVEC2, IVEC3, IVEC4,
            BOOL, BVEC2, BVEC3, BVEC4,
            MAT2, MAT3, MAT4, VOID, SAMPLER1D,
            SAMPLER2D, SAMPLER3D, SAMPLERCUBE, SAMPLER_EXTERNAL_EOS, CONSTANT;
            
            public string to_string() {
                switch (this) {
                    case FLOAT:
                        return "float";
                    case VEC2:
                        return "vec2";
                    case VEC3:
                        return "vec3";
                    case VEC4:
                        return "vec4";
                    case INT:
                        return "int";
                    case IVEC2:
                        return "ivec2";
                    case IVEC3:
                        return "ivec3";
                    case IVEC4:
                        return "ivec4";
                    case BOOL:
                        return "bool";
                    case BVEC2:
                        return "bvec2";
                    case BVEC3:
                        return "bvec3";
                    case BVEC4:
                        return "bvec4";
                    case MAT2:
                        return "mat2";
                    case MAT3:
                        return "mat3";
                    case MAT4:
                        return "mat4";
                    case VOID:
                        return "void";
                    case SAMPLER1D:
                        return "sampler1D";
                    case SAMPLER2D:
                        return "sampler2D";
                    case SAMPLER3D:
                        return "sampler3D";
                    case SAMPLERCUBE:
                        return "samplerCube";
                    case SAMPLER_EXTERNAL_EOS:
                        return "samplerExternalOES";
                    case CONSTANT:
                        return "constant";
                    default:
                        assert_not_reached();
                }
            }
        }
        
        /**
         * The default shader variables are used in the default vertex and fragment shader. They define
         * variables for matrices, position, texture attributes, etc. These shader variables can be used
         * by custom shaders as well. When one of these variables is required the {@link AShader#getGlobal(IGlobalShaderVar)}
         * method can be called. For instance:
         * <pre><code>
         * // (in a class that inherits from AShader):
         * RVec4 position = (RVec4) getGlobal(DefaultShaderVar.G_POSITION);
         * </code></pre>
         */
        public enum DefaultShaderVar {
            U_MVP_MATRIX, U_NORMAL_MATRIX, U_MODEL_MATRIX;
            // U_INVERSE_VIEW_MATRIX("uInverseViewMatrix", DataType.MAT4), U_MODEL_VIEW_MATRIX("uModelViewMatrix", DataType.MAT4), U_COLOR("uColor", DataType.VEC4), 
            // U_COLOR_INFLUENCE("uColorInfluence", DataType.FLOAT), U_INFLUENCE("uInfluence", DataType.FLOAT),
            // U_TRANSFORM("uTransform", DataType.MAT3), U_TIME("uTime", DataType.FLOAT),
            // A_POSITION("aPosition", DataType.VEC4), A_TEXTURE_COORD("aTextureCoord", DataType.VEC2), A_NORMAL("aNormal", DataType.VEC3), A_VERTEX_COLOR("aVertexColor", DataType.VEC4),
            // V_TEXTURE_COORD("vTextureCoord", DataType.VEC2), V_CUBE_TEXTURE_COORD("vCubeTextureCoord", DataType.VEC3), V_NORMAL("vNormal", DataType.VEC3), V_COLOR("vColor", DataType.VEC4), V_EYE_DIR("vEyeDir", DataType.VEC3),
            // G_POSITION("gPosition", DataType.VEC4), G_NORMAL("gNormal", DataType.VEC3), G_COLOR("gColor", DataType.VEC4), G_TEXTURE_COORD("gTextureCoord", DataType.VEC2), G_SHADOW_VALUE("gShadowValue", DataType.FLOAT),
            // G_SPECULAR_VALUE("gSpecularValue", DataType.FLOAT);
          
            public string to_string() {
                switch (this) {
                    case U_MVP_MATRIX:
                        return "uMVPMatrix";
                    case U_NORMAL_MATRIX:
                        return "uNormalMatrix";
                    case U_MODEL_MATRIX:
                        return "uModelMatrix";
                    default:
                        assert_not_reached();
                }
            }
            
            public DataType get_data_type() {
                switch (this) {
                    case U_MVP_MATRIX:
                        return DataType.MAT4;
                    case U_NORMAL_MATRIX:
                        return DataType.MAT3;
                    case U_MODEL_MATRIX:
                        return DataType.MAT4;
                    default:
                        assert_not_reached();
                }
            }
        }

        /**
         * Precision qualifier. There are three precision qualifiers: highp​, mediump​, and lowp​. 
         * They have no semantic meaning or functional effect. They can apply to any floating-point 
         * type (vector or matrix), or any integer type.
         */
        public enum Precision {
            LOWP, HIGHP, MEDIUMP;
            
            public string to_string() {
                switch (this) {
                    case LOWP:
                        return "lowp";
                    case HIGHP:
                        return "highp";
                    case MEDIUMP:
                        return "mediump";
                    default:
                        assert_not_reached();
                }
            }
        }
        
        protected int mVarCount;
        protected string shader;
        
        /**
         * Returns an instance of a GLSL data type for the given {@link DataType}.
         * A new {@link ShaderVar} with the specified name will be created.
         * 
         * @param name
         * @param dataType
         * @return
         */
        protected static ShaderVar? getInstanceForDataType(DataType dataType, string? name = null) {
            switch(dataType) {
                case INT:
                    return new RInt(name);
                case FLOAT:
                    return new RFloat(name);
                case VEC2:
                    return new RVec2(name);
                case VEC3:
                    return new RVec3(name);
                case VEC4:
                    return new RVec4(name);
                case MAT3:
                    return new RMat3(name);
                case MAT4:
                    return new RMat4(name);
                case BOOL:
                    return new RBool(name);
                case SAMPLER2D:
                    return new RSampler2D(name);
                case SAMPLERCUBE:
                    return new RSamplerCube(name);
                case SAMPLER_EXTERNAL_EOS:
                    return new RSamplerExternalOES(name);
                default:
                    return null;
            }
        }
        
        /**
         * This method determines what data type to return for operations
         * like multiplication, addition, subtraction, etc.
         * 
         * @param left
         * @param right
         * @return
         */
        protected static ShaderVar getReturnTypeForOperation(DataType left, DataType right) {
            ShaderVar result = null;
            
            if(left != right)
                result = getInstanceForDataType(left);
            else if(left == DataType.IVEC4 || right == DataType.IVEC4)
                result = getInstanceForDataType(DataType.IVEC4);
            else if(left == DataType.IVEC3 || right == DataType.IVEC3)
                result = getInstanceForDataType(DataType.IVEC3);
            else if(left == DataType.IVEC2 || right == DataType.IVEC2)
                result = getInstanceForDataType(DataType.IVEC2);
            else if(left == DataType.VEC4 || right == DataType.VEC4)
                result = getInstanceForDataType(DataType.VEC4);
            else if(left == DataType.VEC3 || right == DataType.VEC3)
                result = getInstanceForDataType(DataType.VEC3);
            else if(left == DataType.VEC2 || right == DataType.VEC2)
                result = getInstanceForDataType(DataType.VEC2);
            else if(left == DataType.MAT4 || right == DataType.MAT4)
                result = getInstanceForDataType(DataType.MAT4);
            else if(left == DataType.MAT3 || right == DataType.MAT3)
                result = getInstanceForDataType(DataType.MAT3);
            else if(left == DataType.MAT2 || right == DataType.MAT2)
                result = getInstanceForDataType(DataType.MAT2);
            else if(left == DataType.FLOAT || right == DataType.FLOAT)
                result = getInstanceForDataType(DataType.FLOAT);
            else
                result = getInstanceForDataType(DataType.INT);
            
            return result;
        }
        
        /**
         * Defines a 2 component vector of floats. This corresponds to the vec2 GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RVec2 : ShaderVar {
            
            public RVec2.empty() {
                base(null, DataType.VEC2);
            }
            
            public RVec2(string name) {
                base(name, DataType.VEC2);
            }
            
            public ShaderVar xy() {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name.xy");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar x() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.x");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar y() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.y");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar s() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.s");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar t() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.t");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar index(int index) {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name[$index]");
                return v;
            }
            
            public new void assign(float val, string type = "vec2") {
                base.assign(@"$type($val)");
            }
            
            public void assign_vec(float value1, float value2) {
                base.assign(@"vec2($value1, $value2)");
            }
            
            public void assign_string(string val, string type) {
                base.assign(@"$type($val)");
            }
        }
        
        /**
         * Defines a 3 component vector of floats. This corresponds to the vec3 GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RVec3 : RVec2 {
            
            public RVec3(string? name = null) {
                base.with_type(name, DataType.VEC3);
            }
            
            public ShaderVar xyz() {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name.xyz");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar rgb() {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name.rgb");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar r() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.r");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar g() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.g");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar b() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.b");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar z() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.z");
                v.mInitialized = true;
                return v;
            }
            
            public new void assign(float val, string type = "vec3") {
                base.assign(val, type);
            }
            
            public new void assign_vec(float value1, float value2, float value3) {
                assign_string(@"$value1, $value2, $value3", "vec3");
            }
        }
        
        /**
         * Defines a 4 component vector of floats. This corresponds to the vec4 GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RVec4 : RVec3 {
            
            public RVec4(string? name = null) {
                base.with_type(name, DataType.VEC4);
            }
            
            public ShaderVar xyzw() {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name.xyzw");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar rgba() {
                ShaderVar v = getReturnTypeForOperation(data_type, data_type);
                v.setName(@"$name.rgba");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar w() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.w");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar a() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.a");
                v.mInitialized = true;
                return v;
            }
            
            public new void assign(float val) {
                base.assign(val, "vec4");
            }
            
            public new void assign_vec(float value1, float value2, float value3, float value4) {
                assign_string(@"$value1, $value2, $value3, $value4", "vec4");
            }
        }
        
        /**
         * Defines a type that represents a 2D texture bound to the OpenGL context.
         * This corresponds the the sampler2D GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RSampler2D : RVec4 {
            
            public RSampler2D(string? name = null) {
                base.with_type(name, DataType.SAMPLER2D);
            }
        }
        
        /**
         * Defines a type that provides a mechanism for creating EGLImage texture targets
         * from EGLImages. This is used within Rajawali for video textures.
         * 
         * @author dennis.ippel
         *
         */
        protected class RSamplerExternalOES : RSampler2D {
            
            public RSamplerExternalOES(string? name = null) {
                base.with_type(name, DataType.SAMPLER_EXTERNAL_EOS);
            }
        }

        /**
         * Defines a type that represents a cubic texture. A sampler cube consists of 
         * 6 textures. This corresponds to the samplerCube GLSL data type. 
         * 
         * @author dennis.ippel
         *
         */
        protected class RSamplerCube : RSampler2D {
            
            public RSamplerCube(string? name = null) {
                base.with_type(name, DataType.SAMPLERCUBE);
            }
        }
        
        /**
         * @author dennis.ippel
         * 
         * Defines a bool. This corresponds to the bool GLSL data type.
         *
         */
        protected class RBool : ShaderVar {
            
            public RBool.empty() {
                base(null, DataType.BOOL);
            }
            
            public RBool(string name) {
                base(name, DataType.BOOL);
            }
        }
        
        /**
         * Defines a 3x3 matrix. This corresponds to the mat3 GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RMat3 : ShaderVar {
            
            public RMat3(string? name = null) {
                base(name, DataType.MAT3);
            }
        }
        
        /**
         * Defines a 4x4 matrix. This corresponds to the mat4 GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RMat4 : RMat3 {
            
            public RMat4.empty() {
                base.with_type(null, DataType.MAT4);
            }
            
            public RMat4(string name) {
                base.with_type(name, DataType.MAT4);
            }
            
            public new void setValue(
                float m00, float m01, float m02, float m03,
                float m10, float m11, float m12, float m13,
                float m20, float m21, float m22, float m23,
                float m30, float m31, float m32, float m33
            ) {
                mValue = @"mat4($m00, $m01, $m02, $m03, $m10, $m11, $m12, $m13, $m20, $m21, $m22, $m23, $m30, $m31, $m32, $m33)";
            }
        }
        
        /**
         * Defines the position of the current vertex. This is used in the vertex shader to
         * write the final vertex position to. This corresponds to the gl_Position GLSL variable.
         * 
         * @author dennis.ippel
         *
         */
        protected sealed class GLPosition : RVec4 {
            
            public GLPosition() {
                base("gl_Position");
                mInitialized = true;
            }
        }
        
        /**
         * Defines the color of the current fragment. This is used in the fragment shader to
         * write the final fragment color to. This corresponds to the gl_FragColor GLSL variable.
         * 
         * @author dennis.ippel
         *
         */
        protected sealed class GLFragColor : RVec4 {
            
            public GLFragColor() {
                base("gl_FragColor");
                mInitialized = true;
            }
        }
         
        /**
         * Defines the two-dimensional coordinates indicating where within a point primitive 
             * the current fragment is located. This corresponds to the gl_PointCoord GLSL variable.
         */
        protected sealed class GLPointCoord : RVec2 {
            
            public GLPointCoord() {
                base("gl_PointCoord");
                mInitialized = true;
            }
        }
         
        /**
         * Defines an output that receives the intended size of the point to be rasterized,
         * in pixels. This corresponds to the gl_PointSize GLSL variable.
         */
        protected sealed class GLPointSize : RFloat {
            
            public GLPointSize() {
                base("gl_PointSize");
                mInitialized = true;
            }
        }
        
        /**
         * Contains the window-relative coordinates of the current fragment
         * 
         * @author dennis.ippel
         */
        protected sealed class GLFragCoord : RVec4 {
            
            public GLFragCoord() {
                base("gl_FragCoord");
                mInitialized = true;
            }
        }
        
        protected sealed class GLDepthRange : RVec3 {
            
            public GLDepthRange() {
                base("gl_DepthRange");
                mInitialized = true;
            }
            
            public ShaderVar near() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.near");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar far() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.far");
                v.mInitialized = true;
                return v;
            }
            
            public ShaderVar diff() {
                ShaderVar v = new RFloat();
                v.setName(@"$name.diff");
                v.mInitialized = true;
                return v;
            }
        }
        
        /**
         * Defines a floating point data type. This corresponds to the float GLSL data type.
         * 
         * @author dennis.ippel
         */
        protected class RFloat : ShaderVar {
            
            public RFloat(string? name = null) {
                base(name, DataType.FLOAT);
            }
            
            public new void setValue(float val) {
                base.setValue(val.to_string());
            }
        }

        /**
         * Defines an integer data type. This corresponds to the int GLSL data type.
         * 
         * @author dennis.ippel
         *
         */
        protected class RInt : ShaderVar {
            
            public RInt.empty() {
                base.with_type(null, DataType.INT);
            }
            
            public RInt(string name) {
                base(name, DataType.INT);
            }
        }

        /**
         * A ShaderVar is a wrapper class for a GLSL variable. It is used to write shaders
         * in the Vala programming language. Shaders are text files that are compiled at runtime.
         * The {@link AShader} class uses ShaderVars to write a text file under the hood.
         * The reason for this is maintainability and shader code reuse.
         */
        protected class ShaderVar {
            protected string name;
            protected DataType data_type;
            protected string mValue;
            protected bool mIsGlobal;
            protected bool mInitialized;
            protected bool mIsArray;
            protected int mArraySize;
            
            public ShaderVar.empty() {}
            
            public ShaderVar.with_type(string? name, DataType type) {
                this(name, type, null);
            }
            
            public ShaderVar.with_var(string? name, DataType type, ShaderVar val) {
                this(name, type, val.getName());
            }
            
            public ShaderVar.with_string(string? name, DataType type, string val, bool write = true) {
                this(name, type, val , write);
            }
            
            public ShaderVar(string? name, DataType dataType, string? val = null, bool write = true) {
                this.name = name;
                this.data_type = dataType;
                if (name == null) this.name = generateName();
                this.mValue = val;
                
                if (write && val != null)
                    writeInitialize(val);
            }
            
            public void setName(string name) {
                this.name = name;
            }
            
            public string getName() {
                return this.name;
            }
            
            public DataType getDataType() {
                return this.data_type;
            }
            
            public string getValue() {
                return this.mValue;
            }
            
            public void setValue(string val) {
                mValue = val;
            }		
            
            /**
             * Adds two shader variables. Equivalent to GLSL's '+' operator.
             * 
             * @param val
             * @return
             */
            public ShaderVar add(ShaderVar val) {
                ShaderVar v = getReturnTypeForOperation(data_type, val.getDataType());
                v.setValue(@"$name + $(val.getName())");
                v.setName(v.getValue());
                return v;
            }

            public ShaderVar add_float(float val) {
                ShaderVar v = getReturnTypeForOperation(data_type, DataType.FLOAT);
                v.setValue(@"$name + $val");
                v.setName(v.getValue());
                return v;
            }
            
            /**
             * Subtracts two shader variables. Equivalent to GLSL's '-' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar subtract(ShaderVar val) {
                ShaderVar v = getReturnTypeForOperation(data_type, val.getDataType());
                v.setValue(@"$name - $(val.getName())");
                v.setName(v.getValue());
                return v;
            }
            
            /**
             * Subtracts two shader variables. Equivalent to GLSL's '-' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar subtract_float(float val) {
                ShaderVar v = getReturnTypeForOperation(data_type, DataType.FLOAT);
                v.setValue(@"$name - $val");
                v.setName(v.getValue());
                return v;
            }
            
            /**
             * Multiplies two shader variables. Equivalent to GLSL's '*' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar multiply(ShaderVar val) {
                ShaderVar v = getReturnTypeForOperation(data_type, val.getDataType());
                
                v.setValue(@"$name * $(val.getName())");
                v.setName(v.getValue());
                return v;
            }
            
            /**
             * Multiplies two shader variables. Equivalent to GLSL's '*' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar multiply_float(float val) {
                ShaderVar v = getReturnTypeForOperation(data_type, DataType.FLOAT);
                v.setValue(@"$name * $val");
                v.setName(v.getValue());
                return v;
            }		
            
            /**
             * Divides two shader variables. Equivalent to GLSL's '/' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar divide(ShaderVar val) {
                ShaderVar v = getReturnTypeForOperation(data_type, val.getDataType());
                v.setValue(@"$name / $(val.name)");
                v.setName(v.getValue());
                return v;
            }
            
            public ShaderVar divide_float(float val) {
                ShaderVar v = getReturnTypeForOperation(data_type, DataType.FLOAT);
                v.setValue(@"$name / $val");
                v.setName(v.getValue());
                return v;
            }
            
            /**
             * Divides the value of one shader variable by the value of another and 
             * returns the remainder. Equivalent to GLSL's '%' operator.
             * 
             * @param value
             * @return
             */
            public ShaderVar modulus(ShaderVar val) {
                ShaderVar v = getReturnTypeForOperation(data_type, val.getDataType());
                v.setValue(@"$name % $(val.name)");
                v.setName(v.getValue());
                return v;
            }

            /**
             * Assigns a value to a shader variable. Equivalent to GLSL's '=' operator.
             * 
             * @param value
             */
            public void assign_var(ShaderVar val) {
                assign(val.getValue() != null ? val.getValue() : val.getName());
            }
            
            /**
             * Assigns a value to a shader variable. Equivalent to GLSL's '=' operator.
             * 
             * @param value
             */
            public void assign(string val) {
                writeAssign(val);
            }
            
            /**
             * Assigns a value to a shader variable. Equivalent to GLSL's '=' operator.
             * 
             * @param value
             */
            public void assign_float(float val) {
                assign(val.to_string());
            }
            
            /**
             * Assigns and adds a value to a shader variable. Equivalent to GLSL's '+=' operator.
             * 
             * @param value
             */
            public void assign_add_var(ShaderVar val) {
                assign_add(val.getName());
            }
            
            /**
             * Assigns and adds a value to a shader variable. Equivalent to GLSL's '+=' operator.
             * 
             * @param value
             */
            public void assign_add_float(float val) {
                assign_add(val.to_string());
            }
            
            /**
             * Assigns and adds a value to a shader variable. Equivalent to GLSL's '+=' operator.
             * 
             * @param value
             */
            public void assign_add(string val) {
                print(@"$name += $val;\n");
            }
            
            /**
             * Assigns and subtracts a value to a shader variable. Equivalent to GLSL's '-=' operator.
             * 
             * @param value
             */
            public void assign_subtract_var(ShaderVar val) {
                assign_subtract(val.getName());
            }
            
            /**
             * Assigns and subtracts a value to a shader variable. Equivalent to GLSL's '-=' operator.
             * 
             * @param value
             */
            public void assign_subtract_float(float val) {
                assign_subtract(val.to_string());
            }
            
            /**
             * Assigns and subtracts a value to a shader variable. Equivalent to GLSL's '-=' operator.
             * 
             * @param value
             */
            public void assign_subtract(string val) {
                print(@"$name -= $val;\n");
            }
            
            /**
             * Assigns and Multiplies a value to a shader variable. Equivalent to GLSL's '*=' operator.
             * 
             * @param value
             */
            public void assign_multiply_var(ShaderVar val) {
                assign_multiply(val.getName());
            }
            
            /**
             * Assigns and Multiplies a value to a shader variable. Equivalent to GLSL's '*=' operator.
             * 
             * @param value
             */
            public void assign_multiply_float(float val) {
                assign_multiply(val.to_string());
            }
            
            /**
             * Assigns and Multiplies a value to a shader variable. Equivalent to GLSL's '*=' operator.
             * 
             * @param value
             */
            public void assign_multiply(string val) {
                print(@"$name *= $val;\n");
            }
            
            protected void writeAssign(string val) {
                if(!mIsGlobal && !mInitialized) {
                    writeInitialize(val);
                } else {
                    print(@"$name = $val;\n");
                }
            }
            
            protected void writeInitialize(string? val = null) {
                print(@"$data_type ");
                mInitialized = true;
                writeAssign(val ?? mValue);
            }
            
            public string getVarName() {
                return name;
            }
            
            protected string generateName() {
                return @"v_$data_type$(Random.next_int())";
            }
            
            /**
             * Indicate that this is a global variable. Global variables are uniforms, attributes, varyings, etc.
             * 
             * @param value
             */
            protected void isGlobal(bool val) {
                mIsGlobal = val;
            }
            
            /**
             * Indicates that this is a global variable. Global variables are uniforms, attributes, varyings, etc.
             * 
             * @return
             */
            protected bool is_global() {
                return mIsGlobal;
            }
            
            public void isArray(int size) {
                mIsArray = true;
                mArraySize = size;
            }
            
            public bool is_array() {
                return mIsArray;
            }
            
            public int getArraySize() {
                return mArraySize;
            }
            
            /**
             * Get an element from an array. Equivalent to GLSL's '[]' indexing operator.
             * 
             * @param index
             * @return
             */
            public ShaderVar element_at_index(int index) {
                return element_at_string(index.to_string());
            }
            
            /**
             * Get an element from an array. Equivalent to GLSL's '[]' indexing operator.
             * 
             * @return
             */
            public ShaderVar element_at(ShaderVar val) {
                return element_at_string(val.getVarName());
            }
            
            /**
             * Get an element from an array. Equivalent to GLSL's '[]' indexing operator.
             * 
             * @param index
             */
            public ShaderVar element_at_string(string index) {
                ShaderVar v = new ShaderVar.with_type(null, data_type);
                v.setName(@"$name[$index]");
                v.mInitialized = true;
                return v;
            }
            
            /**
             * Negates the value of a shader variable. Similar to prefixing '-' in GLSL.
             */
            public ShaderVar negate() {
                var v = new ShaderVar.with_type(null, data_type);
                v.setName(@"-$name");
                v.mInitialized = true;
                return v;
            }
        }
    }
}