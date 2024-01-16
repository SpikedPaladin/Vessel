namespace Vessel {
    
    public class Sphere : Object3D {
        
        public Sphere(float radius, int stacks, int sectors, bool mirror_texture_coords = false) {
            int numVertices = (stacks + 1) * (sectors + 1);
		    int numIndices = 2 * stacks * (sectors - 1) * 3;
            
		    if(numVertices < 0) return;
		    if(numIndices < 0) return;
            
		    float[] vertices = new float[numVertices * 3];
		    float[] normals = new float[numVertices * 3];
		    ushort[] indices = new ushort[numIndices];
            
		    int i, j;
		    int vertIndex = 0, index = 0;
		    float normLen = 1.0f / radius;
            
		    for (j = 0; j <= sectors; ++j) {
			    float horAngle = (float) (Math.PI * j / sectors);
			    float z = radius * (float) Math.cos(horAngle);
			    float ringRadius = radius * (float) Math.sin(horAngle);
                
			    for (i = 0; i <= stacks; ++i) {
				    float verAngle = (float) (2.0f * Math.PI * i / stacks);
				    float x = ringRadius * (float) Math.cos(verAngle);
				    float y = ringRadius * (float) Math.sin(verAngle);
                    
				    normals[vertIndex] = x * normLen;
				    vertices[vertIndex++] = x;
				    normals[vertIndex] = z * normLen;
				    vertices[vertIndex++] = z;
				    normals[vertIndex] = y * normLen;
				    vertices[vertIndex++] = y;
                    
				    if (indices.length == 0) continue;
                    
				    if (i > 0 && j > 0) {
					    int a = (stacks + 1) * j + i;
					    int b = (stacks + 1) * j + i - 1;
					    int c = (stacks + 1) * (j - 1) + i - 1;
					    int d = (stacks + 1) * (j - 1) + i;

					    if (j == sectors) {
						    indices[index++] = (ushort) a;
						    indices[index++] = (ushort) c;
						    indices[index++] = (ushort) d;
					    } else if (j == 1) {
						    indices[index++] = (ushort) a;
						    indices[index++] = (ushort) b;
						    indices[index++] = (ushort) c;
					    } else {
						    indices[index++] = (ushort) a;
						    indices[index++] = (ushort) b;
						    indices[index++] = (ushort) c;
						    indices[index++] = (ushort) a;
						    indices[index++] = (ushort) c;
						    indices[index++] = (ushort) d;
					    }
				    }
			    }
		    }
            
		    float[] texture_coords = null;
		    int numUvs = (sectors + 1) * (stacks + 1) * 2;
		    texture_coords = new float[numUvs];
            
		    numUvs = 0;
		    for (j = 0; j <= sectors; ++j) {
			    for (i = stacks; i >= 0; --i) {
                    float u = (float) i / stacks;
				    texture_coords[numUvs++] = mirror_texture_coords ? 1 - u : u;
				    texture_coords[numUvs++] = (float) j / sectors;
			    }
		    }
            
		    float[] colors = null;
            
		    int numColors = numVertices * 4;
		    colors = new float[numColors];
		    for (j = 0; j < numColors; j += 4) {
			    colors[j] = 1;
			    colors[j + 1] = 0;
			    colors[j + 2] = 0;
			    colors[j + 3] = 1;
		    }
		    
		    set_data(vertices, normals, texture_coords, colors, indices);
        }
    }
}