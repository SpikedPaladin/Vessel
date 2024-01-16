namespace Vessel {
    
    /**
     * Converts the given angle from degrees to radians.
     * 
     * @param deg Angle in radians
     * @return Angle in degrees
     */
    public static float deg_to_rad(float deg) {
        return (float) (deg * Math.PI / 180f);
    }
    
    /**
     * Converts the given angle from radians to degrees.
     * 
     * @param rad Angle in degrees
     * @return Angle in radians
     */
    public static float rad_to_deg(float rad) {
        return (float) (rad / Math.PI * 180f);
    }
}
