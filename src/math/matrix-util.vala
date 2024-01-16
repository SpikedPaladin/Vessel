using GL;

namespace Vessel {
    
    private static float det_helper3(
        [CCode (array_length = false)] float[] col1,
        [CCode (array_length = false)] float[] col2,
        [CCode (array_length = false)] float[] col3
    ) {
        return col1[0] * (col2[1] * col3[2] - col2[2] * col3[1])
             + col2[0] * (col3[1] * col1[2] - col3[2] * col1[1])
             + col3[0] * (col1[1] * col2[2] - col1[2] * col2[1]);
    }
}
